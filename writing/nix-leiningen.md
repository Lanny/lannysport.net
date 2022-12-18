---
title: Nix Derivations with Leiningen
author: Lanny
date: 2022-12-14
---

# Nix Derivations with Leiningen

I wrote [some software](https://github.com/Lanny/Yinch) in Clojure several years ago now, it's not great by any means but it was an early exploration in webgl and 3D programming, and the game logic itself is kind of fun. It's been a couple years since then and it seems like the state of the art in dependency management has moved on, but when I wrote it I was using Leiningen, and my build tooling was tied in pretty tight with lein, which also manages dependencies. Fast forward half a decade and I'm trying to self host more of my stuff, using nix, and making lein and nix play well together ends up being a bit of a headache. I'm recording the solution here in hopes that someone else might have an easier go of it.

## The Problem

The crux of the problem is a common one in the nix ecosystem, there's a language-specific package manager (in this case lein) that does dependency resolution and possibly pinning, and does network IO to make that happen, but running this as part of the nix build is forbidden for the sake of reproducibility. There's a host of "<package manager>2nix" conversion utilities that take in some kind of specification of a dependency list and outputs a set of nix derivations that can be used to produce the dependencies in a reproducible fashion. No such utility exists for lein however, at least as far as I know.

In this case, lein will try to fetch dependencies as soon as you run any command, and in the sandboxed environment those calls will fail and you may be left scratching your head as the what happened.

## The Fix

Probably the _correct_ thing here would be to write a `lein2nix` utility, but that seemed like a lot of work to support a workflow I don't think is even really endorsed in the Clojure ecosystem anymore. Instead we can use what I've seen widely referred to as "fixed output derivations" but don't seem to be [documented as such](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHashMode). While the docs largely discuss fixed output derivations for use with fetching tarballs and the like we can, with a couple of hacks, use the same trick to assure nix we know what dependencies we should be getting. The rule here appears to be that if a derivation provides an output hash nix will lift the network sandbox, which seems like a reasonable compromise. The approach then is to provide a hash for the output of lein's dependency fetching and allow it to operate as usual, then package those dependencies for consumption by the app.

Now it's worth noting that we could cut a step out here and specify an output hash for the whole project's build. That would work but it has the drawback that a. the build will always have to re-download the dependencies as there would be no cache and b. we'd need to adjust the output hash each time the project's souce code changed, isolating deps to their own .

All together this looks something like:

**fixed-deps.nix**
```

with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "my-project-deps";
  buildInputs = [ pkgs.leiningen ];
  # Only source file is project.clj
  src = nix-gitignore.gitignoreSourcePure "!project.clj" ./.;

  buildPhase = ''
    # Point lein to store deps within the build dir, will fail whne attempting
    # to write to the home directory otherwise
    export HOME=$PWD
    export LEIN_HOME=$HOME/.lein
    mkdir -p $LEIN_HOME
    echo "{:user {:local-repo \"$LEIN_HOME/.m2\"}}" > $LEIN_HOME/profiles.clj

    # You can do `lein deps` here instead, but cljsbuild which I'm using here
    # has its own set of dependencies it needs to pull in seperately.
    ${pkgs.leiningen}/bin/lein cljsbuild deps

    # Lein will create files that include the timestamp of when deps were
    # fetched which seems mildly useful but will invalidate the output hash
    # if we don't remote them
    find .lein -type f -regex '.+_remote\.repositories' -delete
  '';
  installPhase = ''
    # Copy the dependencies into the output dir
    mkdir -p $out
    cp -r .lein/.m2/* $out/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  # You can set an arbitrary value here for you first run, it wil fail but
  # provide you with the actual value to put here
  outputHash = "Wj08iS1Fk1VVnrXSPrsvk8ahVnVm/gHB1g0OwtiUK2Y=";
}
```

**default.nix**
```
with import <nixpkgs> {};
let
  deps = import ./fixed-deps.nix;
in pkgs.stdenv.mkDerivation rec {
  name = "my-project";
  description = "My Project";

  buildInputs = [
    pkgs.leiningen
  ];

  src = ./.;

  buildPhase = ''
    export HOME=$PWD
    export LEIN_HOME=$HOME/.lein
    export LOCAL_REPO="${deps}"
    mkdir -p $LEIN_HOME

    # `:offline? true` flag isn't necessary, but it ensure lein won't attempt
    # to fetch deps again if they're not present (which they should all be)
    echo "{:user {:offline? true :local-repo \"$LOCAL_REPO\"}}" > $LEIN_HOME/profiles.clj

    # You build command here, `lein uberjar` might be the common case
    lein cljsbuild once
  '';

  installPhase = ''
    # Again, project dependent. Copt your build output to $out
    mkdir $out
    cp -r resources/public $out/
  '';
}
```

Note that the first time you attempt to build fixed-deps it will fail indicating
that the output hash doesn't match the actual output. This is expected, you can
just copy the actual hash, which it will provide for you, into `outputHash`.
This probably isn't a super nix-y way of doing things but that hash should be
stable and won't need to be updated until you update your dependencies.

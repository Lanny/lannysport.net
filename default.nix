with import <nixpkgs> {};
let 
  pypkgs = python-packages: with python-packages; [ pandocfilters ]; 
  python = pkgs.python3.withPackages pypkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "lanysport.net";
  description = "Lanny's personal site or whatever";

  buildInputs = [
    pkgs.pandoc
    python
  ];

  src = ./.;
  buildPhase = ''
    export PATH="$PATH:${python}/bin"
    make
  '';
}



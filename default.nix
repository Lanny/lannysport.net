with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "lanysport.net";
  description = "Lanny's personal site or whatever";

  buildInputs = [
    pkgs.pandoc
    (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      pandocfilters
    ]))
  ];

  src = ./.;
  buildPhase = ''
    make
  '';
}



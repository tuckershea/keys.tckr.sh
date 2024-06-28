{pkgs ? import <nixpkgs> {}}:
with pkgs;
  stdenv.mkDerivation {
    name = "keys";
    src = ./.;

    installPhase = ''
      mkdir -p $out
      cp -r ./static/* $out
    '';
  }

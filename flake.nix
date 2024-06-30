{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        mkKeysPackage = pkgs: import ./default.nix {inherit pkgs;};
        mkKeysApp = pkgs: (flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "keys" "${pkgs.python3}/bin/python3 -m http.server 8000 -d ${mkKeysPackage pkgs}";
          });
        mkKeysContainer = {
          hostPkgs,
          containerPkgs,
        }: (hostPkgs.dockerTools.buildLayeredImage {
          name = "keys";
          tag = "latest";
          config = {
            Cmd = ["${(mkKeysApp containerPkgs).program}"];
          };
        });
      in rec {
        packages.keys = mkKeysPackage pkgs;
        packages.default = packages.keys;

        apps.default = mkKeysApp pkgs;

        packages.ociImage-amd64 = mkKeysContainer {
          hostPkgs = pkgs.pkgsCross.gnu64;
          containerPkgs = pkgs.pkgsCross.gnu64;
          # Can change to musl64 after https://github.com/NixOS/nixpkgs/issues/266840
        };

        packages.ociImage-arm64 = mkKeysContainer {
          hostPkgs = pkgs.pkgsCross.aarch64-multiplatform;
          containerPkgs = pkgs.pkgsCross.aarch64-multiplatform;
          # Can change to aarch64-multiplatform-musl
          # after https://github.com/NixOS/nixpkgs/issues/266840
        };
      }
    );
}

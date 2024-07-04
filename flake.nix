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
            drv = pkgs.writeShellScriptBin "keys" ''
              ${pkgs.static-web-server}/bin/static-web-server \
              --root ${mkKeysPackage pkgs} \
              --index-files index.txt \
              --port 8000 \
              --health
            '';
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
          hostPkgs = pkgs.pkgsCross.musl64;
          containerPkgs = pkgs.pkgsCross.musl64;
        };

        packages.ociImage-arm64 = mkKeysContainer {
          hostPkgs = pkgs.pkgsCross.aarch64-multiplatform-musl;
          containerPkgs = pkgs.pkgsCross.aarch64-multiplatform-musl;
        };
      }
    );
}

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

        concatWords = nixpkgs.lib.strings.concatStringsSep " ";

        mkKeysPackage = pkgs: import ./default.nix {inherit pkgs;};
        mkKeysCmd = pkgs: [
          "${pkgs.static-web-server}/bin/static-web-server"
          "--root=${mkKeysPackage pkgs}"
          "--index-files=index.txt"
          "--port=8000"
          "--health"
        ];

        mkKeysApp = pkgs: (flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "keys" (concatWords (mkKeysCmd pkgs));
          });

        mkKeysContainer = {
          hostPkgs,
          containerPkgs,
        }: (hostPkgs.dockerTools.buildLayeredImage {
          name = "keys";
          tag = "latest";
          config = {
            Cmd = mkKeysCmd containerPkgs;
          };
        });
      in rec {
        packages.keys = mkKeysPackage pkgs;
        packages.default = packages.keys;

        apps.default = mkKeysApp pkgs;

        packages.ociImage-amd64 = mkKeysContainer {
          hostPkgs = pkgs.pkgsCross.musl64.pkgsStatic;
          containerPkgs = pkgs.pkgsCross.musl64.pkgsStatic;
        };

        packages.ociImage-arm64 = mkKeysContainer {
          hostPkgs = pkgs.pkgsCross.aarch64-multiplatform-musl.pkgsStatic;
          containerPkgs = pkgs.pkgsCross.aarch64-multiplatform-musl.pkgsStatic;
        };
      }
    );
}

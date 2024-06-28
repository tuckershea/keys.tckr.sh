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
      in rec {
        packages.keys = import ./default.nix {pkgs = pkgs;};
        packages.default = packages.keys;

        apps.default =
          flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "keys" "${pkgs.python3}/bin/python3 -m http.server 8000 -d ${packages.keys}";
          };
      }
    );
}

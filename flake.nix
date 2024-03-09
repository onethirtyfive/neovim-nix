{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { self, nixpkgs, neovim, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs =
          let
            overlays = [
              (prev: final: {
                neovim = neovim.packages.${prev.system}.neovim;
                vimPlugins = final.vimPlugins // {
                };
              })
              (prev: final: {
                onethirtyfive-neovim = import ./onethirtyfive-neovim { inherit pkgs; };
              })
            ];
          in import nixpkgs { inherit system overlays; };
      in
      {
        packages = rec {
          nvim = pkgs.onethirtyfive-neovim;
          default = nvim;
        };

        apps = rec {
          nvim = flake-utils.lib.mkApp { drv = self.packages.${system}.nvim; };
          default = nvim;
        };
    });
}

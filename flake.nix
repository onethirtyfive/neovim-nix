{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    # nvim plugin sources:
    copilot-lualine-nvim.url = "github:AndreM222/copilot-lualine";
    copilot-lualine-nvim.flake = false;
    gp-nvim.url = "github:Robitx/gp.nvim";
    gp-nvim.flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    neovim,
    copilot-lualine-nvim,
    gp-nvim,
  }:
  let
    systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    forEachSystem = nixpkgs.lib.genAttrs systems;

    mkPkgs =
      system:
      let
        overlays = [
          (prev: final: {
            neovim = neovim.packages.${prev.system}.neovim;
            vimPlugins = final.vimPlugins // {
              copilot-lualine = final.vimUtils.buildVimPlugin {
                name = "copilot-lualine";
                src = copilot-lualine-nvim;
              };
              gp = final.vimUtils.buildVimPlugin {
                name = "gp-nvim";
                src = gp-nvim;
              };
            };
          })
          (prev: final: {
            onethirtyfive-neovim = import ./onethirtyfive-neovim { pkgs = final; };
          })
        ];
      in import nixpkgs { inherit system overlays; };
  in
  {
    packages = forEachSystem (
      system:
      let
        pkgs = mkPkgs system;
      in rec {
        default = nvim;

        nvim = pkgs.onethirtyfive-neovim;
      }
    );

    apps = forEachSystem (
      system:
      rec {
        default = nvim;

        nvim = {
          type = "app";
          program = "${self.packages.${system}.nvim}/bin/nvim";
        };
      }
    );
  };
}

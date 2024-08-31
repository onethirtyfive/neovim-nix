{
  description = "My own Neovim flake";
  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.follows = "neovim-nightly-overlay/nixpkgs";

    # nvim plugin sources:
    copilot-lualine-nvim.url = "github:AndreM222/copilot-lualine";
    copilot-lualine-nvim.flake = false;
    gp-nvim.url = "github:Robitx/gp.nvim";
    gp-nvim.flake = false;
  };
  outputs = {
    self,
    neovim-nightly-overlay,
    nixpkgs,
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
          neovim-nightly-overlay.overlays.default
          (prev: final: {
            neovim = neovim-nightly-overlay.packages.${prev.system}.default;

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

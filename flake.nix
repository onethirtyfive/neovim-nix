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

    fugitive.url = "github:tpope/vim-fugitive";
    fugitive.flake = false;
    gitsigns-nvim.url = "github:lewis6991/gitsigns.nvim";
    gitsigns-nvim.flake = false;
    lualine-nvim.url = "github:nvim-lualine/lualine.nvim";
    lualine-nvim.flake = false;
    project-nvim.url = "github:ahmedkhalf/project.nvim";
    project-nvim.flake = false;
    vim-tmux-navigator.url = "github:christoomey/vim-tmux-navigator";
    vim-tmux-navigator.flake = false;
  };
  outputs = {
    self,
    neovim-nightly-overlay,
    nixpkgs,
    copilot-lualine-nvim,
    fugitive,
    gitsigns-nvim,
    gp-nvim,
    lualine-nvim,
    project-nvim,
    vim-tmux-navigator,
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
              fugitive = final.vimPlugins.fugitive.overrideAttrs (prev: prev // {
                src = fugitive;
              });
              gitsigns-nvim = final.vimPlugins.gitsigns-nvim.overrideAttrs (prev: prev // {
                src = gitsigns-nvim;
              });
              gp = final.vimUtils.buildVimPlugin {
                name = "gp-nvim";
                src = gp-nvim;
              };
              lualine-nvim = final.vimPlugins.lualine-nvim.overrideAttrs (prev: prev // {
                src = lualine-nvim;
              });
              project-nvim = final.vimPlugins.project-nvim.overrideAttrs (prev: prev // {
                src = project-nvim;
                patches = [ ./patches/project-nvim/fix-get_clients.patch ];
              });
              vim-tmux-navigator = final.vimPlugins.vim-tmux-navigator.overrideAttrs (prev: prev // {
                src = vim-tmux-navigator;
              });
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

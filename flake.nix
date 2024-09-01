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

    # gp.nvim
    plugin-gp-nvim.url = "github:Robitx/gp.nvim";
    plugin-gp-nvim.flake = false;

    # copilot-lualine.nvim
    plugin-copilot-lualine-nvim.url = "github:AndreM222/copilot-lualine";
    plugin-copilot-lualine-nvim.flake = false;
  };
  outputs = { self, nixpkgs, neovim, plugin-gp-nvim, plugin-copilot-lualine-nvim }:
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
                src = plugin-copilot-lualine-nvim;
              };
              gp = final.vimUtils.buildVimPlugin {
                name = "gp-nvim";
                src = plugin-gp-nvim;
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

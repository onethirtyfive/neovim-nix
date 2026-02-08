{
  description = "My own Neovim flake";
  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nixpkgs.follows = "neovim-nightly-overlay/nixpkgs";

    # nvim plugin sources:

    cmp_luasnip.url = "github:saadparwaiz1/cmp_luasnip";
    cmp_luasnip.flake = false;
    cmp-buffer.url = "github:hrsh7th/cmp-buffer";
    cmp-buffer.flake = false;
    cmp-cmdline.url = "github:hrsh7th/cmp-cmdline";
    cmp-cmdline.flake = false;
    cmp-git.url = "github:hrsh7th/cmp-git";
    cmp-git.flake = false;
    cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    cmp-nvim-lsp.flake = false;
    cmp-path.url = "github:hrsh7th/cmp-path";
    cmp-path.flake = false;
    comment-nvim.url = "github:numToStr/comment.nvim";
    comment-nvim.flake = false;
    fidget-nvim.url = "github:j-hui/fidget.nvim";
    fidget-nvim.flake = false;
    vim-fugitive.url = "github:tpope/vim-fugitive";
    vim-fugitive.flake = false;
    gitsigns-nvim.url = "github:lewis6991/gitsigns.nvim";
    gitsigns-nvim.flake = false;
    indent-blankline-nvim.url = "github:lukas-reineke/indent-blankline.nvim";
    indent-blankline-nvim.flake = false;
    lsp_signature-nvim.url = "github:ray-x/lsp_signature.nvim";
    lsp_signature-nvim.flake = false;
    lspkind-nvim.url = "github:onsails/lspkind-nvim";
    lspkind-nvim.flake = false;
    lualine-nvim.url = "github:nvim-lualine/lualine.nvim";
    lualine-nvim.flake = false;
    luasnip.url = "github:L3MON4D3/LuaSnip";
    luasnip.flake = false;
    nightfox-nvim.url = "github:EdenEast/nightfox.nvim";
    nightfox-nvim.flake = false;
    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;
    nvim-tree-lua.url = "github:nvim-tree/nvim-tree.lua";
    nvim-tree-lua.flake = false;
    # nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter";
    # nvim-treesitter.flake = false;
    nvim-treesitter-main.url = "github:iofq/nvim-treesitter-main";
    nvim-treesitter-textobjects.url = "github:nvim-treesitter/nvim-treesitter-textobjects";
    nvim-treesitter-textobjects.flake = false;
    nvim-ts-autotag.url = "github:windwp/nvim-ts-autotag";
    nvim-ts-autotag.flake = false;
    nvim-web-devicons.url = "github:nvim-tree/nvim-web-devicons";
    nvim-web-devicons.flake = false;
    project-nvim.url = "github:ahmedkhalf/project.nvim";
    project-nvim.flake = false;
    telescope-fzf-native-nvim.url = "github:nvim-telescope/telescope-fzf-native.nvim";
    telescope-fzf-native-nvim.flake = false;
    telescope-live-grep-args-nvim.url = "github:nvim-telescope/telescope-live-grep-args.nvim";
    telescope-live-grep-args-nvim.flake = false;
    telescope-nvim.url = "github:nvim-telescope/telescope.nvim/v0.1.9";
    telescope-nvim.flake = false;
    vim-sleuth.url = "github:tpope/vim-sleuth";
    vim-sleuth.flake = false;
    vim-tmux-navigator.url = "github:christoomey/vim-tmux-navigator";
    vim-tmux-navigator.flake = false;
    which-key-nvim.url = "github:folke/which-key.nvim";
    which-key-nvim.flake = false;
  };
  outputs = {
    self,
    neovim-nightly-overlay,
    nix-github-actions,
    nixpkgs,
    cmp_luasnip,
    cmp-buffer,
    cmp-cmdline,
    cmp-git,
    cmp-nvim-lsp,
    cmp-path,
    comment-nvim,
    fidget-nvim,
    vim-fugitive,
    gitsigns-nvim,
    indent-blankline-nvim,
    lsp_signature-nvim,
    lspkind-nvim,
    lualine-nvim,
    luasnip,
    nightfox-nvim,
    nvim-cmp,
    nvim-lspconfig,
    nvim-tree-lua,
    # nvim-treesitter,
    nvim-treesitter-main,
    nvim-treesitter-textobjects,
    nvim-ts-autotag,
    nvim-web-devicons,
    project-nvim,
    telescope-fzf-native-nvim,
    telescope-live-grep-args-nvim,
    telescope-nvim,
    vim-sleuth,
    vim-tmux-navigator,
    which-key-nvim
  }:
  let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    forEachSystem = nixpkgs.lib.genAttrs systems;

    mkPkgs =
      system:
      let
        overlays = [
          neovim-nightly-overlay.overlays.default
          nvim-treesitter-main.overlays.default
          (prev: final: {
            neovim = neovim-nightly-overlay.packages.${prev.stdenv.hostPlatform.system}.default;

            vimPlugins = final.vimPlugins // {
              cmp_luasnip = final.vimPlugins.cmp_luasnip.overrideAttrs (prev: prev // {
                src = cmp_luasnip;
              });
              cmp-buffer = final.vimPlugins.cmp-buffer.overrideAttrs (prev: prev // {
                src = cmp-buffer;
              });
              cmp-cmdline = final.vimPlugins.cmp-cmdline.overrideAttrs (prev: prev // {
                src = cmp-cmdline;
              });
              cmp-git = final.vimPlugins.cmp-git.overrideAttrs (prev: prev // {
                src = cmp-git;
              });
              cmp-nvim-lsp = final.vimPlugins.cmp-nvim-lsp.overrideAttrs (prev: prev // {
                src = cmp-nvim-lsp;
              });
              cmp-path = final.vimPlugins.cmp-path.overrideAttrs (prev: prev // {
                src = cmp-path;
              });
              comment-nvim = final.vimPlugins.comment-nvim.overrideAttrs (prev: prev // {
                src = comment-nvim;
              });
              fidget-nvim = final.vimPlugins.fidget-nvim.overrideAttrs (prev: prev // {
                src = fidget-nvim;
              });
              vim-fugitive = final.vimPlugins.vim-fugitive.overrideAttrs (prev: prev // {
                src = vim-fugitive;
              });
              gitsigns-nvim = final.vimPlugins.gitsigns-nvim.overrideAttrs (prev: prev // {
                src = gitsigns-nvim;
              });
              indent-blankline-nvim = final.vimPlugins.indent-blankline-nvim.overrideAttrs (prev: prev // {
                src = indent-blankline-nvim;
              });
              lsp_signature-nvim = final.vimPlugins.lsp_signature-nvim.overrideAttrs (prev: prev // {
                src = lsp_signature-nvim;
              });
              lspkind-nvim = final.vimPlugins.lspkind-nvim.overrideAttrs (prev: prev // {
                src = lspkind-nvim;
              });
              lualine-nvim = final.vimPlugins.lualine-nvim.overrideAttrs (prev: prev // {
                src = lualine-nvim;
              });
              luasnip = final.vimPlugins.luasnip.overrideAttrs (prev: prev // {
                src = luasnip;
              });
              nightfox-nvim = final.vimPlugins.nightfox-nvim.overrideAttrs (prev: prev // {
                src = nightfox-nvim;
              });
              nvim-lspconfig = final.vimPlugins.nvim-lspconfig.overrideAttrs (prev: prev // {
                src = nvim-lspconfig;
              });
              nvim-tree-lua = final.vimPlugins.nvim-tree-lua.overrideAttrs (prev: prev // {
                src = nvim-tree-lua;
              });
              nvim-treesitter-textobjects = final.vimPlugins.nvim-treesitter-textobjects.overrideAttrs (prev: prev // {
                src = nvim-treesitter-textobjects;
              });
              nvim-cmp = final.vimPlugins.nvim-cmp.overrideAttrs (prev: prev // {
                src = nvim-cmp;
              });
              # nvim-treesitter = final.vimPlugins.nvim-treesitter.overrideAttrs (prev: prev // {
              #   src = nvim-treesitter;
              # });
              nvim-treesitter-main = final.vimPlugins.nvim-treesitter.overrideAttrs (prev: prev // {
                src = nvim-treesitter-main;
              });
              nvim-ts-autotag = final.vimPlugins.nvim-ts-autotag.overrideAttrs (prev: prev // {
                src = nvim-ts-autotag;
              });
              nvim-web-devicons = final.vimPlugins.nvim-web-devicons.overrideAttrs (prev: prev // {
                src = nvim-web-devicons;
              });
              project-nvim = final.vimPlugins.project-nvim.overrideAttrs (prev: prev // {
                src = project-nvim;
                patches = [ ./patches/project-nvim/fix-get_clients.patch ];
              });
              telescope-fzf-native-nvim = final.vimPlugins.telescope-fzf-native-nvim.overrideAttrs (prev: prev // {
                src = telescope-fzf-native-nvim;
              });
              telescope-live-grep-args-nvim = final.vimPlugins.telescope-live-grep-args-nvim.overrideAttrs (prev: prev // {
                src = telescope-live-grep-args-nvim;
              });
              telescope-nvim = final.vimPlugins.telescope-nvim.overrideAttrs (prev: prev // {
                src = telescope-nvim;
              });
              vim-sleuth = final.vimPlugins.vim-sleuth.overrideAttrs (prev: prev // {
                src = vim-sleuth;
              });
              vim-tmux-navigator = final.vimPlugins.vim-tmux-navigator.overrideAttrs (prev: prev // {
                src = vim-tmux-navigator;
              });
              which-key-nvim = final.vimPlugins.which-key-nvim.overrideAttrs (prev: prev // {
                src = which-key-nvim;
              });
            };
          })
        ];
      in import nixpkgs { inherit system overlays; };
  in
  {
    nixConfig = {
      extra-substituters = [
        "https://nix-community.cachix.org https://onethirtyfive.cachix.org"
        "https://nvim-treesitter-main.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= onethirtyfive.cachix.org-1:w+zBnwl7vHfxNHawEN6Ej2zQ2ejgi8oqCxqVZ8wGYCg="
        "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
      ];
    };

    githubActions = nix-github-actions.lib.mkGithubMatrix { checks = self.packages; };

    overlays = {
      default = prev: final: {
        onethirtyfive.neovim = self.packages.${prev.stdenv.hostPlatform.system}.default;
      };
    };

    packages = forEachSystem (
      system:
      let
        pkgs = mkPkgs system;
      in {
        default = import ./onethirtyfive-neovim { inherit pkgs; };
      }
    );

    apps = forEachSystem (
      system:
      rec {
        default = nvim;

        nvim = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      }
    );
  };
}

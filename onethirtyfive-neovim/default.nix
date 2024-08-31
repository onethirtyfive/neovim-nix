{ pkgs, ... }:
let
  inherit (pkgs) neovimUtils;
  inherit (neovimUtils) makeNeovimConfig;

  config = makeNeovimConfig {
    withNodeJs = true;

    plugins = import ./plugins.nix { inherit pkgs; };

    vimAlias = true;
  };

  wrapped = pkgs.wrapNeovimUnstable pkgs.neovim (config // {
    luaRcContent =
      let
        inherit (builtins) concatStringsSep readFile map;

        sources = [
          ./init.lua
          # ./config/crates.lua
          ./config/gp.lua
          ./config/lsp.lua
          ./config/lualine.lua
          ./config/treesitter.lua
          ./config/cmp.lua
          ./config/telescope.lua
          ./config/copilot.lua
        ];
      in concatStringsSep "\n" (map readFile sources);
  });
in pkgs.writeShellApplication {
  name = "nvim";

  runtimeInputs = with pkgs; [
    fswatch
    marksman
    nil
    nmap
    (sox.override { enableLame = true; })
    ripgrep
    taplo
    # terraform
    # terraform-ls
    texlab
  ]
    ++ (with pkgs.nodejs.pkgs; [ typescript-language-server vscode-langservers-extracted ])
    # TODO: set up python with packages?:
    ++ (with pkgs.python3Packages; [
         pynvim
         python-lsp-server
         pylsp-mypy
         python-pam
         ruff
         typing-extensions
       ]);

  text = ''
    ${wrapped}/bin/nvim "$@"
  '';
}


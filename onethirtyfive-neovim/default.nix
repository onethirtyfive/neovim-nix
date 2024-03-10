{ pkgs, ... }:
let
  inherit (pkgs) neovimUtils;
  inherit (neovimUtils) makeNeovimConfig;

  config = makeNeovimConfig {
    withNodeJs = true;

    extraPython3Packages = (ps: with ps; [
      black
      pylint

      python-lsp-server
      python-lsp-black
      pylsp-mypy
      pynvim

      typing-extensions

      python-pam
    ]);

    plugins = import ./plugins.nix { inherit pkgs; };

    vimAlias = true;
  };

  wrapped = pkgs.wrapNeovimUnstable pkgs.neovim (config // {
    luaRcContent =
      let
        inherit (builtins) concatStringsSep readFile map;

        sources = [
          ./init.lua
          ./config/crates.lua
          ./config/lsp.lua
          ./config/lualine.lua
          ./config/treesitter.lua
          ./config/cmp.lua
          ./config/telescope.lua
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
    ripgrep
    taplo
    # terraform
    # terraform-ls
    texlab
    taplo
  ]
    ++ (with pkgs.nodejs.pkgs; [ typescript-language-server vscode-langservers-extracted ]);

  text = ''
    ${wrapped}/bin/nvim "$@"
  '';
}


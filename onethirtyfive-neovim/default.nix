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
          ./config/treesitter.lua
          ./config/lsp.lua
          ./config/cmp.lua
          ./config/projects.lua
          ./config/tmux.lua
          ./config/telescope.lua
          ./config/whichkey.lua
          ./config/lualine.lua
        ];
      in concatStringsSep "\n" (map readFile sources);
  });
in pkgs.writeShellApplication {
  name = "nvim";

  runtimeInputs = with pkgs; [
    fswatch
    # marksman
    nil
    nmap
    nodejs
    ripgrep
    taplo
    # terraform
    # terraform-ls
    texlab
    ruby
  ]
    ++ (with pkgs.haskellPackages; [ fast-tags ])
    ++ (with pkgs.nodejs.pkgs; [ typescript-language-server vscode-langservers-extracted ])
    # TODO: set up python with packages?:
    ++ (with pkgs.python3Packages; [
         pynvim
         python-lsp-server
         pylsp-mypy
         python-pam
         ruff
         typing-extensions
       ])
    ++ [
         # (
         #  let
         #    debug = pkgs.buildRubyGem {
         #      pname = "debug";
         #      gemName = "debug";
         #      type = "gem";
         #      version = "1.10.0";
         #
         #      source.sha256 = null;
         #    };
         #  in
         #    pkgs.ruby.withPackages (pkgs: with pkgs; [ ruby-lsp language_server-protocol debug ])
         # )
       ];

  text = ''
    ${wrapped}/bin/nvim "$@"
  '';
}


{ pkgs, ... }:
let
  wrapped = pkgs.wrapNeovimUnstable pkgs.neovim {
    withNodeJs = true;
    plugins = import ./plugins.nix { inherit pkgs; };
    vimAlias = true;
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
  };
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
    ty
    # terraform
    # terraform-ls
    texlab
    typescript-language-server
    vscode-langservers-extracted
    ruby
  ]
    # TODO: set up python with packages?:
    ++ (with pkgs.python3Packages; [
         pynvim
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

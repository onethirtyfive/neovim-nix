{ pkgs, kotlin-lsp, ... }:
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
    curl
    fswatch
    kotlin-lsp
    # marksman
    nil
    nmap
    nodejs
    ripgrep
    # The Rust toolchain and rust-analyzer come from the project's environment.
    vscode-extensions.vadimcn.vscode-lldb.adapter
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
    ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      if [[ -z "''${LLDB_DEBUGSERVER_PATH:-}" ]]; then
        xcode_debugserver="/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver"
        command_line_tools_debugserver="/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Resources/debugserver"

        if [[ -x "$xcode_debugserver" ]]; then
          export LLDB_DEBUGSERVER_PATH="$xcode_debugserver"
        elif [[ -x "$command_line_tools_debugserver" ]]; then
          export LLDB_DEBUGSERVER_PATH="$command_line_tools_debugserver"
        fi
      fi
    ''}

    exec ${wrapped}/bin/nvim "$@"
  '';
}

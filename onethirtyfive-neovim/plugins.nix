{ pkgs }:
let
  inherit (pkgs) vimPlugins;
in (with vimPlugins; [
  # tmux
  vim-tmux-navigator

  # projects
  project-nvim

  # scm
  fugitive # less used
  gitsigns-nvim

  # chrome
  lualine-nvim
  nvim-tree-lua
  nvim-web-devicons
  telescope-fzf-native-nvim
  telescope-nvim
  telescope-live-grep-args-nvim
  which-key-nvim

  # theme
  nightfox-nvim

  # lang
  (nvim-treesitter-main.withPlugins (
    plugins: (with plugins; [
      awk
      bash
      c
      cpp
      css
      csv
      dhall
      dockerfile
      diff
      elixir
      git-config
      git-rebase
      gitattributes
      gitcommit
      gitignore
      go
      gomod
      gpg
      graphql
      haskell
      hcl
      helm
      html
      http
      ini
      java
      javascript
      jq
      jsdoc
      json
      llvm
      lua
      luadoc
      make
      markdown
      markdown-inline
      meson
      nginx
      nix
      odin
      passwd
      pem
      proto
      python
      readline
      regex
      ruby
      rust
      scss
      ssh-config
      sql
      swift
      terraform
      tmux
      toml
      tree-sitter-tsx
      typescript
      tree-sitter-yaml
      zig
    ])
  ))
  nvim-treesitter-textobjects
  nvim-ts-autotag

  # lsp: meta
  nvim-lspconfig
  fidget-nvim

  # lsp: utility
  lsp_signature-nvim
  lspkind-nvim
  luasnip

  # text
  comment-nvim
  indent-blankline-nvim
  vim-sleuth

  # lsp: chatbot
  # TODO: add claude-code

  # cmp
  nvim-cmp
  cmp-git
  cmp-buffer
  cmp-cmdline
  cmp-nvim-lsp
  cmp-path
  cmp_luasnip

  # debugging
  nvim-dap
])

-- nvim-project
require("project_nvim").setup {
  patterns = {
    ".git",
    "flake.nix", -- just use flakes
    -- "package.json",
    -- "Gemfile",
    -- "Cargo.toml",
    -- "!^nixhosts",
    -- "pyproject.toml", "requirements.txt",
  },
  exclude_dirs = {
    "~/.cargo/*",
    "rustlings/exercises",
  },
  ignore_lsp = { "taplo" },
}


-- Set <space> as the leader key
-- See `:help mapleader`

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.vim_deprecation_warning = false
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim
vim.o.breakindent = true
vim.o.undofile = true -- undo changes saved to disk
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.termguicolors = true -- rich terminal colors
vim.o.completeopt = '' -- Turn builtin completion off in favor of nvim-cmp

-- always re-read a file if it changed outside of Neovim
vim.o.autoread = true

-- trigger checktime on focus or buffer enter so autoread actually fires
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  command = "checktime",
})

-- Remap for dealing with word wrap
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true, desc = "Toggle vimtree" })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.api.nvim_command([[
  silent! colorscheme carbonfox
  silent! set bg=dark
]]);

vim.api.nvim_command([[
  silent! set et tabstop=2 shiftwidth=2 softtabstop=2
  silent! set autoindent
]]);

-- strip trailing whitespace from all files on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Miscellaneous plugin setup (don't warrant own file)

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
  filters = {
    custom = {
      "^.git$",
      "^._*$",
      "^.DS_Store",
      "__pycache__",
      "^.mypy_cache",
      "^.ruby-lsp",
    },
  },
})

require('fidget').setup{}
require('nvim-web-devicons').setup{}
require('Comment').setup{}
require('nvim-ts-autotag').setup{}
require('gitsigns').setup{
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  }
}

local luasnip = require('luasnip')
luasnip.setup{}
luasnip.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })

-- vim.g.python3_host_prog = ""
if vim.env.UV_PYTHON then
  vim.g.python3_host_prog = vim.env.UV_PYTHON
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

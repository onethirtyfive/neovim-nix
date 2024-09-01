require "math"

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

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

local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap=true, })
  end

  local emoji = {
    "😀", "😁", "😂", "😃",
    "😄", "😅", "😆", "😇",
    "😉", "😊", "🙂", "🤣",
    "💩"
  }
  local random_emoji = function()
    return emoji[math.random(#emoji)]
  end

  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = { border = "single" },
    hint_prefix = random_emoji();
  }, bufnr)

  -- See `:help K` for why this keymap
  local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim','help' }, filetype) then
      vim.cmd('h '..vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
      vim.cmd('Man '..vim.fn.expand('<cword>'))
    -- elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
    --   require('crates').show_popup()
    else
      vim.lsp.buf.hover()
    end
  end

  nmap('K', show_documentation, '[K] Hover Documentation')
  nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
  nmap('gI', vim.lsp.buf.implementation, '[g]oto [I]mplementation')
  nmap('go', vim.lsp.buf.type_definition, 'type definition')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gs', vim.lsp.buf.signature_help, '[g]oto [s]ignature')
  nmap('<F2>', vim.lsp.buf.rename, '[F2] Rename')
  nmap('<F3>', vim.lsp.buf.format, '[F3] Format')
  nmap('<F4>', vim.lsp.buf.code_action, '[F4] Code [A]ction')
  nmap('gl', vim.diagnostic.open_float, 'Floating diagnostic')
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
  nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
  nmap('<leader>k', vim.lsp.buf.signature_help, '[k] signature documentation')

  -- Lesser used LSP functionality (rust? ts? workspaces?)
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[w]orkspace [l]ist folders')
end

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- add a few misc capabilities (source?)
lsp_defaults.capabilities.textDocument.completion.completionItem.snippetSupport = true
lsp_defaults.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

function configure_lsp(server_name)
  lspconfig[server_name].setup { on_attach = on_attach, }
end

configure_lsp('clangd')
configure_lsp('html')
configure_lsp('cssls')
configure_lsp('marksman')
configure_lsp('nil_ls')
configure_lsp('pylsp')
configure_lsp('ruff')
configure_lsp('texlab')
-- configure_lsp('terraformls')
configure_lsp('tsserver')
-- configure_lsp('standardrb')
configure_lsp('taplo')
configure_lsp('jsonls')

-- require('crates').setup()

vim.g.rustaceanvim = {
  server = {
    on_attach = function(...)
      -- vim.keymap.set("n", "<leader>H", rustaceanvim.hover_actions.hover_actions, { silent=true, noremap=true, desc="Hover actions" })
      -- vim.keymap.set("n", "<leader>cA", rustaceanvim.code_action_group.code_action_group, { silent=true, noremap=true, desc = "Code [A]ction group" })
      on_attach(...)
    end
  },
  tools = {
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        autoReload = true,
      },
      excludeDirs = {
      },
    },
  },
}


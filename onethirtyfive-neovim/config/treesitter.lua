-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Parsers and queries are bundled by Nix. If a filetype has a highlight query
-- and its parser is available, use Tree-sitter; otherwise keep Vim syntax.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local ok, query = pcall(vim.treesitter.query.get, language, 'highlights')
    if ok and query then
      pcall(vim.treesitter.start, event.buf, language)
    end
  end,
})

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local textobject_select = require('nvim-treesitter-textobjects.select')
local textobject_move = require('nvim-treesitter-textobjects.move')
local textobject_swap = require('nvim-treesitter-textobjects.swap')

local function map_select(lhs, capture)
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    textobject_select.select_textobject(capture, 'textobjects')
  end)
end

local function map_move(lhs, method, capture)
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    textobject_move[method](capture, 'textobjects')
  end)
end

map_select('aa', '@parameter.outer')
map_select('ia', '@parameter.inner')
map_select('af', '@function.outer')
map_select('if', '@function.inner')
map_select('ac', '@class.outer')
map_select('ic', '@class.inner')

map_move(']m', 'goto_next_start', '@function.outer')
map_move(']]', 'goto_next_start', '@class.outer')
map_move(']M', 'goto_next_end', '@function.outer')
map_move('][', 'goto_next_end', '@class.outer')
map_move('[m', 'goto_previous_start', '@function.outer')
map_move('[[', 'goto_previous_start', '@class.outer')
map_move('[M', 'goto_previous_end', '@function.outer')
map_move('[]', 'goto_previous_end', '@class.outer')

vim.keymap.set('n', '<leader>a', function()
  textobject_swap.swap_next('@parameter.inner')
end)
vim.keymap.set('n', '<leader>A', function()
  textobject_swap.swap_previous('@parameter.inner')
end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'kotlin',
  callback = function()
    vim.bo.indentexpr = 'GetKotlinIndent()'
  end,
})

require('nvim-ts-autotag').setup()

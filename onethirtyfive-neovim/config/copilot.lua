require("copilot").setup({
  opts = {},
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      -- overridden directly in WhichKey
      accept = false,
      accept_word = false,
      accept_line = false,
      next = false,
      prev = false,
      dismiss = false,
    },
  },
  panel = {
    enabled = true
  },
})

-- vim.cmd([[
--     augroup CopilotLuaRefresh
--         autocmd!
--         autocmd InsertEnter * lua require('copilot.suggestion').next()
--     augroup END
-- ]])

wk = require("which-key")
wk.add({
  {
    mode = { "i" },
    { "<C-l>;", "<cmd>Copilot suggestion accept<cr>", desc = "Accept Suggestion", nowait = true, remap = false },
    { "<C-l>d", "<cmd>Copilot suggestion dismiss<cr>", desc = "Dismiss Copilot", nowait = true, remap = false },
    { "<C-l>j", "<cmd>Copilot suggestion next<cr>", desc = "Next Copilot", nowait = true, remap = false },
    { "<C-l>k", "<cmd>Copilot suggestion prev<cr>", desc = "Prev Copilot", nowait = true, remap = false },
    { "<C-l>l", "<cmd>Copilot suggestion accept_line<cr>", desc = "Accept Line", nowait = true, remap = false },
    { "<C-l>w", "<cmd>Copilot suggestion accept_words<cr>", desc = "Accept Word", nowait = true, remap = false },
  },
})

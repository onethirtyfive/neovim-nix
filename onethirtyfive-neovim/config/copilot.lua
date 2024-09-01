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

vim.cmd([[
    augroup CopilotLuaRefresh
        autocmd!
        autocmd InsertEnter * lua require('copilot.suggestion').next()
    augroup END
]])

require("which-key").register({
  ["<C-b>"] = {
      j = { "<cmd>Copilot suggestion next<cr>", "Next Copilot" },
      k = { "<cmd>Copilot suggestion prev<cr>", "Prev Copilot" },
      l = { "<cmd>Copilot suggestion accept_line<cr>", "Accept Line" },
      w = { "<cmd>Copilot suggestion accept_words<cr>", "Accept Word" },
      ["<C-b>"] = { "<cmd>Copilot suggestion accept<cr>", "Accept Suggestion" },
      d = { "<cmd>Copilot suggestion dismiss<cr>", "Dismiss Copilot" },
  }
}, {
    mode = "i", -- INSERT mode
    prefix = "",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
})

require("copilot").setup({
  panel = {
    enabled = false
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    keymap = {
      -- overridden directly in WhichKey
      accept = "<C-l>;",
      accept_word = "<C-l>w",
      accept_line = "<C-l>l",
      next = "<C-l>j",
      prev = "<C-l>k",
      dismiss = "<C-l>d",
    },
  },
})

require("copilot_cmp").setup()

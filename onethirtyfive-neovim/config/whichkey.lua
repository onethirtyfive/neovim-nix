wk = require('which-key')

-- basic setup
wk.setup{
  win = {
    border = "single",
  },
  triggers = {
    { "<auto>", mode = "nxso" },
    { "<auto>", mode = "i" },
  },
}


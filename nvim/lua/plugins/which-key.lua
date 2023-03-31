return { 
  "folke/which-key.nvim",
  init = function()
    local whichkey = require("which-key")

    whichkey.register({
      mode = "n",
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true
    })
  end
}


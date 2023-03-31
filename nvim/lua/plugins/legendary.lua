return {
  "mrjones2014/legendary.nvim",
  config = true,
  opts = {},
  init = function()
    vim.keymap.set("n", "<leader>P", function()
      require("legendary").find({})
    end, { desc = "Command Palette" })
  end
}

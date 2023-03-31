return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = true,
  opts = {
    shell = "zsh",
    float_opts = {
      border = 'curved',
    }
  },
  init = function()
    vim.keymap.set("n", "<leader>`", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
    vim.keymap.set("n", "<leader>`v", ":ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
    vim.keymap.set("n", "<leader>`h", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>`t", ":ToggleTerm direction=tab<CR>", { desc = "Toggle tab terminal" })
    vim.keymap.set("n", "<leader>`f", ":ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
  end
}

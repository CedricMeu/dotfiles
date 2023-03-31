return {
  'romgrk/barbar.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  init = function()
    vim.api.nvim_set_keymap("n", "<leader>q", ":BufferClose<CR>", { noremap = true, desc = "Close buffer" })
  end
}

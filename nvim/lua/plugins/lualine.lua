return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    }
  },
  config = true,
  opts = {
    sections = {
      lualine_c = {
        "filename",
        "lsp_progress"
      }
    }
  },
}

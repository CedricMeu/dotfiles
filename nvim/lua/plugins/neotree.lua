return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    {
      "s1n7ax/nvim-window-picker",
      config = true,
      opts = {
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', "neo-tree-popup", "notify" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', "quickfix" },
          },
        },
        other_win_hl_color = '#e35e4f',
      }
    }
  },
  config = true,
  opts = {
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      group_empty_dirs = true,
      filtered_items = {
        hide_dotfiles = false,
      }
    },
    source_selector = {
      winbar = false,
      statusline = false
    }
  },
  init = function()
    vim.api.nvim_set_keymap("", "<leader>e", ":Neotree toggle<CR>",
      { desc = "Toggle file tree" })
  end,
  enabled = false,
}

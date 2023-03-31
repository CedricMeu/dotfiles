return {
  "nvim-tree/nvim-tree.lua",
  tag = "nightly",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    }
  },
  config = true,
  opts = {
    hijack_unnamed_buffer_when_opening = false,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = false,
    },
    git = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = false,
    },
    modified = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = false,
    },
    select_prompts = true,
    renderer = {
      group_empty = true,
      highlight_git = true,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      }
    },
    view = {
      width = 45,
    },
  },
  init = function()
    local nvim_tree_events = require('nvim-tree.events')
    local bufferline_api = require('bufferline.api')

    vim.api.nvim_set_keymap("", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

    local function get_tree_size()
      return require('nvim-tree.view').View.width
    end

    nvim_tree_events.subscribe('TreeOpen', function()
      bufferline_api.set_offset(get_tree_size())
    end)

    nvim_tree_events.subscribe('Resize', function()
      bufferline_api.set_offset(get_tree_size())
    end)

    nvim_tree_events.subscribe('TreeClose', function()
      bufferline_api.set_offset(0)
    end)
  end,
  enabled = false,
}

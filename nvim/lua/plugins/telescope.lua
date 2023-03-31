-- function PROJECT_FILES(opts)
--   opts = opts or {}
--   opts.show_untracked = true
--   if vim.loop.fs_stat(".git") then
--     require("telescope.builtin").git_files(opts)
--   else
--     local client = vim.lsp.get_active_clients()[1]
--     if client then
--       opts.cwd = client.config.root_dir
--     end
--     require("telescope.builtin").find_files(opts)
--   end
-- end

return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim",  build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      extensions = {
        file_browser = {
          auto_depth = true,
          collapse_dirs = true,
        },
        ["ui-select"] = {
          specific_opts = {
            codeactions = true,
          }
        }
      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")
  end,
  init = function()
    local telescope = require("telescope")

    vim.keymap.set("n", "<leader>p", function()
      telescope.extensions.file_browser.file_browser()
    end, { desc = "Find file" })

    -- vim.keymap.set("n", "<leader>p", function()
    --   PROJECT_FILES()
    -- end, { desc = "Find File" })

    vim.keymap.set("n", "<leader>f", function()
      local current_file = vim.api.nvim_buf_get_name(0)
      require("telescope.builtin").live_grep({ search_dirs = { current_file } })
    end, { desc = "Find in current file" })

    vim.keymap.set("n", "<leader>F", function()
      require("telescope.builtin").live_grep()
    end, { desc = "Find in all files" })

    vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, { desc = "Quickfix" })

    vim.keymap.set("n", "<leader>kt", ":Telescope colorscheme<CR>", { desc = "Choose colorscheme" })
  end,
}

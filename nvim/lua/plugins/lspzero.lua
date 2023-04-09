return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    { "simrat39/rust-tools.nvim" },
  },
  config = function()
    local lspzero = require("lsp-zero")
    local lspconfig = require("lspconfig")

    lspzero.preset({
      name = 'recommended',
      set_lsp_keymaps = false,
    })

    lspconfig.ltex.setup({
      on_attach = on_attach,
      autostart = true,
      settings = {
        ltex = {
          enabled = true,
          language = "auto",
          -- languageToolHttpServerUri = "https://api.languagetool.org",
          -- languageToolOrg = {
          --   username = "9jdd82tym2@privaterelay.appleid.com"
          -- }
        }
      }
    })

    lspzero.ensure_installed({
      "rust_analyzer",
      "clangd",
      "pyright",
      "marksman",
      "lua_ls",
      "jsonls",
      "jdtls",
      "zls",
      "vtsls",
      "lemminx",
      "pylsp",
    })

    lspzero.nvim_workspace()

    lspzero.setup()

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        prefix = '',
      },
    })

    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, { desc = "Goto Definition" })
    vim.keymap.set("n", "gr", function()
      vim.lsp.buf.references()
    end, { desc = "Goto References" })
    vim.keymap.set("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, { desc = "Rename" })
    vim.keymap.set("n", "<leader>H", function()
      vim.lsp.buf.hover()
    end, { desc = "Signature Help" })
    vim.keymap.set("n", "<leader>h", function()
      vim.diagnostic.open_float({ scope = "cursor" })
    end, { desc = "diagnostic Help" })

    vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
  end
}

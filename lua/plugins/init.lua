return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier",
        "haskell-language-server", "jdtls",
        "yamllint", "marksman","ltex-ls",
        "json-lsp", "eslint-lsp", "stylelint-lsp",
       --  markdownlint
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css", "haskell",
        "python", "java", "markdown",
        "javascript", "typescript",
  		},
  	},
  },
  -- here I try to add a config for nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    opts = function ()
      local conf = require "nvchad.configs.nvimtree"

      conf.filters = {
        git_ignored = false,
        dotfiles = false,
      }
      return conf
    end,
  }

}

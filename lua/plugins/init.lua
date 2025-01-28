return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
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
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Enable inline blame
      current_line_blame_opts = {
        virt_text = true, -- Display as virtual text
        virt_text_pos = "eol", -- Position blame text at the end of the line
        delay = 100, -- Delay in milliseconds
        ignore_whitespace = false, -- Include whitespace changes
      },
    },
  },
  -- unused because it move to chadrc.lua
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "haskell",
        "python",
        "java",
        "markdown",
        "javascript",
        "typescript",
        "jsdoc",
        "c",
        "make",
        "cmake",
        "bash",
      },
    },
  },
  -- add config for nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      require "configs.nvim-tree"
    end,
  },
  -- Install markdown preview, use npx if available.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- Rainbow brackets
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufRead",
    config = function()
      -- get colors for rainbow-delimiters
      local colors = dofile(vim.g.base46_cache .. "colors")
      vim.cmd("highlight RainbowDelimiterRed guifg=" .. colors.red)
      vim.cmd("highlight RainbowDelimiterYellow guifg=" .. colors.yellow)
      vim.cmd("highlight RainbowDelimiterBlue guifg=" .. colors.blue)
      vim.cmd("highlight RainbowDelimiterOrange guifg=" .. colors.orange)
      vim.cmd("highlight RainbowDelimiterGreen guifg=" .. colors.green)
      vim.cmd("highlight RainbowDelimiterViolet guifg=" .. colors.purple)
      vim.cmd("highlight RainbowDelimiterCyan guifg=" .. colors.cyan)
    end,
  },
}

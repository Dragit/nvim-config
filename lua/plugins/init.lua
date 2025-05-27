return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  -- added this to fix issue with leader key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
        delay = 3000, -- Delay in milliseconds
        ignore_whitespace = false, -- Include whitespace changes
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.keymap.set(
        "n",
        "<leader>gp",
        ":Gitsigns preview_hunk_inline<CR>",
        { desc = "Gitsigns preview hunk inline" }
      )
      vim.keymap.set(
        "n",
        "<leader>gqa",
        ":Gitsigns setqflist target=all<CR>",
        { desc = "Gitsigns: hunk quickfix all" }
      )
      vim.keymap.set(
        "n",
        "<leader>gqt",
        ":Gitsigns setqflist target=attached<CR>",
        { desc = "Gitsigns: hunk quickfix attached" }
      )
    end,
  },
  -- unused because it moved to chadrc.lua
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
        "tmux",
        "tsx",
        "yaml",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitignore",
        "ssh_config",
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
      require "configs.rainbow-delimiters"
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function(plugin, opts)
      --

      -- Force markview.nvim to be sourced before everything else
      vim.opt.rtp:prepend(plugin.dir)

      -- Set up the plugin
      require("markview").setup(opts)
    end,
    opts = {
      preview = {
        modes = { "n", "no", "c", "i" },
        linewise_hybrid_mode = true,
        hybrid_modes = { "n", "i" },
        debounce = 70,
      },

      markdown_inline = {
        enable = false,
      },

      highlight_groups = {},
      html = {
        enable = false,
      },
      latex = {
        enable = true,

        blocks = {
          enable = false,
        },
        commands = {},
        escapes = {},
        fonts = {},
        inlines = {},
        parenthesis = {},
        subscripts = {},
        superscripts = {},
        symbols = {},
        texts = {},
      },
      bullet = {
        enable = false,
      },
      markdown = {
        tables = {
          enable = true,
        },
        metadata_minus = { enable = false },
        horizontal_rules = {},
        headings = {
          enable = false,
        },
        code_blocks = {
          label_direction = "left",
          sign = false,
        },
        block_quotes = {},
        list_items = { enable = false },
        metadata_plus = {},
        reference_definitions = { enable = false },
      },
      typst = {
        enable = false,
      },
      yaml = {
        enable = false,
      },
    },
  },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   ft = { "markdown" },
  --   config = function()
  --     require("render-markdown").setup {
  --       -- Optional: you can add your custom settings here
  --       enabled = true,
  --       render_modes = true,
  --       debounce = 160,
  --       bullet = {
  --         render_modes = true,
  --         highlight = "@markup.list",
  --       },
  --       heading = {
  --         enabled = false,
  --       },
  --       quote = {
  --         render_modes = true,
  --       },
  --       html = {
  --         comment = {
  --           -- Turn on / off HTML comment concealing.
  --           conceal = false,
  --         },
  --       },
  --       code = {
  --         enabled = false,
  --       },
  --       latex = {
  --         enabled = false,
  --       },
  --     }
  --   end,
  -- },
}

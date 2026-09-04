return {
  -- add utf-8 code completion support
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "micangl/cmp-vimtex",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      -- add vimtex completion
      cmp.setup.filetype("tex", {
        sources = cmp.config.sources {
          -- new sources
          { name = "vimtex" },
          { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
          --- old sources
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "async_path" },
        },
      })

      cmp.setup.filetype("sql", {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
          --- old sources
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "async_path" },
        },
      })
      -- autocomplete unicode
      for _, source in ipairs(opts.sources) do
        if source.name == "buffer" then
          source.option = source.option or {}
          -- THIS is where keyword_pattern belongs
          source.option.keyword_pattern = [[\k\+]]
        end
      end
      -- tab should never expand snippets!
      local luasnip = require "luasnip"
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" })
    end,
  },
  -- vimtex completion
  {
    "micangl/cmp-vimtex",
  },
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
  -- fix luasnip issue
  {
    "L3MON4D3/LuaSnip",
    -- opts = {
    --   region_check_events = "InsertEnter",
    --   delete_check_events = "InsertLeave",
    -- },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  -- whitespace
  {
    "ntpeters/vim-better-whitespace",
    lazy = false,
    config = function() end,
    -- highlightgroup added in '$HOME/.config/nvim/lua/chadrc.lua'
  },
  {
    "andymass/vim-matchup",
    lazy = false,
    dependencies = {
      "kylechui/nvim-surround",
    },
    init = function()
      -- modify your configuration vars here
      -- vim.g.matchup_treesitter_stopline = 500
      vim.g.matchup_surround_enabled = 1

      -- -- or call the setup function provided as a helper. It defines the
      -- -- configuration vars for you
      -- require("match-up").setup {
      --   treesitter = {
      --     stopline = 500,
      --   },
      -- }
    end,
    -- or use the `opts` mechanism built into `lazy.nvim`. It calls
    -- `require('match-up').setup` under the hood
    ---@type matchup.Config
    opts = {
      treesitter = {
        stopline = 500,
      },
      matchparen = {
        deferred = 1,
        deferred_show_delay = 50, -- default
        deferred_hide_delay = 700, -- default
        -- NOTE: should be ok for now, issue was really markview
        -- nomode = "i", -- disable in insert mode for better performance
        offscreen = {
          method = "popup",
          scrolloff = 1,
        },
      },
      surround = {
        enabled = 1,
      },
    },
  },

  -- ##################### neovim qality of life ##############################

  -- {
  --   "folke/snacks.nvim",
  --   priority = 1000,
  --   lazy = false,
  --   -- ---@type snacks.Config
  --   -- opts = {
  --   --   -- your configuration comes here
  --   --   -- or leave it empty to use the default settings
  --   --   -- refer to the configuration section below
  --   --   -- bigfile = { enabled = true },
  --   --   -- dashboard = { enabled = true },
  --   --   -- explorer = { enabled = true },
  --   --   -- indent = { enabled = true },
  --   --   -- input = { enabled = true },
  --   --   -- picker = { enabled = true },
  --   --   -- notifier = { enabled = true },
  --   --   -- quickfile = { enabled = true },
  --   --   -- scope = { enabled = true },
  --   --   -- scroll = { enabled = true },
  --   --   -- statuscolumn = { enabled = true },
  --   --   -- words = { enabled = true },
  --   -- },
  --   ------------ toggle for profiling -----------------------
  --   -- -- Somehow broken right now!
  --   -- opts = function()
  --   --   -- Toggle the profiler
  --   --   Snacks.toggle.profiler():map "<leader>pp"
  --   --   -- Toggle the profiler highlights
  --   --   Snacks.toggle.profiler_highlights():map "<leader>ph"
  --   -- end,
  --   -- keys = {
  --   --   {
  --   --     "<leader>ps",
  --   --     function()
  --   --       Snacks.profiler.scratch()
  --   --     end,
  --   --     desc = "Profiler Scratch Bufer",
  --   --   },
  --   -- },
  --   ---------------------------------------------------------
  -- },

  -- ########################## Python ########################################
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "nvim-dap",
    },
  },
  -- ############################ Java ########################################
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "nvim-dap",
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- {
      --   "igorlfs/nvim-dap-view",
      --   dependencies = { "mfussenegger/nvim-dap" },
      --   -- config = function()
      -- },
      {
        "theHamsta/nvim-dap-virtual-text",
      },
    },
    config = function()
      local dap = require "dap"
      local code_win
      local function make_terminal_view(config)
        local term_buf = vim.api.nvim_create_buf(false, true)
        code_win = vim.api.nvim_get_current_win()
        vim.cmd "split"
        vim.cmd "horizontal resize 25"
        local term_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(term_win, term_buf)
        -- dap.repl.open({}, "vertical split")
        local widgets = require "dap.ui.widgets"
        local width = vim.api.nvim_win_get_width(term_win) - 2
        local scopes_w = math.floor(width * 0.4)
        local frames_w = math.floor(width * 0.25)

        vim.notify("window width: " .. width .. " cols")
        widgets
          .sidebar(widgets.frames, { width = frames_w }, "vertical split")
          .open()
        vim.api.nvim_set_current_win(term_win)
        widgets
          .sidebar(widgets.scopes, { width = scopes_w, wrap = false }, "vertical split")
          .open()
        vim.api.nvim_set_current_win(code_win)
        return term_buf, term_win
      end
      dap.defaults.fallback.terminal_win_cmd = make_terminal_view
      dap.defaults.fallback.switchbuf = function(bufnr, line, column)
        if not vim.api.nvim_win_is_valid(code_win) then
          return -- fall back to default
        end
        vim.api.nvim_win_set_buf(code_win, bufnr)
        vim.api.nvim_win_set_cursor(code_win, { line, column })
        vim.api.nvim_set_current_win(code_win)
      end

      vim.cmd "hi DapColor guifg=#ecbe7b"
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "", texthl = "DapColor", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "→", texthl = "DapColor", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "C", texthl = "DapColor", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "L", texthl = "DapColor", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "R", texthl = "DapColor", linehl = "", numhl = "" }
      )
      local map = vim.keymap.set
      map("n", "<F5>", function()
        dap.continue()
      end, { desc = "dap continue" })
      map("n", "<F10>", function()
        dap.step_over()
      end, { desc = "dap step over" })
      map("n", "<F11>", function()
        dap.step_into()
      end, { desc = "dap step into" })
      map("n", "<F12>", function()
        dap.step_out()
      end, { desc = "dap step out" })
      map("n", "<localleader>b", function()
        dap.toggle_breakpoint()
      end, { desc = "dap toggle breakpoint" })
      map("n", "<localleader>B", function()
        dap.set_breakpoint()
      end, { desc = "dap set breakpoint" })

      map("n", "<localleader>lp", function()
        dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end, { desc = "dap set log point" })

      map("n", "<localleader>dr", function()
        dap.repl.open({}, "split")
      end, { desc = "dap open repl" })
      map("n", "<localleader>dl", function()
        dap.run_last()
      end, { desc = "dap run last" })

      map({ "n", "v" }, "<localleader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "dap hover" })

      map({ "n", "v" }, "<localleader>dp", function()
        require("dap.ui.widgets").preview()
      end, { desc = "dap preview" })

      map("n", "<localleader>df", function()
        local widgets = require "dap.ui.widgets"
        widgets.centered_float(widgets.frames)
      end, { desc = "dap frames" })

      map("n", "<localleader>ds", function()
        local widgets = require "dap.ui.widgets"
        widgets.centered_float(widgets.scopes)
      end, { desc = "dap scopes" })
    end,
  },
  -- #######################################################################

  -- ############################ Lean #####################################
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
      -- optional dependencies:

      -- 'nvim-telescope/telescope.nvim', -- for Lean-specific pickers
      -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
      -- 'tomtom/tcomment_vim',           -- for commenting
    },

    ---@type lean.Config
    opts = { -- see the manual for full configuration options
      mappings = true,
    },
  },
  -- #######################################################################

  -- ############################ Lua ######################################
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- Load plugin types when the `vim.uv` word is found
        { path = "$HOME/.local/share/nvim/lazy", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
      }, ---@type lazydev.Library.spec[]
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },
  -- #######################################################################
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
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "luadoc",
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
        "latex",
        "bibtex",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitignore",
        "ssh_config",
        "sql",
        "kdl",
        "xml",
        "regex",
        "regex",
        "lean", -- this uses custom url
      },
    },
  },
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
  -- Maybe add after getting mor familiar with diff mode
  -- Diffview for nvim
  -- {
  -- 'sindrets/diffview.nvim',
  --   requires = 'nvim-lua/plenary.nvim',
  --   config = function()
  --       require'diffview'.setup {}
  --   end,
  -- },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      custom_surroundings = {
        -- Lua long brackets
        s = {
          -- Configuration for "input" (like for delete) is done with Lua patterns
          input = { find = "%[%[.-%]%]", extract = "^(..).*(..)$" },
          -- Configuration for "output" (like for add) is done with plain text
          output = { left = "[[", right = "]]" },
        },
        -- Use `(` to insert with spaces, `)` will still add without them
        ["("] = { output = { left = "( ", right = " )" } },
      },
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },
  -- try nvim surround
  -- see: :h nvim-surround.usage
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      }
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = require "configs.markview",
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    dependencies = {
      "folke/which-key.nvim",
    },
    init = require "configs.vimtex",
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

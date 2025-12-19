local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" }, -- Hier wird die colorcolumn aktiviert
  callback = function()
    vim.opt.colorcolumn = "80"
  end,
})

-- Deaktiviere die colorcolumn für bestimmte Dateitypen
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "html", "text", "tex", "nvdash", "man" }, -- Hier wird die colorcolumn deaktiviert
  callback = function()
    vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn
  end,
})
-- ################################ nvim/cmp ####################################
-- add custom sources here:
-- local cmp = require "cmp"
-- cmp.setup.filetype({ "sql" }, {
--   { name = "vim-dadbod-completion" },
--   { name = "buffer" },
-- })
-- Dynamically add vim-dadbod-completion for SQL files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    -- Load vim-dadbod-completion if not already loaded
    pcall(require, "vim-dadbod-completion")

    local cmp = require "cmp"
    -- Update cmp sources for this buffer
    cmp.setup.buffer {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    }
  end,
})
-- ################################ Folds ######################################
-- Silently load view
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
  command = "silent! loadview",
})
-- enable code folding via LSP/treesitter and disable for haskell
-- Function to set folding based on LSP or fallback to Treesitter
local function set_folds()
  if vim.lsp.get_clients() and next(vim.lsp.get_clients()) then
    -- Use LSP for folding
    vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
  elseif vim.treesitter then
    -- Fallback to Treesitter for folding
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  else
    -- Default to no folding
    vim.opt_local.foldmethod = "manual"
  end
end
vim.opt.foldmethod = "expr" -- Set fold method to expression
vim.opt.foldlevel = 99 -- Open all folds by default
vim.opt.foldtext = "" -- Customize fold text if needed
vim.api.nvim_create_augroup("Folds", { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter" }, {
  group = "Folds",
  callback = function()
    if vim.bo.filetype ~= "haskell" then
      set_folds()
    else
      -- Default to no folding
      vim.opt_local.foldmethod = "manual"
    end
  end,
})
-- #################### tmux after start #######################################
autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    if os.getenv "TMUX" then
      vim.fn.jobstart(
        { "tmux", "wait-for", "-S", "nvim-start" },
        { detach = true }
      )
      print "Signaled tmux: nvim-start"
    end
  end,
})

-- ########################## Tab Width ########################################
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "c", "java", "tex" }, -- Dateitypen bei denen ich 4 Indents will
  callback = function()
    vim.opt_local.tabstop = 4 -- Number of spaces for a Tab in C files
    vim.opt_local.shiftwidth = 4 -- Indentation level for C files
  end,
})

-- #################### c coding stuff #########################################
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" }, -- Dateitypen bei denen ich 4 Indents will
  callback = function()
    vim.opt_local.expandtab = false -- why gnu make, tab bad
    vim.opt_local.tabstop = 4 -- Number of spaces for a Tab in C files
    vim.opt_local.shiftwidth = 4 -- Indentation level for C files
  end,
})
-- enable c syntax highlighting for header files
vim.g.c_syntax_for_h = 1

-- ############### markdown/text stuff #########################################

-- set indentation for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.keymap.set("i", "$", "$$<Left>", { buffer = true })
  end,
})

-- Aktiviere line break für Text- und Markdown-Dateien
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex" }, -- Dateitypen, für die line break aktiviert werden soll
  callback = function(event)
    local ft = event.match
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg.relative == "" then
      vim.opt_local.linebreak = true -- Aktiviert Zeilenumbrüche
      vim.opt_local.spelllang = {
        "de_20",
        "en_us",
      }
      vim.opt_local.spellsuggest = {
        "best",
        12,
      }
      vim.opt.spellfile = vim.fn.expand "~/.config/nvim/spell/de.utf-8.add"
      if ft == "markdown" or ft == "tex" then
        vim.opt_local.spell = true
      end
    end
  end,
})

-- disable spell for terminal
-- currently unneded!
-- autocmd("FileType", {
--   pattern = { "NvTerm_sp", "NvTerm_float", "NvTerm_vsp" },
--   callback = function() end,
-- })

vim.api.nvim_create_autocmd("User", {
  pattern = "MarkviewEnable", -- ← fires after markview loads its highlights
  callback = function()
    vim.print "color"
    vim.schedule(function()
      -- code and codeinfo are deprecated, setting for no reason!
      vim.cmd [[
        highlight MarkviewCode guibg=#32363e
        highlight MarkviewPalette0Bg guibg=#32363e
        highlight MarkviewPalette0 guibg=#32363e
        highlight MarkviewCodeInfo guibg=#32363e
        highlight MarkviewIcon0 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon1 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon2 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon3 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon4 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon5 guifg=#ecbe7b guibg=#32363e
        highlight MarkviewIcon6 guifg=#ecbe7b guibg=#32363e
        ]]
    end)
  end,
})

-- set conceallevel=0 everywhere, just to be sure when markview is loaded
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function(event)
    local buffer = event.buf
    ---@type string[]
    local mkv_b = { "markdown" }

    --- If `markview.nvim` is loaded fetch the configuration option for filetypes.
    if package.loaded["markview.spec"] then
      mkv_b = package.loaded["markview.spec"].get(
        { "preview", "filetypes" },
        { fallback = {} }
      )
    end

    if vim.list_contains(mkv_b, vim.bo[buffer].ft) == false then
      ---@type integer[]
      local wins = vim.fn.win_findbuf(buffer)

      --- 'conceallevel' is a window option, so we must apply it to every window that is showing this buffer.
      for _, win in ipairs(wins) do
        vim.wo[win].conceallevel = 0
      end
    end
  end,
})

-- ############### end markdown/text stuff #####################################

-- hide terminal padding

autocmd("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

-- Make syntax highlihgting of man pagees work properly
dofile(vim.g.base46_cache .. "syntax")
-- fix for regression
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == "man"
      then
        -- Feed Shift-K twice
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("KK", true, false, true),
          "n",
          false
        )
      end
    end
  end,
})
-- INFO: deprecated, see above
-- autocommand for reapplying the theme upon man page opening
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "man",
--   callback = function()
--     require("nvchad.themes.utils").reload_theme "doomchad"
--     vim.opt.showtabline = 0 -- remove tab line
--     vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn
--     --turn off padding, padding on looks better
--     --vim.opt.signcolumn = "no"
--   end,
--   once = true,
-- })

-- ############### DB_UI/SQL ###################################################

-- helper function setting up "setup database keybind in sql buffers"
local function map_setup_database(buf)
  map("n", "<leader>sd", function()
    local input =
      vim.fn.input("enter cmd to open database: ", "", "shellcmdline")
    if input == "" then
      print "no input, aborting..."
      return
    end
    -- init Terminal
    require("nvchad.term").runner {
      pos = "sp",
      id = "htoggleTerm",
      --      cmd = input,
      cmd = "clear",
      clear_cmd = "",
    }
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      false
    )
    -- setub vim-dadbod-completion
    -- currently broken with duckDB due to database locks!
    local inputWords = {}
    for word in string.gmatch(input, "[^%s]+") do
      table.insert(inputWords, word)
    end
    -- abort if string is malformed
    if #inputWords < 2 then
      print "dbs cmd should be of the form: <dbms> <URL>"
      return
    end
    vim.api.nvim_buf_set_var(
      buf,
      "db",
      table.concat(inputWords, ":", 1, 2)
        .. table.concat(inputWords, "", 3, #inputWords)
    )
    -- setup autocommand to send entire buffer on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,

      callback = function()
        require("nvchad.term").runner {
          pos = "sp",
          id = "htoggleTerm",
          cmd = table.concat(
            vim.api.nvim_buf_get_lines(
              buf,
              0,
              vim.api.nvim_buf_line_count(buf),
              false
            ),
            "\n"
          ) .. ";\n.quit",
          clear_cmd = input .. "\n",
        }
      end,
    })
  end, {
    buffer = buf,
    desc = "setup databank",
    noremap = true,
  })
end

-- true if buffer was found by dbui
local function has_dbui_save_hook(buf)
  local autocmds = vim.api.nvim_get_autocmds {
    event = "BufWritePost",
    buffer = buf,
  }

  for _, ac in ipairs(autocmds) do
    if ac.group_name == "db_ui_query" then
      return true
    end
  end

  return false
end

-- Set up DBUI mappings when DBUI opens
local dbui_map_group =
  vim.api.nvim_create_augroup("DBUIQueryKeymaps", { clear = false })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function(ev)
    local buf = ev.buf
    -- set keymap to this buffer
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>F", ":DBUIFindBuffer<CR>", {
      desc = "try to open buffer with DBUI",
      noremap = true,
    })

    map_setup_database(buf)

    -- autocmd to fix creation of mappings when using `DBUIFindBuffer`
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      buffer = buf, -- buffer-local
      group = dbui_map_group,
      once = false,
      callback = function()
        -- Check if DBUI has initialized this buffer
        if not has_dbui_save_hook(buf) then
          return
        end

        local opts = { buffer = buf, silent = true }

        map("n", "<leader>S", "<Plug>(DBUI_ExecuteQuery)", opts)
        map("v", "<leader>S", "<Plug>(DBUI_ExecuteQuery)", opts)
        map("n", "<leader>E", "<Plug>(DBUI_EditBindParameters)", opts)
        map("n", "<leader>W", "<Plug>(DBUI_SaveQuery)", opts)

        -- remove this autocmd after it worked
        vim.api.nvim_clear_autocmds { group = dbui_map_group, buffer = buf }
      end,
    })
  end,
})

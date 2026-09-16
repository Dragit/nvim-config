local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

-- autopairs
local Rule = require "nvim-autopairs.rule"
local npairs = require "nvim-autopairs"
local cond = require "nvim-autopairs.conds"
local ts_conds = require "nvim-autopairs.ts-conds"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    vim.opt.colorcolumn = "80"
  end,
})

-- Deaktiviere die colorcolumn für bestimmte Dateitypen
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "html", "text", "tex", "nvdash", "man" },
  callback = function()
    vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn
  end,
})

-- Make diagnostics underline red
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineError",
  { underline = true, sp = "#ff6b5a" }
)

vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineWarn",
  { underline = true, sp = "#ECBE7B" }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineInfo",
  { underline = true, sp = "#46D9FF" }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineHint",
  { underline = true, sp = "#98be65" }
)

-- ############################### python ######################################
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    require("configs.python"):setup()
  end,
})

-- ############################### svlib ######################################
vim.g.svlib_rainbow_brackets = 1
-- override colorify attach
vim.api.nvim_create_autocmd("FileType", {
  pattern = "svlib",
  callback = function()
    local colorify = require "nvchad.colorify"
    colorify.attach = function()
      -- do nothing
    end
  end,
})
-- ####################### haskel-lean-treesitter-grammar ######################
vim.api.nvim_create_user_command("AddLeanDocHighlight", function()
  local path = vim.fn.stdpath "data" .. "/site/queries/lean/injections.scm"
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local f = io.open(path, "w")
  if f then
    f:write '((block_comment) @injection.content\n  (#set! injection.language "markdown"))\n'
    f:close()
    print("Written: " .. path)
  else
    print("FAILED: " .. path)
  end
end, {})

autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    -- require("nvim-treesitter.parsers").haskell = {
    --   install_info = {
    --     url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell",
    --     branch = "master",
    --   },
    -- }
    require("nvim-treesitter.parsers").lean = {
      install_info = {
        url = "https://github.com/Julian/tree-sitter-lean",
        queries = "queries", -- also install queries from given directory
        -- revision = "", -- commit hash for revision to check out; HEAD if missing
        -- optional entries:
        -- branch = 'develop', -- only needed if different from default branch
        -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
        -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
        -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
        -- queries = 'queries/neovim',
      },
      tier = 2,
    }
  end,
})

-- ########################## Trailing Whitespace ##############################
-- currently using vim-better-whitespace
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = "*",
--   command = [[
--     syntax clear TrailingWhitespace |
--     syntax match TrailingWhitespace "\s\+$\| \+\ze\t\+"
--   ]],
-- })
-- ################################ Folds ######################################
vim.o.viewoptions = "folds"
local folds = vim.api.nvim_create_augroup("folds", { clear = true })

-- open all folds
vim.o.foldlevel = 99
-- empty to show text of top line!
vim.opt.foldtext = ""
-- Save view
autocmd("BufWritePost", {
  group = folds,
  callback = function()
    vim.cmd "silent! mkview"
  end,
})

-- Decide folding engine
local function set_folds()
  if vim.bo.filetype == "haskell" then
    vim.opt_local.foldmethod = "manual"
    return
  end
  local clients = vim.lsp.get_clients { bufnr = 0 }
  for _, client in ipairs(clients) do
    if
      client.server_capabilities
      and client.server_capabilities.foldingRangeProvider
    then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
      return
    end
  end

  -- Treesitter fallback
  if pcall(vim.treesitter.get_parser, 0) then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    return
  end

  -- manual fallback if no lsp and no treeseitter
  vim.opt_local.foldmethod = "manual"
end

-- Load view
autocmd("BufWinEnter", {
  group = folds,
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "gitcommit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.schedule(function()
        if vim.wo.diff then
          vim.cmd "normal! gg"
          return
        end
      end)
      set_folds()
      vim.cmd "silent! loadview"
      vim.cmd 'normal! g`"'
    end
  end,
})

-- Re-evaluate when LSP attaches
autocmd("LspAttach", {
  group = folds,
  callback = function(args)
    if vim.wo.diff then
      return
    end
    if args.buf == vim.api.nvim_get_current_buf() then
      set_folds()
    end
  end,
})

-- fix folds not recomputing, by wrapping all fold keymaps
local function fold_keymap(lhs, safe, opts)
  -- erly return if there is no fold
  if safe ~= nil and not safe then
    local current_line = vim.fn.line "."
    local fold_closed = vim.fn.foldclosed(current_line)
    if fold_closed == -1 then
      return
    end
  end

  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.keymap.set({ "n", "x", "o" }, lhs, function()
    local method = vim.o.foldmethod
    -- vim.print("refresh by ressetting " .. method)
    -- Force fold recomputation
    vim.cmd("set foldmethod=" .. method)
    -- Execute the fold key without recursion
    vim.cmd("normal! " .. lhs)
  end, options)
end

-- Fold movement
fold_keymap "]z"
fold_keymap "[z"

-- Fold operations
fold_keymap("za", false)
fold_keymap("zo", false)
fold_keymap("zO", false)
fold_keymap("zc", false)
fold_keymap("zC", false)
fold_keymap "zR"
fold_keymap "zM"

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
  pattern = { "markdown", "html", "css", "lua", "haskell" }, -- Dateitypen bei denen ich 4 Indents will
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- ################################ lean ######################################
npairs.add_rule(Rule("/-", "-/", "lean"))

-- ########################## make #############################################
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" }, -- Dateitypen bei denen ich 4 Indents will
  callback = function()
    vim.opt_local.expandtab = false -- why gnu make, tab bad
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
-- ############################# C #############################################
-- enable c syntax highlighting for header files
vim.g.c_syntax_for_h = 1

-- ########################## haskell ##########################################
-- disable vim-matchup for haskell
autocmd("FileType", {
  pattern = { "haskell" },
  callback = function()
    vim.b.matchup_matchparen_enabled = 0
    vim.b.loaded_matchparen = 1
  end,
})
-- TEST: lazy load for ceartain files
-- autocmd({ "BufReadPost", "BufNewFile" }, {
--   pattern = "*",
--   callback = function()
--     vim.defer_fn(function()
--       local excluded_fts = function()
--         local current_buf = vim.api.nvim_get_current_buf()
--         local current_filetype =
--           vim.api.nvim_get_option_value("filetype", { buf = current_buf })
--
--         -- Excluded filetype
--         -- Can either add the filetype or file extensions
--         -- ex. 'text' or 'txt'
--         local filetypes = {
--           "haskell",
--         }
--
--         for _, filetype in ipairs(filetypes) do -- Checks filetype
--           if current_filetype == filetype then
--             return true -- Skip for excluded filetypes
--           end
--         end
--         return false
--       end
--       if excluded_fts() then
--         print " No vim-matchup: Excluded Filetype"
--         vim.defer_fn(function()
--           vim.cmd 'echo ""'
--         end, 2000)
--       else
--         vim.cmd "Lazy load vim-matchup"
--         print " vim-matchup loaded"
--       end
--     end, 500)
--   end,
-- })
-- ################### markdown/text stuff #####################################

-- NOTE: not rules must be first
npairs.add_rules {
  Rule("$", "$", { "tex", "markdown" })
    :with_pair(cond.not_after_regex("[%p%c%a]", 1))
    :with_pair(ts_conds.is_not_ts_node {
      "string",
      "comment",
      "block_comment",
      "code_span",
      "fenced_code_block",
      "expression",
      "declarations",
    })
    :with_pair(cond.after_regex("$", 1)),
  Rule("*", "**", { "markdown" })
    :with_pair(cond.not_before_text "**")
    :with_pair(cond.not_after_regex("[%w]", 1))
    :with_pair(cond.not_before_regex("%w%*", 2))
    :with_pair(cond.before_text "*"),
  Rule("*", "*", { "markdown" })
    :with_pair(cond.not_after_regex("[%w]", 1))
    :with_pair(cond.before_text "**"),
}

-- set indentation for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    -- vim.keymap.set("i", "$", "$$<Left>", { buffer = true })
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

-- ############### end markdown/text stuff ####################################

-- ############### Genereal ###################################################
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
autocmd("VimEnter", {
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
autocmd("FileType", {
  pattern = "man",
  callback = function()
    vim.opt.signcolumn = "yes:1"
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

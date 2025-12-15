local autocmd = vim.api.nvim_create_autocmd
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
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Aktiviere linebreak für Text- und Markdown-Dateien
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex" }, -- Dateitypen, für die linebreak aktiviert werden soll
  callback = function()
    vim.opt.linebreak = true -- Aktiviert Zeilenumbrüche
  end,
})

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

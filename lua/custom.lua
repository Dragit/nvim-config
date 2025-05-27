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
-- enable code folding via treesitter
vim.opt.foldmethod = "expr" -- Set fold method to expression
vim.opt.foldlevel = 99 -- Open all folds by default
vim.opt.foldtext = "" -- Customize fold text if needed
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter" }, {
  callback = function()
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter for folding
  end,
})
-- #################### c coding stuff #########################################
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c" }, -- Dateitypen bei denen ich 4 Indents will
  callback = function()
    vim.opt_local.tabstop = 4 -- Number of spaces for a Tab in C files
    vim.opt_local.shiftwidth = 4 -- Indentation level for C files
  end,
})

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

-- set indentation and conceallevel for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2 -- Number of spaces for a Tab in C files
    vim.opt_local.shiftwidth = 2 -- Indentation level for C files
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
local autocmd = vim.api.nvim_create_autocmd

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

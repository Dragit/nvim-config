-- set colorcolumn for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" }, -- Hier wird die colorcolumn aktiviert
  callback = function()
    vim.opt.colorcolumn = "80"
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

-- set indentation for markdown files
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

-- Deaktiviere die colorcolumn für bestimmte Dateitypen
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "html", "text", "tex", "nvdash" }, -- Hier wird die colorcolumn deaktiviert
  callback = function()
    vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn
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

-- autocommand for reapplying the theme upon man page opening
vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  callback = function()
    require("nvchad.themes.utils").reload_theme "doomchad"
    vim.opt.showtabline = 0 -- remove tab line
    vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn

    --turn off padding
    --vim.opt.signcolumn = "no"
  end,
  once = true,
})

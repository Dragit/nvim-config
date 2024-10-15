-- Setze die colorcolumn für alle filetypen
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" }, -- Hier wird die colorcolumn aktiviert
  callback = function()
    vim.opt.colorcolumn = "80"
  end,
})

-- Deaktiviere die colorcolumn für bestimmte Dateitypen
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "html", "text", "tex", "nvdash" }, -- Hier wird die colorcolumn deaktiviert
  callback = function()
    vim.opt.colorcolumn = "" -- Deaktiviert die colorcolumn
  end,
})

-- Aktiviere linebreak für Text- und Markdown-Dateien
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex" }, -- Dateitypen, für die linebreak aktiviert werden soll
  callback = function()
    vim.opt.linebreak = true -- Aktiviert Zeilenumbrüche
  end,
})

local function scroll_up_dashboard()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype == "nvdash" then
    vim.cmd "normal! gg"
  end
end

-- autocommand to scroll up the dashboard
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nvdash",
  callback = function()
    print "nvdash opened!"
    scroll_up_dashboard()
  end,
})

-- Setze die colorcolumn für alle filetypen
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"*"},  -- Hier wird die colorcolumn aktiviert
    callback = function()
        vim.opt.colorcolumn = "80"
    end,
})

-- Deaktiviere die colorcolumn für bestimmte Dateitypen
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"markdown", "html", "text"},  -- Hier wird die colorcolumn deaktiviert
    callback = function()
        vim.opt.colorcolumn = ""  -- Deaktiviert die colorcolumn
    end,
})

-- Aktiviere linebreak für Text- und Markdown-Dateien
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"text", "markdown"},  -- Dateitypen, für die linebreak aktiviert werden soll
    callback = function()
        vim.opt.linebreak = true  -- Aktiviert Zeilenumbrüche
    end,
})

-- Key mapping to generate JSDoc comments
vim.api.nvim_set_keymap('n', '<leader>jd', ':JsDoc<CR>', {
    noremap = true, silent = true
  })


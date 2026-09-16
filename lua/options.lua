require "nvchad.options"

-- add yours here!

local o = vim.o

o.timeoutlen = 1000 -- make whichkey work properly with vim surround
--o.timeout = false -- make whichkey work properly with vim surround
o.cursorlineopt = "both" -- to enable cursorline!
o.laststatus = 2 -- enable statusbar on all windows
o.relativenumber = true
-- o.linebreak = true -- handlead in custom
-- o.colorcolumn = "80" -- create line at position 80 --handled in custom
o.tabstop = 4
o.shiftwidth = 4
o.updatetime = 2000 -- updatetime for lsp documenthover
o.winborder = "rounded"

o.conceallevel = 0 -- conceal markdwon formatting

o.spell = true
o.spelllang = "en_us"
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "",
  callback = function()
    vim.opt_local.spell = false
  end,
})

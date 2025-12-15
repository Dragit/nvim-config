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

o.conceallevel = 0 -- conceal markdwon formatting

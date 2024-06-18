require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- reIntroduce old mappings for reading all diagnostic text, not only lsp
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "lsp floating diagnostics" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

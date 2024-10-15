require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- reIntroduce old mappings for reading all diagnostic text, not only lsp
map(
  "n",
  "<leader>lf",
  vim.diagnostic.open_float,
  { desc = "lsp floating diagnostics" }
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- inlay hints toggle
vim.keymap.set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Key mapping to generate JSDoc comments
vim.api.nvim_set_keymap("n", "<leader>jd", ":JsDoc<CR>", {
  noremap = true,
  silent = true,
})
vim.api.nvim_set_keymap(
  "n",
  "<Leader>ar",
  [[:normal! o@returns {type}<CR>]],
  { noremap = true, silent = true }
)

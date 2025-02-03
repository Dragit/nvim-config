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
map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {
  desc = "toggle lsp inlay hints",
  noremap = true,
  silent = true,
})

-- ###################### JavaScript ###########################################
-- Key mapping to generate JSDoc comments
map("n", "<leader>jd", ":JsDoc<CR>", {
  desc = "gen JsDoc comment",
  noremap = true,
  silent = true,
})
map(
  "n",
  "<Leader>ar",
  [[:normal! o@returns {type}<CR>]],
  { desc = "JsDoc returns", noremap = true, silent = true }
)

-- ###################### markdown preview #####################################
map(
  "n",
  "<leader>mp",
  "<cmd>MarkdownPreviewToggle<CR>",
  { desc = "toggle markdown preview" }
)

-- keybind, to activate lsp code formatting
map("n", "<Leader>cf", function()
  vim.lsp.buf.format { async = false }
end, { desc = "format code using lsp", noremap = true, silent = true })

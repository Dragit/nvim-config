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

-- ###################### markdown #############################################
-- markdown preview
map(
  "n",
  "<leader>mp",
  "<cmd>MarkdownPreviewToggle<CR>",
  { desc = "toggle markdown preview" }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    map("n", "<leader>sp", function()
      local ls = require "luasnip"
      local vscode = require "luasnip.loaders.from_vscode"

      if not vim.g.plaintex_enabled_for_markdown then
        -- Enable: Extend markdown to include plaintex
        ls.filetype_extend("markdown", { "plaintex" })
        vscode.lazy_load()
        vim.g.plaintex_enabled_for_markdown = true
        print "Enabled plaintex snippets in markdown"
      else
        -- Disable: Remove the extension manually (LuaSnip doesn't provide a direct un-extend)
        -- So we "reset" the filetype extension table for markdown
        ls.filetype_set("markdown", { "markdown" }) -- Reset to just markdown
        vim.g.plaintex_enabled_for_markdown = false
        print "Disabled plaintex snippets in markdown"
      end

      -- Force buffer to re-apply snippet setup
      vim.cmd "doautocmd FileType"
    end, {
      desc = "Toggle plaintex snippets in markdown",
      silent = true,
    })
  end,
})

-- keybind, to activate lsp code formatting
map("n", "<Leader>cf", function()
  vim.lsp.buf.format { async = false }
end, { desc = "format code using lsp", noremap = true, silent = true })

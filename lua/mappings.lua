require "nvchad.mappings"

local map = vim.keymap.set

-- align in nvim
-- example with `=`
-- :! column -t -s= -o=

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

-- ###################### LSP ###############################################
-- recreate LSP code action
map("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, {
  desc = "LSP Code Action",
  noremap = true,
  silent = true,
})

-- ###################### Conform ###########################################
-- Toggle flag
vim.g.format_on_save_enabled = true

-- toggle function
local function toggle_format_on_save()
  vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled
  print(
    "Format on Save: "
      .. (vim.g.format_on_save_enabled and "Enabled" or "Disabled")
  )
end

-- Map <leader>tf
map(
  "n",
  "<leader>tf",
  toggle_format_on_save,
  { desc = "Toggle format on save" }
)

-- Create the :ToggleFormatOnSave command
vim.api.nvim_create_user_command(
  "ToggleFormatOnSave",
  toggle_format_on_save,
  {}
)

-- Format on save, only if enabled
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.g.format_on_save_enabled then
      require("conform").format { bufnr = args.buf, timeout_ms = 500 }
    end
  end,
})

-- keybind, to activate lsp code formatting
map("n", "<Leader>cf", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "format buffer using conform", noremap = true, silent = true })

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

-- ###################### SQL ##################################################
-- not entirely sql specific but created for sql use
-- Send a single line to the terminal
map("n", "<leader>sl", function()
  require("nvchad.term").runner {
    pos = "sp",
    id = "htoggleTerm",
    cmd = vim.api.nvim_get_current_line(),
    clear_cmd = "",
  }
end, {
  desc = "Send line to terminal",
  noremap = true,
})

-- Send a visual selection to the terminal
map("v", "<leader>st", function()
  require("nvchad.term").runner {
    pos = "sp",
    id = "htoggleTerm",
    cmd = function()
      local mode = vim.api.nvim_get_mode().mode
      local selection = ""
      if mode == "v" then
        local s_start = vim.fn.getpos "v"
        local s_end = vim.fn.getpos "."
        local lines = vim.fn.getregion(s_start, s_end)
        selection = table.concat(lines, "\n")
      elseif mode == "V" then
        local l_start = vim.fn.line "."
        local l_end = vim.fn.line "v"
        local lines = vim.fn.getline(
          math.min(l_start, l_end), -- smaller value fist
          math.max(l_start, l_end)
        )
        if type(lines) == "string" then
          lines = { lines }
        end
        selection = table.concat(lines, "\n")
      end
      return selection
    end,
    clear_cmd = "",
  }
end, {
  desc = "Send visual selection terminal",
  noremap = true,
})

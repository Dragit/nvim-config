local options = {
  formatters_by_ft = {
    c = { lsp_format = "fallback" },
    cpp = { lsp_format = "fallback" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    sql = { lsp_format = "fallback" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    python = { "ruff_format" },
  },

  -- format_on_save = {
  --   --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   --lsp_fallback = true, -- if enabled everything with a lsp-server will be formatted
  -- },
}

require("conform").setup(options)

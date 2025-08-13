local options = {
  formatters_by_ft = {
    c = { lsp_format = "fallback" },
    cpp = { lsp_format = "fallback" },
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    -- add more types if needed
  },

  -- format_on_save = {
  --   --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   --lsp_fallback = true, -- if enabled everything with a lsp-server will be formatted
  -- },
}

require("conform").setup(options)

-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "cssls",
  "hls",
  "jdtls",
  "marksman",
  "ts_ls",
  "jsonls",
  "eslint",
  "stylelint_lsp",
  "pylsp",
} -- , "ltex"

-- Custom on_attach function to enable inlay hints
local custom_on_attach = function(client, bufnr)
  -- Call the default on_attach from NvChad
  on_attach(client, bufnr)

  -- Enable inlay hints if the LSP supports them
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach,
    on_init = on_init,
    capabilities = capabilities,
    -- Enable inlay hints
    -- single_file_support = false,
  }
end

lspconfig["clangd"].setup {
  on_attach = function(client, bufnr)
    -------------- uncomment to enable autoformat on save ---------------------
    -- if client.server_capabilities.documentFormattingProvider then
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     buffer = bufnr,
    --     callback = function()
    --       vim.lsp.buf.format { async = false }
    --     end,
    --   })
    -- end
    on_attach(client, bufnr)
  end,
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--completion-style=detailed",
  },
  capabilities = capabilities,
  language_id = "c",
}

lspconfig["ltex"].setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = {
    "bib",
    "gitcommit",
    "markdown",
    "org",
    "plaintex",
    "rst",
    "rnoweb",
    "tex",
    "pandoc",
    "quarto",
    "rmd",
    "context",
    "mail",
    "text",
  },
  settings = {
    ltex = {
      language = "en-US", --"de-DE" for german
      -- checkFrequency = "save", -- activate this for less checks
    },
  },
}

-- disable tssserver formatting and enable inlay hints
lspconfig["ts_ls"].setup {
  on_attach = function(client)
    -- Disable ts_ls formatting
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
      },
    },

    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
      },
    },
  },
}

--
-- typescript
-- lspconfig.ts_ls.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

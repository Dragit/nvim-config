-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "hls", "jdtls", "marksman", "ts_ls",
  "jsonls","eslint", "stylelint_lsp"} -- , "ltex"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    -- single_file_support = false,
  }
end

lspconfig["ltex"].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context", "mail", "text" },
    settings = {
    		ltex = {
    			language =  "en-US", --"de-DE" for german
    		},
    	},
}

-- disable tssserver formattign
lspconfig["ts_ls"].setup {
    on_attach = function(client)
      -- Disable ts_ls formatting if you're using a different formatter like prettier
      client.server_capabilities.documentFormattingProvider = false
    end,
}

--
-- typescript
-- lspconfig.ts_ls.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

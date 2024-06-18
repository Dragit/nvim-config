-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "hls", "jdtls", "marksman"} -- , "ltex"

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
    settings = {
    		ltex = {
    			language =  "de-DE",
    		},
    	},
}
--
-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

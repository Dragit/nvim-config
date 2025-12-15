local servers = {
  html = {},
  cssls = {},
  hls = {},
  marksman = {},
  ts_ls = {
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
  },
  jsonls = {},
  eslint = {},
  stylelint_lsp = {},
  pylsp = {},
  clangd = {
    cmd = {
      "clangd",
      -- "--header-insertion=never", -- uncomment to disable autoimports
      "--completion-style=detailed",
    },
    language_id = "c",
  },
  -- jdtls = {
  --   root_dir = vim.fs.dirname(
  --     vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
  --   ),
  --   -- settings = {
  --   --   java = {
  --   --     configuration = {
  --   --       runtimes = {
  --   --         {
  --   --           name = "JavaSE-21", -- or JavaSE-15 if you're using Java 15
  --   --           path = "/usr/lib/jvm/java-21-openjdk", -- adjust to your JDK
  --   --           default = true,
  --   --         },
  --   --       },
  --   --     },
  --   --     compiler = {
  --   --       source = "21", -- enable text blocks
  --   --       compliance = "21",
  --   --       target = "21",
  --   --     },
  --   --   },
  --   -- },
  -- },
  ltex = {
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
      -- "text",
    },
    settings = {
      ltex = {
        language = "en-US", -- "de-DE" for German
        checkFrequency = "save",
        additionalRules = {
          -- enablePickyRules = true,
          motherTongue = "de-DE",
        },
        disabledRules = {
          ["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
          ["de-DE"] = { "GERMAN_SPELLER_RULE", "BISSTRICH" },
        },
      },
    },
  },
}

-- Setup each server
for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- fix border of lsp
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- especially setup config
vim.lsp.config("java", {})
-- setup jdtls properly
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "java",
  callback = function()
    require("jdtls.config_setup"):setup()
  end,
})

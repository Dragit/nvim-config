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
  -- zuban = {
  --   -- on_init = function(client, _)
  --   --   if client:supports_method "hoverProvider" then
  --   --     client.server_capabilities.hoverProvider = false
  --   --   end
  --   -- end,
  --   init_options = {
  --     diagnosticMode = "workspace",
  --     -- typeCheckingMode = "mypy",
  --   },
  -- },
  -- just used for Autoimports
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          -- reportPrivateLocalImportUsage = false,
          -- typeCheckingMode = "standard", -- this will remove most warnings
          -- autoImportCompletions = true,
        },
        -- disableTaggedHints = true,
      },
    },
  },
  --   on_init = function(client, _)
  --     -- if client:supports_method "hoverProvider" then
  --     --   client.server_capabilities.hoverProvider = false
  --     -- end
  --     if client:supports_method "declarationProvider" then
  --       client.server_capabilities.declarationProvider = false
  --     end
  --     if client:supports_method "definitionProvider" then
  --       client.server_capabilities.definitionProvider = false
  --     end
  --     if client:supports_method "documentHighlightProvider" then
  --       client.server_capabilities.documentHighlightProvider = false
  --     end
  --     if client:supports_method "documentOnTypeFormattingProvider" then
  --       client.server_capabilities.documentOnTypeFormattingProvider = false
  --     end
  --     if client:supports_method "documentSymbolProvider" then
  --       client.server_capabilities.documentSymbolProvider = false
  --     end
  --     if client:supports_method "executeCommandProvider" then
  --       client.server_capabilities.executeCommandProvider = false
  --     end
  --     if client:supports_method "implementationProvider" then
  --       client.server_capabilities.implementationProvider = false
  --     end
  --     if client:supports_method "inlayHintProvider" then
  --       client.server_capabilities.inlayHintProvider = false
  --     end
  --     if client:supports_method "referencesProvider" then
  --       client.server_capabilities.referencesProvider = false
  --     end
  --     if client:supports_method "renameProvider" then
  --       client.server_capabilities.renameProvider = false
  --     end
  --     if client:supports_method "signatureHelpProvider" then
  --       client.server_capabilities.signatureHelpProvider = false
  --     end
  --     if client:supports_method "typeDefinitionProvider" then
  --       client.server_capabilities.typeDefinitionProvider = false
  --     end
  --     if client:supports_method "workspaceSymbolProvider" then
  --       client.server_capabilities.workspaceSymbolProvider = false
  --     end
  --   end,
  -- },
  -- pyright = {
  --   python = {
  --     analysis = {
  --       autoSearchPaths = true,
  --       diagnosticMode = "openFilesOnly",
  --       useLibraryCodeForTypes = true,
  --     },
  --   },
  -- },
  -- just for better docs!
  -- jedi_language_server = {
  --   init_options = {
  --     diagnostics = { enable = false },
  --     hover = { enable = true },
  --   },
  --   on_init = function(client, _)
  --     if client:supports_method "completionProvider" then
  --       client.server_capabilities.completionProvider = false
  --     end
  --     if client:supports_method "definitionProvider" then
  --       client.server_capabilities.definitionProvider = false
  --     end
  --   end,
  -- },
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         -- linter options
  --         pylint = { enabled = false, executable = "pylint" },
  --         pycodestyle = {
  --           enabled = false,
  --           -- ignore = { "E231", "E501" },
  --         },
  --         pyflakes = { enabled = false },
  --         -- type checker
  --         pylsp_mypy = { enabled = true },
  --         -- auto-completion options
  --         jedi_completion = { fuzzy = true },
  --         -- import sorting
  --         -- pyls_isort = { enabled = true },
  --       },
  --     },
  --   },
  -- },
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
  --  sqls = {},
  sqruff = {},
}

-- Setup each server
for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- Remove to see how I like it
-- fix border of lsp
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   opts = opts or {}
--   opts.border = "rounded"
--   return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end

-- especially setup config
vim.lsp.config("java", {})
-- setup jdtls properly
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("jdtls.config_setup"):setup()
  end,
})

local function dedupe_qflist()
  local function dedupe(list)
    local seen, new = {}, {}
    for _, item in ipairs(list.items) do
      local key = table.concat({
        tostring(item.bufnr or 0),
        tostring(item.lnum or 0),
        tostring(item.col or 0),
        item.text or "",
      }, "¦")
      if not seen[key] then
        seen[key] = true
        table.insert(new, item)
      end
    end
    vim.fn.setqflist({}, "r", { title = list.title, items = new })
  end

  vim.fn.setqflist({}, "r") -- clear qf-list so it is empty
  vim.wait(2000, function()
    return #vim.fn.getqflist() > 0
  end, 50)
  dedupe(vim.fn.getqflist { items = 1, title = 1 })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    local map = vim.keymap.set

    if client and client:supports_method "textDocument/documentHighlight" then
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = vim.lsp.buf.document_highlight,
        buffer = args.buf,
        desc = "Show document highlight on cursor hold.",
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        callback = vim.lsp.buf.clear_references,
        buffer = args.buf,
        desc = "Clear highlights when the cursor moves.",
      })
    end
    if client and client:supports_method "callHierarchy/outgoingCalls" then
      map("n", "<leader>qo", function()
        vim.lsp.buf.outgoing_calls()
        dedupe_qflist()
      end, {
        buffer = bufnr,
        desc = "outgoing calls in quickfix list.",
        noremap = true,
        silent = true,
      })
    end

    if client and client:supports_method "callHierarchy/incomingCalls" then
      map("n", "<leader>qi", function()
        vim.lsp.buf.incoming_calls()
        dedupe_qflist()
      end, {
        buffer = bufnr,
        desc = "incoming calls in quickfix list.",
        noremap = true,
        silent = true,
      })
    end
    if client and client:supports_method "textDocument/references" then
      map("n", "<leader>qr", function()
        vim.lsp.buf.references()
      end, {
        buffer = bufnr,
        desc = "references in quickfix list.",
        noremap = true,
        silent = true,
      })
    end
  end,
})

local M = {}

-- -- mason PATH
-- local mason_path = vim.fn.stdpath "data" .. "/mason/packages"
--
-- -- nvim-dap
-- local bundles = {
--   -- this mason install is Version dependent!
--   vim.fn.glob(
--     mason_path
--       .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
--     1
--   ),
-- }
--
-- -- vscode test executions
-- local java_test_bundles = vim.split(
--   vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", 1),
--   "\n"
-- )
-- local excluded = {
--   "com.microsoft.java.test.runner-jar-with-dependencies.jar",
--   "jacocoagent.jar",
-- }
-- for _, java_test_jar in ipairs(java_test_bundles) do
--   local fname = vim.fn.fnamemodify(java_test_jar, ":t")
--   if not vim.tbl_contains(excluded, fname) then
--     table.insert(bundles, java_test_jar)
--   end
-- end

function M:setup()
  -- See `:help vim.lsp.start` for an overview of the supported `config` options.
  local config = {
    name = "jdtls",

    -- `cmd` defines the executable to launch eclipse.jdt.ls.
    -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
    --
    -- As alternative you could also avoid the `jdtls` wrapper and launch
    -- eclipse.jdt.ls via the `java` executable
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = { "jdtls" },

    -- `root_dir` must point to the root of your project.
    -- See `:help vim.fs.root`
    root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {},
    },

    -- This sets the `initializationOptions` sent to the language server
    -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
    -- you'll need to set the `bundles`
    --
    -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = {},
    },
  }

  -- print(vim.inspect(mason_path))
  require("jdtls").start_or_attach(config)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      -- Defer this slightly to make sure LSP applies its own highlights first
      vim.defer_fn(function()
        local highlights = {
          ["@lsp.type.enum"] = { link = "Type" },
          ["@lsp.type.function"] = { link = "@function" },
          ["@lsp.type.macro"] = { link = "@macro" },
          ["@lsp.type.method"] = { link = "@function.method" },
          ["@lsp.type.namespace"] = { link = "@module" },
          ["@lsp.type.parameter"] = { link = "@variable.parameter" },
          ["@lsp.type.property"] = { link = "@property" },
          ["@lsp.type.type"] = { link = "@type" },
          ["@lsp.type.typeParamater"] = { link = "TypeDef" },
          ["@lsp.type.variable"] = { link = "@variable" },
          ["@lsp.type.modifier"] = { link = "@keyword" },
        }

        for group, opts in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, opts)
        end
      end, 100) -- wait 100ms after attach
    end
  end,
})

return M

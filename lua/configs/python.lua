local M = {}

local function setup_dap()
  if vim.g.python_dap_setup_loaded then
    return
  end
  local mason_path = vim.fn.stdpath "data" .. "/mason/packages"
  vim.g.python_dap_setup_loaded = 1
  require("dap-python").setup(mason_path .. "/debugpy/venv/bin/python")
  -- should be unneded
  require("dap-python").test_runner = "pytest"
  -- Ui
  local dap = require "dap"

  table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Pytest: all tests",
    module = "pytest",
    args = {
      "-vv",
      "src/",
    },
    console = "integratedTerminal",
  })
end

function M:setup()
  -- virual text
  require("nvim-dap-virtual-text").setup {}
  -- local dap = require "dap"
  -- dap.listeners.before.launch.dapui_config = function()
  --   dap.repl.open()
  -- end
  -- mappings
  local map = vim.keymap.set
  map("n", "<localleader>dn", function()
    require("dap-python").test_method()
  end, { silent = true, buffer = true, desc = "dap-python test method" })

  map("n", "<localleader>df", function()
    require("dap-python").test_class()
  end, { silent = true, buffer = true, desc = "dap-python test class" })

  map("v", "<localleader>ds", function()
    require("dap-python").debug_selection()
  end, { silent = true, buffer = true, desc = "dap-python debug selection" })
  setup_dap()
end

return M

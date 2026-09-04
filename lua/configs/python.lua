local M = {}

local mason_path = vim.fn.stdpath "data" .. "/mason/packages"
function M:setup()
  -- base
  require("dap-python").setup(mason_path .. "/debugpy/venv/bin/python")
  -- tests
  -- should be unneded
  require("dap-python").test_runner = "pytest"
  -- Ui
  -- WARNING: currently broken in python
  -- require("dapui").setup {
  --   force_buffers = false,
  -- }
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
  -- virual text
  require("nvim-dap-virtual-text").setup()
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
end

return M

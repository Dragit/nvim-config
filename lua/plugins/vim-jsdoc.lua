return {
  {
    "heavenshell/vim-jsdoc",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    build = "make install",
    config = function()
      -- Enable ES6 support
      vim.g.jsdoc_enable_es6 = 1
      -- Optional: Enable input prompt for parameter types
      vim.g.jsdoc_allow_input_prompt = 1
    end,
  },
}

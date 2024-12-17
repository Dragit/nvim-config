return {
  {
    "heavenshell/vim-jsdoc",
    ft = { "javascript", "typescript" }, -- Load only for JavaScript/TypeScript
    config = function()
      -- -- Execute the Makefile's install target
      -- local make_install_status = vim.fn.system "make install"
      --
      -- if vim.v.shell_error ~= 0 then
      --   print("Error running 'make install of vim-jsdoc': " .. make_install_status)
      -- else
      --   print "Successfully ran 'make install of vim.jsdoc'."
      -- end
      -- Enable ES6 support
      vim.g.jsdoc_enable_es6 = 1
      -- Optional: Enable input prompt for parameter types
      vim.g.jsdoc_allow_input_prompt = 1
    end,
  },
}

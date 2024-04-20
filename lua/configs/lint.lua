require("lint").linter_by_ft = {
  markdown = { "markdownlint", "vale" },
  yaml = { "yamllint"},
}

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  callback = function ()
    require("lint").try_lint()
  end,
})

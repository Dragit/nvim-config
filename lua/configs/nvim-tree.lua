local conf = require "nvchad.configs.nvimtree"

conf.filters = {
  git_ignored = false,
  dotfiles = false,
}

require("nvim-tree").setup(conf)

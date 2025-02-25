vim.g.rainbow_delimiters = {
  query = {
    javascript = "rainbow-parens", -- Enable rainbow for JavaScript
    tsx = "rainbow-parens", -- Enable rainbow for TSX
    html = "", -- Disable for HTML
  },
}
-- get colors for rainbow-delimiters from syntax highlighing
-- local colors = dofile(vim.g.base46_cache .. "colors")
-- vim.cmd("highlight RainbowDelimiterRed guifg=" .. colors.red)
-- vim.cmd("highlight RainbowDelimiterYellow guifg=" .. colors.yellow)
-- vim.cmd("highlight RainbowDelimiterBlue guifg=" .. colors.blue)
-- vim.cmd("highlight RainbowDelimiterOrange guifg=" .. colors.orange)
-- vim.cmd("highlight RainbowDelimiterGreen guifg=" .. colors.green)
-- vim.cmd("highlight RainbowDelimiterViolet guifg=" .. colors.purple)
-- vim.cmd("highlight RainbowDelimiterCyan guifg=" .. colors.cyan)
--
local colors = {
  red = "#E03519",
  orange = "#FFAA9A",
  yellow = "#E3D95C",
  green = "#A8D93F",
  cyan = "#4DD6E1",
  blue = "#107AFF",
  magenta = "#D45D9A",
}

local catPuccinColors = {
  red = "##ed8796",
  orange = "#ef9f76",
  yellow = "#e5c890",
  green = "#a6d189",
  cyan = "#99d1db",
  blue = "#8caaee",
  purple = "#ca9ee6",
}

vim.cmd("highlight RainbowDelimiterRed guifg=" .. colors.red)
vim.cmd("highlight RainbowDelimiterYellow guifg=" .. catPuccinColors.yellow)
vim.cmd("highlight RainbowDelimiterBlue guifg=" .. catPuccinColors.blue)
vim.cmd("highlight RainbowDelimiterOrange guifg=" .. catPuccinColors.orange)
vim.cmd("highlight RainbowDelimiterGreen guifg=" .. catPuccinColors.green)
vim.cmd("highlight RainbowDelimiterViolet guifg=" .. colors.magenta)
vim.cmd("highlight RainbowDelimiterCyan guifg=" .. catPuccinColors.cyan)

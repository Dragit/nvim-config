vim.g.rainbow_delimiters = {
  submodules = false,
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
  red = "#Eb4934",
  orange = "#FFAA9A",
  yellow = "#E3D95C",
  green = "#A8D93F",
  cyan = "#4DD6E1",
  blue = "#107AFF",
  magenta = "#D45D9A",
}

local gruvBoxColors = {

  bright_red = "#fb4934",
  bright_green = "#b8bb26",
  bright_yellow = "#fabd2f",
  bright_blue = "#83a598",
  bright_purple = "#d3869b",
  bright_aqua = "#8ec07c",
  bright_orange = "#fe8019",

  neutral_red = "#cc241d",
  neutral_green = "#98971a",
  neutral_yellow = "#d79921",
  neutral_blue = "#458588",
  neutral_purple = "#b16286",
  neutral_aqua = "#689d6a",
  neutral_orange = "#d65d0e",

  faded_red = "#9d0006",
  faded_green = "#79740e",
  faded_yellow = "#b57614",
  faded_blue = "#076678",
  faded_purple = "#8f3f71",
  faded_aqua = "#427b58",
  faded_orange = "#af3a03",
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
vim.cmd("highlight RainbowDelimiterYellow guifg=" .. colors.yellow)
vim.cmd("highlight RainbowDelimiterBlue guifg=" .. catPuccinColors.blue)
vim.cmd(
  "highlight RainbowDelimiterOrange guifg=" .. gruvBoxColors.bright_orange
)
vim.cmd("highlight RainbowDelimiterGreen guifg=" .. catPuccinColors.green)
vim.cmd("highlight RainbowDelimiterViolet guifg=" .. colors.magenta)
vim.cmd("highlight RainbowDelimiterCyan guifg=" .. catPuccinColors.cyan)

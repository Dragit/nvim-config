return {
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      -- Load the theme colors
      local theme_colors = dofile(vim.g.base46_cache .. "colors")

      -- Return the opts table with dynamically resolved colors
      return {
        keywords = {
          TEST = {
            icon = "",
            color = "test",
            alt = { "TESTING", "PASSED", "FAILED" },
          },
        },
        colors = {
          error = {
            theme_colors.red or "#DC2626",
          },
          warning = {
            theme_colors.yellow or "#FBBF24",
          },
          info = { theme_colors.cyan or "#2563EB" },
          hint = { theme_colors.green or "#10B981" },
          default = { theme_colors.purple or "#7C3AED" },
          test = { theme_colors.pink or "#FF00FF" },
        },
        -- BUG:
        -- TEST:
        -- INFO:
        -- TODO:
        -- WARNING:
        -- PERFORMANCE:
      }
    end,
  },
}

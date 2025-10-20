return {
  "atiladefreitas/lazyclip",
  event = "VeryLazy",
  config = function()
    require("lazyclip").setup({
      history_size = 50, -- how many items to remember
      keymaps = {
        toggle = "<leader>p", -- open clipboard history
      },
    })
  end,
}


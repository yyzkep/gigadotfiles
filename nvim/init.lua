-- ~/.config/nvim/init.lua

-- Disable netrw (recommended for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP and Tools
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-path" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          highlight_opened_files = "all",
        },
        filters = {
          dotfiles = false,
        },
      })
      -- Keybind to toggle NvimTree
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
  { "nvim-lualine/lualine.nvim" },
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  {'vyfor/cord.nvim',
  	build = ':Cord update',
  	config = function()
    	require('cord').setup {}
  	end
  },
  { "saadparwaiz1/cmp_luasnip" },
 {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
 	require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang_format" },
    c = { "clang_format" },
  },
  formatters = {
    include_what_you_use = {
      command = "include-what-you-use",
      args = { "$FILENAME" },
      stdin = false,
    },
    clang_tidy = {
      command = "clang-tidy",
      args = { "$FILENAME", "--fix", "--warnings-as-errors=*", "--", "-std=c++20" },
      stdin = false,
      -- optional: print output in a split terminal
      run = function(_, ctx)
        vim.cmd("vsplit | terminal clang-tidy --fix " .. ctx.filename)
      end,
    },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
}) 
  end,
},
  { "mfussenegger/nvim-dap"},
  { "onsails/lspkind.nvim" },
  { "windwp/nvim-autopairs", config = true },
})

-- Load your custom LSP setup
require("lsp.setup")

require("lspconfig").clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    vim.diagnostic.config({ virtual_text = true })  -- show linting in real-time
  end,
})



-- Theme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- nvim-cmp setup
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),
})

-- Enable completion in command mode (:)
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})

vim.keymap.set("n", "<leader>F", function()
  require("conform").format({
    formatters = { "clang_format", "include_what_you_use", "clang_tidy" },
    async = true,
  })
end, { desc = "Format + IWYU + clang-tidy" })

-- Enable completion for search (/)
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

require('cord').setup {
  enabled = true,
  log_level = vim.log.levels.OFF,
  editor = {
    client = 'neovim',
    tooltip = 'The Superior IDE',
    icon = nil,
  },
  display = {
    theme = 'default',
    flavor = 'dark',
    view = 'full',
    swap_fields = false,
    swap_icons = false,
  },
  timestamp = {
    enabled = true,
    reset_on_idle = false,
    reset_on_change = false,
    shared = false,
  },
  idle = {
    enabled = true,
    timeout = 300000,
    show_status = true,
    ignore_focus = true,
    unidle_on_focus = true,
    smart_idle = true,
    details = 'Idling',
    state = nil,
    tooltip = '💤',
    icon = nil,
  },
  text = {
    default = nil,
    workspace = function(opts) return 'In ' .. opts.workspace end,
    viewing = function(opts) return 'Viewing ' .. opts.filename end,
    editing = function(opts) return 'Editing ' .. opts.filename end,
    file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
    plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
    lsp = function(opts) return 'Configuring LSP in ' .. opts.name end,
    docs = function(opts) return 'Reading ' .. opts.name end,
    vcs = function(opts) return 'Committing changes in ' .. opts.name end,
    notes = function(opts) return 'Taking notes in ' .. opts.name end,
    debug = function(opts) return 'Debugging in ' .. opts.name end,
    test = function(opts) return 'Testing in ' .. opts.name end,
    diagnostics = function(opts) return 'Fixing problems in ' .. opts.name end,
    games = function(opts) return 'Playing ' .. opts.name end,
    terminal = function(opts) return 'Running commands in ' .. opts.name end,
    dashboard = 'Home',
  }, 
  buttons = {
    {
      label = "Visit Website",
      url = "https://www.fakecrime.bio/define",
    },
  },
  assets = nil,
  variables = nil,
  hooks = {
    ready = nil,
    shutdown = nil,
    pre_activity = nil,
    post_activity = nil,
    idle_enter = nil,
    idle_leave = nil,
    workspace_change = nil,
    buf_enter = nil,
  },
  plugins = nil,
  advanced = {
    plugin = {
      autocmds = true,
      cursor_update = 'on_hold',
      match_in_mappings = true,
    },
    server = {
      update = 'fetch',
      pipe_path = nil,
      executable_path = nil,
      timeout = 300000,
    },
    discord = {
      pipe_paths = nil,
      reconnect = {
        enabled = false,
        interval = 5000,
        initial = true,
      },
    },
    workspace = {
      root_markers = {
        '.git',
        '.hg',
        '.svn',
      },
      limit_to_cwd = false,
    },
  },
}


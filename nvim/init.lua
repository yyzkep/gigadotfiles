-- ======== Plugin Manager Initialization ========
vim.cmd([[
call plug#begin('~/.local/share/nvim/plugged')

" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" File Explorer
Plug 'kyazdani42/nvim-tree.lua'

" Colorscheme
Plug 'ellisonleao/gruvbox.nvim'

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Formatting
Plug 'sbdchd/neoformat'

call plug#end()
]])

-- ======== Basic Settings ========
vim.o.syntax = 'enable'
vim.cmd('filetype plugin indent on')
vim.wo.number = true            -- Show line numbers
vim.wo.relativenumber = true    -- Show relative line numbers
vim.o.tabstop = 4               -- Number of spaces tabs count for
vim.o.shiftwidth = 4            -- Number of spaces to use for autoindent
vim.o.expandtab = true          -- Convert tabs to spaces
vim.o.clipboard = 'unnamedplus' -- Use system clipboard
vim.o.background = 'dark'

-- ======== Colorscheme ========
vim.cmd('colorscheme gruvbox')

-- ======== nvim-tree Configuration ========
require'nvim-tree'.setup {
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_netrw = true,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  view = {
    width = 30,
    side = 'left',
  },
  git = {
    enable = true,
    ignore = false,
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        item = "│ ",
        none = "  ",
      },
    },
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

-- Map leader key and nvim-tree toggle
vim.g.mapleader = ','
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap=true, silent=true })

-- ======== LSP Setup ========
local lspconfig = require('lspconfig')
local cmp_lsp = require('cmp_nvim_lsp')

local on_attach = function(client, bufnr)
  -- Custom on_attach code, e.g. keymaps, can go here
end

local capabilities = cmp_lsp.default_capabilities()

lspconfig.pyright.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ======== nvim-cmp Setup ========
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For LuaSnip users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {'i','s'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i','s'}),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for '/' and '?' in commandline mode
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' commands
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- ======== Treesitter Configuration ========
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "python", "javascript", "typescript", "html", "css" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- ======== Neoformat Configuration ========
vim.cmd([[
  autocmd BufWritePre * undojoin | Neoformat
]])

-- ======== Additional Keybindings ========
vim.api.nvim_set_keymap('n', '<leader>f', ':Neoformat<CR>', { noremap=true, silent=true })

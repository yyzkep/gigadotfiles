-- ~/.config/nvim/lua/lsp/setup.lua
local lspconfig = require("lspconfig")
local cmp = require("cmp")

-- Setup autocompletion
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),
})

-- Setup mason to manage servers
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
  automatic_installation = true,
})

-- Configure clangd
lspconfig.clangd.setup({
  cmd = { "clangd" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})


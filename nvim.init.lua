vim.cmd [[
call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'preservim/nerdtree'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
  Plug 'neovim/nvim-lspconfig'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'Exafunction/windsurf.vim', { 'branch': 'main' }

  Plug 'nvimtools/none-ls.nvim'
  Plug 'nvim-lua/plenary.nvim'  

  Plug 'numToStr/Comment.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


  call plug#end()
]]

-- Set leader key
vim.g.mapleader = " "

-- Key mappings (NERDTree)
vim.keymap.set('n', '<leader>n', ':NERDTreeFocus<CR>', { noremap = true })
vim.keymap.set('n', '<C-n>', ':NERDTree<CR>', { noremap = true })
vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>', { noremap = true })

-- Colorscheme
vim.cmd('colorscheme retrobox')

-- Move between panes
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })

-- Telescope key mappings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {})
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {})
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {})

-- LSP key mappings
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP Rename" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic message" })



-- Show line numbers
vim.opt.number = true

require('lspconfig').pyright.setup{}
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' }
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})

local lspconfig = require("lspconfig")

-- Use tsserver (typescript-language-server) for TypeScript & JavaScript
lspconfig.tsserver.setup({
  on_attach = function(client, bufnr)
    -- Disable tsserver formatting if you're using prettier or something else
    client.server_capabilities.documentFormattingProvider = false

    -- Example keybindings for LSP navigation
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
})

vim.keymap.set('n', 'gd', function()
  vim.lsp.buf.definition()
end, { noremap=true, silent=true })



local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    -- You can add more like:
    -- null_ls.builtins.formatting.black, -- Python
    -- null_ls.builtins.formatting.stylua, -- Lua
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
vim.g.skip_ts_context_commentstring_module = true

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "javascript", "typescript", "tsx", "lua", "json", "html", "css"
  },
  highlight = { enable = true },
}

-- Context-aware commenting
require('ts_context_commentstring').setup {}

require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}


vim.keymap.set("v", "<leader>ai", function()
  require("codeium").chat.ask()
end, { desc = "Ask Codeium about selection" })

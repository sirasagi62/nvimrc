-- config for Japanese encodings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = {"utf-8","cp-932","euc-jp"}

-- show inputting command
vim.opt.showcmd = true

-- set backspace config better
vim.opt.backspace = {"eol","indent","start"}

-- scrolling config better
vim.opt.scrolloff = 5

-- default configulation for tab and newline
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- set norelativenumber in insert mode, otherwise relativenumber
vim.opt.number = true

vim.api.nvim_create_augroup( 'numbertoggle', {} )
vim.api.nvim_create_autocmd( {'BufEnter','InsertLeave'}, {
  group = 'numbertoggle',
  callback = function() vim.opt.relativenumber = true end
})

vim.api.nvim_create_autocmd( {'BufLeave','InsertEnter'}, {
  group = 'numbertoggle',
  callback = function() vim.opt.relativenumber = false end
})

-- loading plugins
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
  {'tani/vim-jetpack'},

  -- colorshceme
  {'folke/tokyonight.nvim'},

  -- status line plugins
  {'nvim-lualine/lualine.nvim'},
  {'nvim-tree/nvim-web-devicons'},

  -- plugins for text editing
  {'terryma/vim-expand-region'},
  {'kylechui/nvim-surround'}, -- re-implamantation of vim-surround by tpope in neovim with lua
  {'lukas-reineke/indent-blankline.nvim'}, -- show indent

  -- plugins for git
  {'tpope/vim-fugitive'},
  {'rbong/vim-flog'},

  -- plugins for debug
  {'mfussenegger/nvim-dap'},
  {'rcarriga/nvim-dap-ui'},
  {'leoluz/nvim-dap-go'},
  {'theHamsta/nvim-dap-virtual-text'},

  -- plugins for syntax highlight
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  },

  -- plugins for completation{'neovim/nvim-lspconfig'},
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},

  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/cmp-cmdline'},
  {'hrsh7th/nvim-cmp'},

  -- snippets plugins
  {'hrsh7th/cmp-vsnip'},
  {'hrsh7th/vim-vsnip'},

  -- plugins for diagnostics, fomatting, etc...
  {"jose-elias-alvarez/null-ls.nvim"},

  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    requires = { {'nvim-lua/plenary.nvim'} }
  },

  -- other plugins to help my neovim life!
  -- show floating window which gives key mapping hint
  {'linty-org/key-menu.nvim'},
  -- add submode in neovim (inspired by kana/vim-submode)
  {'Dkendal/nvim-minor-mode'},
}

-- setting for colorscheme
vim.opt.cursorline = true -- show cursorline
vim.cmd[[colorscheme tokyonight]]

-- before customize plugins configs

-- customize key mappings and some extra helpful configs!
-- set leader to <space>
vim.g.mapleader = " "

-- config of key-manu.nvim
vim.o.timeoutlen = 300

-- popup key-mapping hint with leader key
require 'key-menu'.set('n', '<Leader>')
require 'key-menu'.set('n', '<Leader>t', {desc='Go to ...'})


-- setting for lsp server
-- init mason
require("mason").setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- -- Function executed when the LSP server startup
    -- on_attach = function(client, bufnr)
    --   local opts = { noremap=true, silent=true }
    --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
    -- end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)
end })

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', '<Leader>h',  '<cmd>lua vim.lsp.buf.hover()<CR>', {desc='Show more info'})
vim.keymap.set('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', {desc='Format'})
vim.keymap.set('n', '<Leader>tr', '<cmd>lua vim.lsp.buf.references()<CR>', {desc = 'References'})
vim.keymap.set('n', '<Leader>td', '<cmd>lua vim.lsp.buf.definition()<CR>', {desc = 'Definitions'})
vim.keymap.set('n', '<Leader>tD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {desc = 'Declarations'})
vim.keymap.set('n', '<Leader>ti', '<cmd>lua vim.lsp.buf.implementation()<CR>', {desc = 'Implemantations'})
vim.keymap.set('n', '<Leader>tt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {desc = 'Type defs...'})
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>',{desc = 'Actions..'})
vim.keymap.set('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', {desc = 'Show diag..'})
vim.keymap.set('n', '<Leader>n', '<cmd>lua vim.diagnostic.goto_next()<CR>', {desc = 'Next diag..'})
vim.keymap.set('n', '<Leader>N', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {desc='Prev diag..'})
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)
-- Reference highlight
vim.cmd [[
set updatetime=500
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ['<C-o>'] = cmp.mapping.complete(),
    ['<C-q>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})

-- setting for showing indent
require("indent_blankline").setup()

-- config for lualine
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

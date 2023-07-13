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
  {'kylechui/nvim-surround'},
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
}

-- setting for colorscheme
vim.opt.cursorline = true -- show cursorline
vim.cmd[[colorscheme tokyonight]]

-- setting for completation
-- init mason
require("mason").setup()

-- setting for showing indent
require("indent_blankline").setup() 


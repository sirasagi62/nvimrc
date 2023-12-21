-- Environment
-- Ubuntu 20.04 on WSL2 with Windows Terminal
-- Or 
-- iTerm on mac OS
-- TerminalTheme: tokyonight
-- Font: Caskaydia Cove Nerd Font 10pt
-- Depends on lazygit,ripgrep,git-graph commands

-- config for Japanese encodings
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = {'utf-8','cp-932','euc-jp'}

-- show inputting command
vim.opt.showcmd = true

-- set backspace config better
vim.opt.backspace = {'eol','indent','start'}

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
  -- add color preview
  {'brenoprata10/nvim-highlight-colors'},
  -- status line plugins
  {'nvim-lualine/lualine.nvim'},
  {'nvim-tree/nvim-web-devicons'},

  -- make gutter fancy
  {'folke/trouble.nvim'},

  -- plugins for moving cursor
  {'terryma/vim-expand-region'},
  {'ggandor/leap.nvim'},
  {'atusy/leap-search.nvim'},

  -- plugins for text editing
  {'kylechui/nvim-surround'}, -- re-implamantation of vim-surround by tpope in neovim with lua
  {'lukas-reineke/indent-blankline.nvim'}, -- show indent
  {'cohama/lexima.vim'},
  {'tpope/vim-commentary'}, -- comment toggle
  {'nmac427/guess-indent.nvim'}, -- insert indent wisely

  -- plugins for git
  {'tpope/vim-fugitive'},
  {'rbong/vim-flog'},
  {'rhysd/git-messenger.vim'},

  -- make terminal better
  {'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup()
  end},

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
  {'mhartington/formatter.nvim'},
  {'mfussenegger/nvim-lint'},

  -- for golang
  {'fatih/vim-go',ft='go'},

  -- fuzzy finder
  {

    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    requires = { {'nvim-lua/plenary.nvim'} }
  },
  {'LukasPietzschmann/telescope-tabs'},
  {'kyoh86/telescope-windows.nvim'},

  -- filer
  {'lambdalisue/fern.vim'},

  -- other plugins to help my neovim life!
  -- show floating window which gives key mapping hint
  {'linty-org/key-menu.nvim'},

  -- add submode in neovim
  {'anuvyklack/hydra.nvim'},

  -- make folding far more better :D
  {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'},

  -- quickrun
  {'is0n/jaq-nvim'},
  -- scratchpad
  {'metakirby5/codi.vim'},

  -- for development
  {'~/project/nvim-submode'},
}

-- setting for colorscheme
vim.opt.cursorline = true -- show cursorline
vim.cmd[[colorscheme tokyonight]]

-- setting for brenoprata10/nvim-highlight-colors
require('nvim-highlight-colors').setup {}
-- before customize plugins configs

-- customize key mappings and some extra helpful configs!
-- set leader to <space>
vim.g.mapleader = ' '

-- config of key-manu.nvim
vim.o.timeoutlen = 300

-- popup key-mapping hint with leader key
require 'key-menu'.set('n', '<Leader>')
require 'key-menu'.set('n', '<Leader>g', {desc='Git'})
require 'key-menu'.set('n', '<Leader>l', {desc='LSP'})
require 'key-menu'.set('n', '<Leader>lt', {desc='Go to'})
require 'key-menu'.set('n', '<Leader>t', {desc='Telescope'})

-- settings for vim-expand-region
vim.keymap.set('v','v','<Plug>(expand_region_expand)')
vim.keymap.set('v','V','<Plug>(expand_region_shrink)')

-- settings for nvim-surround
require('nvim-surround').setup()

-- setting for lsp server
-- init mason
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)
end })

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', '<Leader>lh',  '<cmd>lua vim.lsp.buf.hover()<CR>', {desc='Show more info'})
vim.keymap.set('n', '<Leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {desc='Format'})
vim.keymap.set('n', '<Leader>ltr', '<cmd>lua vim.lsp.buf.references()<CR>', {desc = 'References'})
vim.keymap.set('n', '<Leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {desc = 'Definitions'})
vim.keymap.set('n', '<Leader>ltD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {desc = 'Declarations'})
vim.keymap.set('n', '<Leader>lti', '<cmd>lua vim.lsp.buf.implementation()<CR>', {desc = 'Implemantations'})
vim.keymap.set('n', '<Leader>ltt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {desc = 'Type defs...'})
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>',{desc = 'Actions..'})
vim.keymap.set('n', 'e', '<cmd>lua vim.diagnostic.goto_next()<CR>', {desc = 'Next diag..'})
vim.keymap.set('n', 'E', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {desc='Prev diag..'})
-- LSP handlers
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
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

-- make sign fancy
vim.cmd [[
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
]]
-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }, mapping = cmp.mapping.preset.insert({
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-o>'] = cmp.mapping.complete(),
    ['<C-q>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  }),
  experimental = { ghost_text = true,
  },
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  },
})

-- setting for showing indent
-- require('indent_blankline').setup()
require("ibl").setup()

-- setting for nvim-ufo, a folding plugin
-- from README example
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
require 'key-menu'.set('n', '<Leader>z', {desc='Folding'})
vim.keymap.set('n', '<leader>zR', require('ufo').openAllFolds, {desc='Unfold all blocks'})
vim.keymap.set('n', '<leader>zM', require('ufo').closeAllFolds,{desc='Fold all blocks'})
vim.keymap.set('n','<leader>z+','za',{desc='Toggle fold'})

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
        -- you can add other fields for setting up lsp server in this table
    })
end
require('ufo').setup()

-- First, load your favorite colorshceme
local colors = require('tokyonight.colors').setup()
local get_mode = require('lualine.utils.mode').get_mode

local hydra_color = {
  Git = colors.orange,
  Window = colors.red,
}
local active_hydra = {
  name = nil,
  color = nil,
}

-- setting for vim-commentary
vim.keymap.set('n', '<C-/>', 'gcc', {desc = 'Toggle comment'})

-- setting for guess-indent
require('guess-indent').setup {}

-- setting for leap
require('leap').add_default_mappings()

-- setting for hydra & nvim-submode
local function set_hydra(name,color)
  active_hydra.name=name
  active_hydra.color=color
end

local function get_hydra_name()
  return active_hydra.name
end

local function get_hydra_color()
  return active_hydra.color
end

local function remove_active_hydra()
  set_hydra(nil,nil)
end

package.loaded['nvim-submode'] = nil
local sm = require('nvim-submode')
local function submodeNameLualine()
  return get_hydra_name() or ' '
end

local function modeNameLualine()
  return sm.getState().submode_display_name or get_mode()
end

local function submodeNameLualineWithBaseMode()
  local submode = get_hydra_name()
  if submode then
    return submode..'('..get_mode()..')'
  else
    return get_mode()
  end
end

local function hydraLualineColor()
  return get_hydra_color() and {bg = get_hydra_color()} or nil
end

local function submodeLualineColor()
  local color = sm.getState().submode_color
  return color and {bg=color} or nil
end

local cascade_component = {
  'mode',
  {
    submodeNameLualine,
    cond = function ()
      return submodeNameLualine()~=' '
    end
  },
}

local colored_component = {
  {
    -- modeNameLualine,
    modeNameLualine,
    color=submodeLualineColor,
    separator = {left='',right=''},
  }
}

-- config for lualine
local lualine = require('lualine')
lualine.setup {
  options = {
    globalstatus = true,
    theme = 'tokyonight',
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = colored_component,
  }
}

local Hydra = require('hydra')
local window_mode_hint = [[
󰁣| + 󰜷| h
󰁋| - 󰜮| j
󰁓| < 󰜱| k
󰁚| > 󰜴| l
]]

--[[Hydra({
   name = 'Window',
   mode = 'n',
   body = '<leader>w',
   config = {
    color='pink',
    on_enter = function ()
      set_hydra('Window',colors.red)
      print('Enter Window Hydra')
      lualine.refresh()
    end,
    on_exit = function ()
      remove_active_hydra()
      lualine.refresh()
    end
   },
   heads = {
      { '+', '<C-W>+' },
      { '-', '<C-W>-' },
      { '<', '<C-W><' },
      { '>', '<C-W>>' },
      { 'h', '<C-W>h' },
      { 'j', '<C-W>j'},
      { 'k', '<C-W>k' },
      { 'l', '<C-W>l' },
   }
})]]

local testmode = {
  -- enable to print debug information
  debug = true,
  -- set duration to wait key input
  --timeoutlen = 1000,
  
  -- set minimum duration between each loop
  -- in order to execute vim functions by proper order.
  -- you should change this property unless you know what you are doing.
  min_cycle_duration = 0,

  lualine = true,
  -- you can set any key except <Esc> as interrupt_key to interrupt waiting key input
  interrupt_key = '<CR>',
  -- mode name that set inner
  mode_name='test',
  mode_color = colors.orange,
  -- if true, submode collect input numbers to number_list
  number_input = true,
  -- if true, submode automatically repeat keymap action number_list[1] times
  number_modify = true,
  mode_display_name=' TEST ',
  keymaps = {
    {
      map='<C-H><C-W>',
      action=function ()
        print('Ctrl-H,Ctrl-W')
      end
    },
    {
      map='<C-H><C-W>i',
      action=function ()
        print('Ctrl-H,Ctrl-W,i')
      end
    },
  },
  default = function (prefix,c,number_list)
    print('default:'..prefix..c)
    --vim.fn.execute('normal a'..prefix..c)
    --vim.fn.execute('normal '..c)
    --vim.api.nvim_input('<C-W>>')
    local key = vim.api.nvim_replace_termcodes(':vertical resize +1<CR>',true,false,true)
    vim.api.nvim_feedkeys(key,'x',false)
    --vim.cmd('vertical resize +1')
    --[[vim.schedule(function ()
      vim.fn.execute('normal j')
    end)]]
  end,
  afterEnter = function ()
    print('Enter test submode.')
  end,
  beforeLeave = function ()
    print('Will Leave Submode!')
  end,
}

local window_submode = {
  lualine = true,
  mode_name='Window',
  mode_color = colors.red,
  number_input = true,
  number_modify = true,
  mode_display_name='WINDOW',
  keymaps = {
    {
      map='>',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
        map='<lt>',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W><',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='+',
      action=function ()
        local key = vim.api.nvim_replace_termcodes(':resize +1<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='-',
      action=function ()
        local key = vim.api.nvim_replace_termcodes(':resize -1<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='h',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>h',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='j',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>j',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='k',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>k',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='l',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>l',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
     {
      map='t',
      action=function ()
        local key = vim.api.nvim_replace_termcodes(':tabn<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='T',
      action=function ()
        local key = vim.api.nvim_replace_termcodes(':tabN<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='w',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>w',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='W',
      action=function ()
        local key = vim.api.nvim_replace_termcodes('<C-W>W',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
      end
    },
    {
      map='b',
      action=function ()
        local key = vim.api.nvim_replace_termcodes(':Telescope buffers<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
        sm.exitSubmode()
      end
    },
    {
      map='nn',
      action = function ()
        local key = vim.api.nvim_replace_termcodes(':vnew<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
        sm.exitSubmode()
      end
    },
    {
      map='nh',
      action = function ()
        local key = vim.api.nvim_replace_termcodes(':new<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
        sm.exitSubmode()
      end
    },
    {
      map='nt',
      action = function ()
        local key = vim.api.nvim_replace_termcodes(':tabnew<CR>',true,false,true)
        vim.api.nvim_feedkeys(key,'x',false)
        sm.exitSubmode()
      end
    },
  },
  default = function () end,
}

local submode = require('nvim-submode')
vim.keymap.set('n','<leader>w',function ()
  submode.enterSubmode(window_submode)
end, {desc='Window Mode'})

-- config for lazygit
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true ,direction = 'float',dir = vim.fn.getcwd()})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>lua _lazygit_toggle()<CR>', {noremap = true, silent = true, desc = 'Open LazyGit'})
vim.api.nvim_set_keymap('n', '<leader>gf', '<cmd>Flog<CR>', {noremap = true, silent = true, desc = 'Flog Graph'})
-- config for Telescope
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
          -- ["<CR>"] = "select_tab"
      }
    }
  },
  pickers = {
    -- open the file in new tab if enter key pressed in find_files and live_grep. 
    find_files = {
      mappings = {
        i = {
          ["<CR>"] = "select_tab"
        }
      }
    },
    live_grep = {
      mappings = {
        i = {
          ["<CR>"] = "select_tab"
        }
      }
    },
  },
  extensions = {
  }
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>to', builtin.find_files, {desc='Open File...'})
vim.keymap.set('n', '<Leader>f', builtin.live_grep, {desc='Grep'})
vim.keymap.set('n', '<Leader>b', require("telescope").extensions.windows.list, {desc='Windows and Tab'})

-- Diagnostics Submode
vim.keymap.set('n','<leader>te',function ()
  builtin.diagnostics()
end, {desc='Diagnostics List'})

---- show diagnostic if cursor hold
local function on_cursor_hold()
  if vim.lsp.buf.server_ready() then
    vim.diagnostic.open_float()
  end
end

local diagnostic_hover_augroup_name = "lspconfig-diagnostic"
vim.api.nvim_set_option('updatetime', 500)
vim.api.nvim_create_augroup(diagnostic_hover_augroup_name, { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, { group = diagnostic_hover_augroup_name, callback = on_cursor_hold })

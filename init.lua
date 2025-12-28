-- Environment
-- Ubuntu 20.04 on WSL2 with Windows Terminal
-- Or
-- iTerm on mac OS
-- TerminalTheme: tokyonight
-- Font: Caskaydia Cove Nerd Font 10pt
-- Depends on lazygit,ripgrep,git-graph commands

-- config for Japanese encodings



-- customize key mappings and some extra helpful configs!
-- set leader to <space>
vim.g.mapleader = ' '
--vim.api.nvim_set_var('mapleader', ' ')
-- config of key-manu.nvim
vim.o.timeoutlen = 300
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8', 'cp-932', 'euc-jp' }

-- show inputting command
vim.opt.showcmd = true

-- set backspace config better
vim.opt.backspace = { 'eol', 'indent', 'start' }

-- scrolling config better
vim.opt.scrolloff = 5

-- default configulation for tab and newline
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.iskeyword:append "-"


-- set norelativenumber in insert mode, otherwise relativenumber
vim.opt.number = true

vim.api.nvim_create_augroup('numbertoggle', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
  group = 'numbertoggle',
  callback = function()
    if vim.bo.buftype == '' then
      vim.opt.relativenumber = true
    end
  end
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'InsertEnter' }, {
  group = 'numbertoggle',
  callback = function()
    if vim.bo.buftype == '' then
      vim.opt.relativenumber = false
    end
  end
})

is_fern_enable = nil
fern_statusline_color = nil

-- Automatic vim-jetpack install
local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackpluginfolder = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/'
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end

-- loading plugins
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
  { 'tani/vim-jetpack' },

  -- colorshceme
  { 'folke/tokyonight.nvim' },
  -- add color preview
  { 'brenoprata10/nvim-highlight-colors' },
  -- status line plugins
  { 'nvim-lualine/lualine.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'nvim-mini/mini.tabline',
    requires = {
      'nvim-mini/mini.icons'
    },
    config = function()
      require("mini.tabline").setup({
        show_icons = true
      })
    end
  },

  -- make gutter fancy
  { 'folke/trouble.nvim' },

  -- plugins for moving cursor
  { 'terryma/vim-expand-region' },
  { 'smoka7/hop.nvim' },

  -- plugins for text editing
  { 'kylechui/nvim-surround' },              -- re-implamantation of vim-surround by tpope in neovim with lua
  { 'lukas-reineke/indent-blankline.nvim' }, -- show indent
  { 'cohama/lexima.vim' },
  { 'tpope/vim-commentary' },                -- comment toggle
  { 'nmac427/guess-indent.nvim', config = function()
    require('guess-indent').setup {}
  end }, -- insert indent wisely

  -- text objects(textobj)

  { 'wellle/targets.vim' },
  { 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-line' },
  { 'kana/vim-textobj-entire' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'ntpeters/vim-better-whitespace' }, -- trailing space by cmd

  -- plugins for git
  { 'tpope/vim-fugitive' },
  { 'rbong/vim-flog' },
  { 'rhysd/git-messenger.vim' },
  { 'nvim-mini/mini.diff',
    config = function()
      require('mini.diff').setup()
    end
  },

  -- make terminal better
  { 'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup()
    end },

  -- plugins for debug
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  { 'leoluz/nvim-dap-go' },
  { 'theHamsta/nvim-dap-virtual-text' },

  -- plugins for syntax highlight
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          'python',
          'lua',
          'javascript',
          'typescript',
          'tsx',
          'cpp',
          'go',
          'templ',
        },
        highlight = {
          enable = true
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            }
          }
        }
      })
    end
  },

  -- plugins for completation{'neovim/nvim-lspconfig'},
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/nvim-cmp' },

  -- snippets plugins
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/vim-vsnip' },

  -- plugins for diagnostics, formatting, etc...
  --{ 'mhartington/formatter.nvim' },
  --{ 'mfussenegger/nvim-lint' },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require('tiny-inline-diagnostic').setup({
        options = {
          show_source = {
            enabled = true,
            -- Show source only when multiple sources exist for the same diagnostic
            if_many = true,
          },
          use_icons_from_diagnostic = true,
        }
      })
      vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
    end
  },
  { 'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({
        ui = {
          code_action = ''
        },
        lightbulb = {
          enable = true,
          sign = false,
          virtual_text = true,
        },
      })
    end
  },
  { 'dnlhc/glance.nvim',
    config = function()
      require('glance').setup()
    end
  },


  -- for golang
  { 'fatih/vim-go',            ft = 'go' },

  -- for zig
  { 'ziglang/zig.vim',         ft = 'zig' },

  -- for web
  { 'windwp/nvim-ts-autotag' },
  { 'napmn/react-extract.nvim' },

  -- for typescript
  {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },

  -- fuzzy finder
  {

    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  },
  { 'LukasPietzschmann/telescope-tabs' },
  { 'kyoh86/telescope-windows.nvim' },

  -- filer
  { 'lambdalisue/fern.vim',
    requires = {
      { 'lambdalisue/vim-glyph-palette' },
      { 'TheLeoP/fern-renderer-web-devicons.nvim' },
      { 'lambdalisue/vim-fern-git-status' },
      { 'sirasagi62/toggle-cheatsheet.nvim' },
      { 'yuki-yano/fern-preview.vim' }
    },
    config = function()
      local colors = require('tokyonight.colors').setup()

      vim.g['fern#renderer'] = 'nvim-web-devicons'
      vim.g["glyph_palette#palette"] = require 'fr-web-icons'.palette()
      vim.g['fern#hide_cursor'] = true
      vim.g['fern#default_hidden'] = true
      vim.g['should_reload_fern'] = false



      vim.keymap.set("n", ">", "<C-W>l")
      vim.keymap.set("n", "<", "<C-W>h")

      local vimL_func_definition = [[
        " VimlL関数を定義
        " return の結果をLua側で受け取る
        function! GetFernCursorPathInline() abort
          let helper = fern#helper#new()
          let node = helper.sync.get_cursor_node()
          return node
        endfunction
      ]]
      vim.api.nvim_exec2(vimL_func_definition, {
        output = false
      })
      -- autocmd to enter fern
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'fern',
        callback = function(args)
          vim.fn['glyph_palette#apply']()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.signcolumn = 'no'
          vim.opt_local.foldcolumn = "0"
          -- 別のバッファに切り替えない
          vim.opt_local.winfixbuf = true
          local toggle_help = function()
            local tcs = require('toggle-cheatsheet').setup(true)
            local raw_help = vim.fn['fern#action#list']()
            local help = {}
            for _, h in ipairs(raw_help) do
              if type(h[1]) == "string" and h[1] ~= "" and h[1]:match("<Plug>") == nil then
                table.insert(help, h)
              end
            end
            local cs = tcs.createCheatSheetFromSubmodeKeymap(
              tcs.conf(help)
            )
            tcs.toggle(cs)
          end
          vim.keymap.set('n', 'p', '<Plug>(fern-action-preview:auto:toggle)', { buffer = true })
          vim.keymap.set('n', '??', toggle_help, { buffer = true, remap = true })
          vim.keymap.set('n', 'l', '<Plug>(fern-action-open-or-expand)', { buffer = true })
          vim.keymap.set('n', '<Enter>', '<Plug>(fern-action-open-or-expand)', { buffer = true })
          vim.keymap.set('n', '<left>', '<Plug>(fern-action-collapse)', { buffer = true })
          vim.keymap.set('n', '<right>', '<Plug>(fern-action-open-or-expand)', { buffer = true })
          vim.keymap.set('n', 'O', function()
            local cursor_path = vim.fn["GetFernCursorPathInline"]()["_path"]
            cursor_path = vim.fs.dirname(vim.fn.fnamemodify(cursor_path, ':p'))
            vim.g['should_reload_fern'] = true
            vim.cmd([[Oil --float ]] .. cursor_path)
          end, { buffer = true })
        end
      })
      vim.api.nvim_create_augroup('FernMyConf', {})

      local ns = vim.api.nvim_create_namespace("fern-colors")
      local dark_colors = {
        blue = "#6180d5",
        blue_dark = "#3d517d",
        fg = colors.fg_dark,
        bg = "#141621"
      }
      local light_colors = {
        bg = "#212640",
        blue = "#9ebbf7"
      }
      vim.api.nvim_create_autocmd('BufEnter', {
        group = 'FernMyConf',
        callback = function(args)
          if vim.bo.filetype == "fern" then
            vim.api.nvim_win_set_hl_ns(0, ns)
            vim.api.nvim_set_hl(ns, 'FernRootSymbol', { fg = colors.yellow })
            vim.api.nvim_set_hl(ns, 'FernRootText', { fg = colors.yellow })
            vim.api.nvim_set_hl(ns, 'FernBranchSymbol', { link = 'Directory' })
            vim.api.nvim_set_hl(ns, 'FernBranchText', { link = 'Directory' })
            vim.api.nvim_set_hl(ns, 'FernLeafText', { fg = colors.fg })
            vim.api.nvim_set_hl(ns, 'Normal', {
              bg = light_colors.bg,
            })
            vim.api.nvim_set_hl(ns, 'EndOfBuffer', {
              bg = light_colors.bg,
              fg = light_colors.bg
            })
            vim.api.nvim_set_hl(ns, 'CursorLine', {
              fg = colors.fg,
              -- bg = colors.blue,
              bg = dark_colors.blue_dark,
            })
            is_fern_enable = "NORMAL(VIM-FERN)"
            fern_statusline_color = light_colors.blue
            require("lualine").refresh()
            if vim.g["should_reload_fern"] then
              vim.g["should_reload_fern"] = false
              vim.api.nvim_input("<F5>")
            end
          end
        end
      })
      vim.api.nvim_create_autocmd('BufLeave', {
        group = 'FernMyConf',
        callback = function(args)
          if vim.bo.filetype == "fern" then
            vim.api.nvim_set_hl(ns, 'FernRootSymbol', { fg = colors.fg_dark })
            vim.api.nvim_set_hl(ns, 'FernRootText', { fg = colors.fg_dark })
            vim.api.nvim_set_hl(ns, 'FernBranchSymbol', { fg = dark_colors.blue })
            vim.api.nvim_set_hl(ns, 'FernBranchText', { fg = dark_colors.blue })
            vim.api.nvim_set_hl(ns, 'FernLeafText', { fg = dark_colors.fg })
            vim.api.nvim_win_set_hl_ns(0, ns)
            vim.api.nvim_set_hl(ns, 'Normal', {
              bg = dark_colors.bg,
            })
            vim.api.nvim_set_hl(ns, 'EndOfBuffer', {
              bg = dark_colors.bg,
              fg = dark_colors.bg
            })
            vim.api.nvim_set_hl(ns, 'CursorLine', {
              bg = colors.comment,
              fg = colors.fg
            })
            is_fern_enable = nil
            fern_statusline_color = nil
            require("lualine").refresh()
            require("toggle-cheatsheet").closeCheatSheetWin()
          end
        end
      })

      vim.api.nvim_create_autocmd('BufRead', {
        group = 'FernMyConf',
        nested = true,
        callback = function()
          if vim.bo.filetype ~= "fern" and vim.bo.buftype == "" then
            vim.cmd [[Fern . -reveal=% -drawer -stay]]
          end
        end
      })

      vim.api.nvim_create_autocmd('User', {
        group = 'FernMyConf',
        pattern = "FernHighlight",
        callback = function()
          vim.api.nvim_win_set_hl_ns(0, ns)
          vim.api.nvim_set_hl(ns, 'CursorLine', {
            fg = colors.fg,
            -- bg = colors.blue,
            bg = dark_colors.blue_dark,
          })
          vim.api.nvim_set_hl(ns, 'FernBranchSymbol', { link = 'Directory' })
          vim.api.nvim_set_hl(ns, 'FernBranchText', { link = 'Directory' })
          vim.api.nvim_set_hl(ns, 'FernRootSymbol', { fg = colors.fg_dark })
          vim.api.nvim_set_hl(ns, 'FernRootText', { fg = colors.fg_dark })
        end
      })

      vim.api.nvim_create_autocmd('VimEnter', {
        group = 'FernMyConf',
        nested = true,
        callback = function(args)
          if vim.fn.argc() > 0 then
            vim.cmd [[Fern . -reveal=% -drawer -toggle -stay]]
          else
            vim.cmd [[Fern . -reveal=% -drawer -toggle]]
          end
        end
      })
    end
  },

  { 'stevearc/oil.nvim',
    config = function()
      require("oil").setup({
        float = {
          max_height = 0.6,
          max_width = 0.6,
          border = "rounded",
        },
        keymaps = {
          ["q"] = ":q<CR>"
        },
      })
    end
  },

  -- other plugins to help my neovim life!
  -- show key mapping hint on a floating window near the cursor
  -- { 'linty-org/key-menu.nvim' },
  { 'emmanueltouzery/key-menu.nvim' },

  -- make notify fancy
  { 'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end
  },

  -- make markdown fancy
  { 'MeanderingProgrammer/render-markdown.nvim',
    requires = {
      'https://github.com/nvim-treesitter/nvim-treesitter',
      'https://github.com/nvim-tree/nvim-web-devicons'
    },
    config = function()
      require('render-markdown').setup({})
    end
  },
  -- automatically resize focused window
  { 'anuvyklack/windows.nvim',
    requires = 'anuvyklack/middleclass'
  },

  -- add submode in neovim
  { 'anuvyklack/hydra.nvim' },

  -- make folding far more better :D
  { 'kevinhwang91/nvim-ufo',            requires = 'kevinhwang91/promise-async' },

  -- quickrun
  { 'is0n/jaq-nvim' },
  -- scratchpad
  { 'metakirby5/codi.vim' },
  -- Convert markdown to vimdoc
  { 'OXY2DEV/markdoc.nvim' },
  --key logs for recording video
  { '4513ECHO/nvim-keycastr' },
  -- make swap file better
  { 'chrisbra/Recover.vim' },
  -- kazhala/close-buffers.nvim
  { 'kazhala/close-buffers.nvim' },

  { 'tokinasin/reversi.vim' },
  -- testing
  { 'thinca/vim-themis' },
  -- for development
  -- { '~/project/submode' },
  { 'sirasagi62/nvim-submode' },
  { 'sirasagi62/nvim-lcl-lisp-runner' },
  { 'sirasagi62/toggle-cheatsheet.nvim' },
  { 'sirasagi62/tinysegmenter.nvim' },
  { 'sirasagi62/chopgrep.nvim',
    requires = {
      'MunifTanjim/nui.nvim',
      'grapp-dev/nui-components.nvim'
    }
  },
  { '~/project/vimuno' },
  { '~/project/lingua-nvim' },
  { 'sirasagi62/flf-vim' },
  { 'grapp-dev/nui-components.nvim',
    requires = 'MunifTanjim/nui.nvim'
  },


}
-- setting for colorscheme
vim.opt.cursorline = true -- show cursorline
vim.cmd [[colorscheme tokyonight]]

-- setting for brenoprata10/nvim-highlight-colors
require('nvim-highlight-colors').setup {}
-- before customize plugins configs


-- popup key-mapping hint with leader key
require 'key-menu'.set('n', '<Leader>')
require 'key-menu'.set('n', '<Leader>g', { desc = 'Git' })
require 'key-menu'.set('n', '<Leader>l', { desc = 'LSP' })
require 'key-menu'.set('n', '<Leader>t', { desc = 'Go to' })

-- settings for vim-expand-region
vim.keymap.set('v', 'v', '<Plug>(expand_region_expand)')
vim.keymap.set('v', 'V', '<Plug>(expand_region_shrink)')
vim.cmd([[
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'ia'  :0,
      \ 'i)'  :1,
      \ 'il'  :1,
      \ 'if'  :1,
      \ 'af'  :1,
      \ 'it'  :1,
      \ 'ie'  :0,
      \ }
]])

-- settings for nvim-surround
require('nvim-surround').setup({})

-- setting for lsp server
-- init mason
require('mason').setup()
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})


-- 2. build-in LSP function
-- keyboard shortcut
-- vim.keymap.set('n', '<Leader>lh', function() vim.lsp.buf.hover({ border = "single" }) end, { desc = 'Show more info' })
vim.keymap.set('n', '<Leader>lh', "<cmd>Lspsaga hover_doc<CR>", { desc = 'Show more info' })
vim.keymap.set('n', '<Leader>le', function() vim.diagnostic.open_float() end,
  { desc = 'Show diagnostic in floating window' })
vim.keymap.set('n', '<Leader>lf', function() vim.lsp.buf.format() end, { desc = 'Format' })
vim.keymap.set('n', '<Leader>lo', "<cmd>Lspsaga outline<CR>", { desc = 'Outline' })
vim.keymap.set('n', '<Leader>tr', "<cmd>Glance references<CR>", { desc = 'References' })
vim.keymap.set('n', '<Leader>ld', "<cmd>Glance definitions<CR>", { desc = 'Definitions' })
vim.keymap.set('n', '<Leader>tD', function() vim.lsp.buf.declaration() end, { desc = 'Declarations' })
vim.keymap.set('n', '<Leader>ti', "<cmd>Glance implementations<CR>", { desc = 'Implementations' })
vim.keymap.set('n', '<Leader>tt', "<cmd>Glance type_definitions<CR>", { desc = 'Type defs...' })
vim.keymap.set('n', '<F2>', "<cmd>Lspsaga rename<CR>")
vim.keymap.set('n', '<Leader>la', "<cmd>Lspsaga code_action<CR>", { desc = 'Actions..' })
vim.keymap.set('n', '<Leader>te', "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = 'Next diag..' })
vim.keymap.set('n', '<Leader>tE', "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = 'Prev diag..' })

-- make sign fancy
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})
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
  },
  mapping = cmp.mapping.preset.insert({
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-o>'] = cmp.mapping.complete(),
    ['<C-q>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  }),
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

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- For Golang
vim.lsp.config['gopls'] = {
  capabilities = capabilities
}

-- For templ
vim.lsp.config['html'] = {
  filetypes = { 'html', 'templ' }
}

-- vim.lsp.config['ts_ls'] = {
--   capabilities = capabilities
-- }
require('nvim-ts-autotag').setup()


-- For typescript

-- detect the project is node/bun or deno
local find_deno_files_dirs = function(path)
  local found_dirs = vim.fs.find({
    'deno.json',
    'deno.jsonc',
    'deps.ts',
  }, {
    upward = true,
    path = path
  })
  return found_dirs
end

-- if not deno, enable ts-tools
local dirs = find_deno_files_dirs(vim.env.PWD)
if #dirs == 0 then
  require("typescript-tools").setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  })
end

vim.lsp.config['denols'] = {
  root_dir = function(bufnr, callback)
    local found_dirs = find_deno_files_dirs(vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))))
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end,
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
}
-- For LuaLS

---@param names string[]
---@return string[]
local function get_plugin_paths(names)
  local paths = {}
  for _, name in ipairs(names) do
    if require("jetpack").tap(name) then
      table.insert(paths, jetpackpluginfolder .. name .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end



---@param plugins string[]
---@param myplugins string[]
---@return string[]
local function library(plugins, myplugins)
  local paths = get_plugin_paths(plugins)

  for _, name in ipairs(myplugins) do
    if require("jetpack").tap(name) then
      table.insert(paths, "~/project/" .. name .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end

  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end

vim.lsp.config["lua_ls"] = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = library({ 'nvim-cmp', 'nvim-submode' }, { "toggle-cheatsheet.nvim", "nvim-submode" }),
        checkThirdParty = "Disable",
      },
    },
  },
}

-- ** Enable LSPs **
require("mason-lspconfig").setup {
  ensure_installed = {
    "bashls",
    "clangd",
    -- "cmake",
    "cssls",
    "dockerls",
    "docker_compose_language_service",
    --"goimports",
    --"golangci-lint",
    "golangci_lint_ls",
    "gopls",
    "html",
    --"htmx",
    "lua_ls",
    --"prettier",
    --"stylua",
    "denols",
    "tailwindcss",
    "templ",
    -- "ts_ls",
    "marksman",
    "nimls",
    "pylsp",
    "zls"
  }
}



-- setting for showing indent
-- require('indent_blankline').setup()
require("ibl").setup()

-- setting for nvim-ufo, a folding plugin
-- from README example
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
require 'key-menu'.set('n', '<Leader>z', { desc = 'Folding' })
vim.keymap.set('n', '<leader>zR', require('ufo').openAllFolds, { desc = 'Unfold all blocks' })
vim.keymap.set('n', '<leader>zM', require('ufo').closeAllFolds, { desc = 'Fold all blocks' })
vim.keymap.set('n', '<leader>z+', 'za', { desc = 'Toggle fold' })

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('ufo').setup()

-- First, load your favorite colorshceme
local colors = require('tokyonight.colors').setup()
local get_mode = require('lualine.utils.mode').get_mode

-- setting for vim-commentary
vim.keymap.set('n', '<C-/>', 'gcc', { desc = 'Toggle comment' })

-- setting for guess-indent
require('guess-indent').setup {}

-- setting for hop.nvim
require('hop').setup()
vim.keymap.set('n', 's', ':HopChar2<CR>', { desc = 'Hop the word' })
-- setting for windows.nvim
require('windows').setup()
-- setting for nvim-submode

package.loaded['nvim-submode'] = nil
local sm = require('nvim-submode')

local function submodeNameLualine()
  return sm.get_submode_name() or is_fern_enable or get_mode()
end

local function submodeNameLualineWithBaseMode()
  local submode = sm.get_submode_name()
  if submode then
    return submode .. '(' .. get_mode() .. ')'
  else
    return get_mode()
  end
end

local function submodeLualineBGColor()
  local color = sm.get_submode_color()
  return color and
      { bg = color } or
      fern_statusline_color and
      { bg = fern_statusline_color } or
      nil
end

local function submodeLualineFGColor()
  local color = sm.get_submode_color()
  return color and { fg = color } or fern_statusline_color and { bg = fern_statusline_color, } or nil
end


local cascade_component = {
  'mode',
  {
    submodeNameLualine,
    cond = function()
      return submodeNameLualine() ~= ' '
    end
  },
}

local colored_submode_component = {
  {
    submodeNameLualine,
    color = submodeLualineBGColor,
    separator = { left = '', right = '' },
  }
}

local location_with_submode = {
  {
    'location',
    color = submodeLualineBGColor,
    separator = { left = '', right = '' },
  }

}

local progress_with_submode = {
  {
    'progress',
    color = submodeLualineFGColor,
    separator = { left = '', right = '' },
  }

}

local branch_with_submode = {
  {
    'branch',
    icon = { '' },
    color = submodeLualineFGColor
  }

}

local lualine_b_submode = {
  'diff', 'diagnostics'
}

-- config for lualine
local lualine = require('lualine')
lualine.setup {
  options = {
    globalstatus = true,
    theme = 'tokyonight',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = colored_submode_component,
    lualine_b = branch_with_submode,
    lualine_c = { 'diff', 'diagnostics', 'filename' },
    lualine_y = {}, --progress_with_submode,
    lualine_z = {}  --location_with_submode,
  }
}

vim.keymap.set('n', ';', function()
  vim.notify("; is disable")
end)
vim.keymap.set('n', ',', function()
  vim.notify(", is disable")
end)


local smart_f_keymap = {
  {
    'f<any>',
    function(_, keys, anys)
      print("f<any>")
      --
      return sm.replace_any(keys, anys), nil
    end,
    {
      desc = 'same as f in normal mode',
    }
  },
  { ',', ',', { desc = 'same as , in normal mode', } },
  { ';', ';', { desc = 'same as ; in normal mode', } },
  { 'f', ';', { desc = 'same as , in normal mode', } },
  { 'F', ',', { desc = 'same as ; in normal mode', } },
  { '<any>',
    function()
      return nil, sm.EXIT_SUBMODE
    end
  }
}

local sm_smart_f = sm.build_submode({
  name = "SMART-F",
  timeoutlen = 300,
  color = colors.purple,
  after_enter = function()
    vim.schedule(function()
      require("lualine").refresh()
    end)
  end,
  after_leave = function()
    vim.schedule(function()
      require("lualine").refresh()
    end)
    vim.notify("EXIT SMART-F")
  end
}, smart_f_keymap)
vim.keymap.set('n', 'f', function()
  sm.enable(sm_smart_f, 'f')
end)

vim.keymap.set('n', 'F', function()
  sm.enable(sm_smart_f, 'F')
end)
local capslock_sm = sm.build_submode({
  name = "CAPSLOCK",
  color = colors.yellow,
  is_count_enable = false,
  after_enter = function()
    -- vim.schedule(function()
    require("lualine").refresh()
    -- end)
  end,
  after_leave = function()
    -- vim.schedule(function()
    require("lualine").refresh()
    -- end)
    vim.notify("EXIT CAPSLOCK")
  end
}, {
  {
    '<any>',
    function(count, keys, anys)
      return string.upper(sm.replace_any(keys, anys))
    end
  },
  {
    '<C-L>',
    function(_, _, _)
      return "", sm.EXIT_SUBMODE
    end

  }
})

vim.keymap.set("i", "<C-L>", function()
  sm.enable(capslock_sm)
end)

vim.keymap.set("n", "<C-L>", function()
  sm.enable(capslock_sm)
end)
vim.keymap.set("c", "<C-L>", function()
  sm.enable(capslock_sm)
end)
local fizzbuzz_keymap = {
  {
    'f',
    function(count, _, _)
      count = count > 0 and count or 1
      local fb = ""
      for i = 1, count, 1 do
        if i % 15 == 0 then
          fb = fb .. 'FizzBuzz' .. '\n'
        elseif i % 3 == 0 then
          fb = fb .. 'Fizz' .. '\n'
        elseif i % 5 == 0 then
          fb = fb .. 'Buzz' .. '\n'
        else
          fb = fb .. tostring(i) .. '\n'
        end
      end

      return fb
    end
  }
}

vim.keymap.set('i', '<C-f>', function()
  sm.enable(sm.build_submode({
    name = "FIZZBUZZ",
    color = "#7dcfff",
    after_enter = function()
      vim.schedule(function()
        require("lualine").refresh()
      end)
    end,
    after_leave = function()
      vim.schedule(function()
        require("lualine").refresh()
      end)
      vim.notify("EXIT FIZZBUZZ")
    end
  }, fizzbuzz_keymap))
end)

local perfect_insider_sm = sm.build_submode({ name = "PERFECT INSIDER" },
  {
    { '<any>', 'F' },
  }
)

vim.keymap.set("i", "<C-S-f>", function()
  sm.enable(perfect_insider_sm)
end)

package.loaded['toggle-cheatsheet'] = nil
local tcs = require('toggle-cheatsheet').setup(true)

local function toggle_submode_cs()
  local cs = [[
>/<     : width+/-
+/-     : height+/-
hjkl    : move wins
tT      : move tabs++/--
wW      : move wins++/--
sv      : :sp/:vsp
n{n,h,t}: new vwin/win/tabs
b       : :Telescope buffers
f       : toggle fern
?       : toggle cheatsheet
]]
  tcs.toggle(cs)
end

local window_sm_map = {
  {
    '>',
    '<C-W>>',
    {}
  },
  {
    '<lt>',
    '<C-W><',
    {}
  },
  {
    '+',
    '<C-W>+',
    {}
  },
  {
    '-',
    '<C-W>-',
    {}
  },
  {
    'h',
    '<C-W>h',
    {}
  },
  {
    'j',
    '<C-W>j',
    {}
  },
  {
    'k',
    '<C-W>k',
    {}
  },
  {
    'l',
    '<C-W>l',
    {}
  },
  {
    'w',
    '<C-W>w',
    {}
  },
  {
    'W',
    '<C-W>W',
    {}
  },
  {
    't',
    sm.countable(
      function()
        vim.cmd [[tabn]]
      end
    ),
    {}
  },
  {
    'T',
    sm.countable(
      function()
        vim.cmd [[tabN]]
      end),
    {}
  },
  {
    's',
    function()
      vim.cmd [[sp]]
    end,
    {}
  },
  {
    'v',
    function()
      vim.cmd [[vsp]]
    end,
    {}
  },
  {
    'nh',
    function()
      vim.cmd [[new]]
    end,
    {}
  },
  {
    'nn',
    function()
      vim.cmd [[vnew]]
    end,
    {}
  },
  {
    'nt',
    function()
      vim.cmd [[tabnew]]
    end,
    {}
  },
  {
    'b',
    function()
      vim.cmd [[Telescope buffers]]
      return nil, sm.EXIT_SUBMODE
    end
  },
  {
    'f',
    function()
      vim.cmd [[Fern . -reveal=% -drawer -toggle -stay]]
      return nil, sm.EXIT_SUBMODE
    end
  },

  {
    '?',
    function()
      toggle_submode_cs()
    end
  }
}

vim.keymap.set('n', '<leader>w', function()
  sm.enable(sm.build_submode({
    name = "WINDOW",
    color = colors.red,
    after_enter = function()
      require("lualine").refresh()
      toggle_submode_cs()
    end,
    after_leave = function()
      require("lualine").refresh()
      tcs.closeCheatSheetWin()
    end
  }, window_sm_map))
end)


-- config for lazygit
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float', dir = vim.fn.getcwd() })

function _lazygit_toggle()
  lazygit:toggle()
end

-- config for zenn-view
local zv = Terminal:new({ cmd = 'zenn-view', hidden = true, direction = 'float' })

local function _zv_toggle()
  zv:toggle()
end

-- add zennview command
vim.api.nvim_create_user_command(
  'ZennView',
  _zv_toggle,
  {}
)

-- config for nvimff
local nvimff = Terminal:new({ cmd = 'nvimff', hidden = true, direction = 'float' })

local function _nvimff_toggle()
  nvimff:toggle()
end

vim.api.nvim_create_user_command(
  'Nvimff',
  _nvimff_toggle,
  {}
)

-- remake lazygit terminal automatically if current directory is changed
vim.api.nvim_create_augroup('chdirForLazygit', {})
vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  group = 'chdirForLazygit',
  callback = function()
    lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float', dir = vim.fn.getcwd() })
  end
})

vim.keymap.set('n', '<leader>gl', function()
  -- reload fern
  vim.g['should_reload_fern'] = true
  _lazygit_toggle()
end, { noremap = true, silent = true, desc = 'Open LazyGit' })
vim.api.nvim_set_keymap('n', '<leader>gf', '<cmd>Flog<CR>', { noremap = true, silent = true, desc = 'Flog Graph' })

local splitterm = Terminal:new({
  hidden = true,
  direction = 'vertical',
  on_open = function()
    vim.opt_local.winfixbuf = true
  end
})

function _splitterm_toggle()
  splitterm:toggle()
end

vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>lua _splitterm_toggle()<CR>', { noremap = true, desc = 'Open @terminal' })
vim.api.nvim_set_keymap('t', '<C-a>', '<cmd>lua _splitterm_toggle()<CR>', { noremap = true, desc = 'Close terminal' })

-- config for make terminal better
-- set escape key to escape from terminal.

vim.api.nvim_set_keymap('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>@', ':split | wincmd j |terminal<CR>i', { desc = 'Open new terminal' })

-- config for Telescope
require('telescope').setup {
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
          -- ["<CR>"] = "select_tab"
        }
      }
    },
    live_grep = {
      mappings = {
        i = {
          -- ["<CR>"] = "select_tab"
        }
      }
    },
  },
  extensions = {
  }
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', builtin.find_files, { desc = 'Open File...' })
vim.keymap.set('n', '<Leader>f', builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>W', require("telescope").extensions.windows.list, { desc = 'Windows and Tab' })
vim.keymap.set('n', '<Leader>b', builtin.buffers, { desc = 'Buffers' })

-- Diagnostics Submode
vim.keymap.set('n', '<leader>e', function()
  builtin.diagnostics()
end, { desc = 'Diagnostics List' })


package.loaded['tinysegmenter'] = nil
tinyseg = require("tinysegmenter")

--example
-- loading the plugin
--local tcs = require('toggle-cheatsheet').setup(true)

-- make your own cheat sheet
local cs1 = tcs.createCheatSheetFromSubmodeKeymap(
  tcs.conf {
    { "h", "←" },
    { "j", "↓" },
    { "k", "↑" },
    { "l", "→" },
    { "gg", "Go to the top" },
    { "G", "Go to the bottom" },
    { "%", "Go to matching bracket" }
  }
)

-- define another cheat sheet
local cs2 = tcs.createCheatSheetFromSubmodeKeymap(
  tcs.conf {
    { "Ctrl + f", "Scroll forward one full screen." },
    { "Ctrl + b", "Scroll backward one full screen." },
    { "Ctrl + d", "Scroll down half a screen." },
    { "Ctrl + u", "Scroll up half a screen." },
    { "Ctrl + g", "Show the current file name and line number." }
  }
)

cs2 = [[
Ctrl+{f|b}:1スクリーン上/下
Ctrl+{d|u}:半スクリーン上/下
Ctrl+g    :現在のファイル名と行数を表示
]]

-- assign your favorite keymap to display a cheat sheet window.
vim.keymap.set("n", "<Leader>q", function()
  tcs.toggle(cs1)
end)
vim.keymap.set("n", "<Leader>Q", function()
  tcs.toggle(cs2)
end)
require("nvim-lcl-lisp-runner").setup({
  clisp_cmd = { "rlwrap", "clasp" },
  clisp_with_file_cmd = { "rlwrap", "clasp", "-l" }
})

-- Add tokyonight colorpallet
local palette_text = [[
---@class Palette
local ret = {
  bg = "#24283b",
  bg_dark = "#1f2335",
  bg_dark1 = "#1b1e2d",
  bg_highlight = "#292e42",
  blue = "#7aa2f7",
  blue0 = "#3d59a1",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  comment = "#565f89",
  cyan = "#7dcfff",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  orange = "#ff9e64",
  purple = "#9d7cd8",
  red = "#f7768e",
  red1 = "#db4b4b",
  teal = "#1abc9c",
  terminal_black = "#414868",
  yellow = "#e0af68",
  git = {
    add = "#449dab",
    change = "#6183bb",
    delete = "#914c54",
  },
}
return ret
]]

---フローティングウィンドウでパレットを表示する関数
local function show_palette()
  -- 1. テキストを一時バッファに書き込む
  local bufnr = vim.api.nvim_create_buf(false, true)    -- リストに表示せず、編集できないバッファを作成
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(palette_text, "\n"))
  vim.api.nvim_buf_set_option(bufnr, "filetype", "lua") -- 構文ハイライトを適用

  -- 2. フローティングウィンドウのオプションを設定
  local width = 50                                  -- ウィンドウの幅
  local height = vim.api.nvim_buf_line_count(bufnr) -- 行数に合わせて高さを設定
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    border = "rounded", -- 枠線
    style = "minimal",
  }

  -- 3. フローティングウィンドウを作成
  local winnr = vim.api.nvim_open_win(bufnr, true, opts)

  -- 4. 終了するためのキーマップを設定
  -- q または <Esc> でウィンドウを閉じる
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", ":close<CR>", { silent = true, nowait = true })

  -- 5. カーソルを一番上に戻す
  vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
end

-- 6. :Palette コマンドを定義
vim.api.nvim_create_user_command("Palette", show_palette, {
  desc = "カラースキームのパレットを表示します",
})

if vim.fn.filereadable("~/.101keyboard") then
  local all_modes = {
    "n", -- Normal mode
    "v", -- Visual mode
    "x", -- Visual line mode (Note: 'v' often covers both visual modes, but 'x' is for line-wise)
    "s", -- Select mode
    "o", -- Operator-pending mode
    "i", -- Insert mode
    "c", -- Command-line mode
    "t", -- Terminal mode
    "l", -- Lua mode (Internal: used for defining Lua function mappings)
  }
  vim.keymap.set(all_modes,";",":")
  vim.keymap.set(all_modes,":",";")
end
-- require("vimuno")
-- require("chopgrep")
-- require("lingua-nvim")

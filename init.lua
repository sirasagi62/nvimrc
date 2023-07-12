-- Config for Japanese encodings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = {"utf-8","cp-932","euc-jp"}

-- show inputting command
vim.opt.showcmd = true
-- highlight {}
vim.opt.showmatch = true
-- make highlight duration shorter than default config
vim.opt.matchtime = 3 

-- set backspace config better
vim.opt.backspace = {"eol","indent","start"}

-- scrolling config better
vim.opt.scrolloff = 5

-- change Tab to Space

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
  {'cocopon/iceberg.vim'},
  {'folke/tokyonight.nvim'}
}

-- setting for colorscheme
vim.opt.cursorline = true
require("tokyonight").setup({
  style = "storm",
  on_highlights = function(hl, c)
    hl.LineNr = {
      fg = c.yellow
    }
  end,
})
vim.cmd[[colorscheme tokyonight]]
-- set line number color to yellow.
-- [[
vim.api.nvim_exec('highlight LineNr ctermfg = 228',false)
-- Sets colors to line numbers Above, Current and Below  in this order
function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#51B3EC', bold=true })
    --vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#FB508F', bold=true })
end

LineNumberColors()
]]--

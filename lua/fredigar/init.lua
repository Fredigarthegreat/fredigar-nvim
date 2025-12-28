require('fredigar.remaps')
require('fredigar.packer')
require('fredigar.options')
require('fredigar.globals')
require('fredigar.dev')
-- require('fredigar.journal')
vim.cmd 'colorscheme cybergrunge'
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.s",
  command = "set filetype=asm_ca65"
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
})
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

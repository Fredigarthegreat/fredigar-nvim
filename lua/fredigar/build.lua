vim.cmd('luafile init.lua')
vim.cmd('luafile journal.lua')
vim.api.nvim_del_augroup_by_name('journal')

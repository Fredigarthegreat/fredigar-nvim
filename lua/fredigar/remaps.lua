vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>:", ":!")
vim.keymap.set("n", "<leader>r", ":r!")
vim.keymap.set("n", "<leader>n", ":noh<CR>")
vim.keymap.set("n", "<leader>v", function()
                                   if vim.api.nvim_get_option_value("virtualedit", {}) == "all" then
                                     vim.cmd("se virtualedit=none")
                                     print"virtualedit=none"
                                   else
                                     vim.cmd("se virtualedit=all")
                                     print"virtualedit=all"
                                   end
                                 end
)

vim.keymap.set("n", "<leader>b", ":lua RM()<CR>")
vim.keymap.set("n", "<leader>h", function()
                                   local current_file_path = vim.fn.expand("%:p")     -- Get the absolute path of the current file
                                   local file_base = vim.fn.fnamemodify(current_file_path, ":r") -- Strip the extension
                                   local header_file = file_base .. ".h"             -- Change the extension to .h
                               
                                   -- Check if the header file exists
                                   if vim.fn.filereadable(header_file) == 1 then
                                     vim.cmd("edit " .. header_file)
                                   else
                                     vim.notify("Header file not found", vim.log.levels.WARN)
                                   end
                                 end, { desc = "Open corresponding header file" }
)

vim.keymap.set("n", "<leader>z", function()
                                   local current = vim.api.nvim_get_current_win()
                                   for _, win in ipairs(vim.api.nvim_list_wins()) do
                                     if win ~= current then
                                       vim.api.nvim_win_close(win, true)
                                     end
                                   end
                                 end
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'*.c', '*.h'},
  callback = function()
    vim.keymap.set('n', '<leader>E', function()
      local filepath = function()
                         return string.sub(vim.fn.expand('%:p'), 1, -2) .. 'c'
                       end
      local filename = vim.fn.expand('%:t')
      local pre_file = '/tmp/' .. filename .. '.i'
      local cmd = string.format('gcc -E "%s" -o "%s"', filepath, pre_file)
      vim.fn.system(cmd)
      vim.cmd('edit ' .. pre_file)
    end, { buffer = true, desc = 'Open preprocessed C file' })
  end
})

vim.keymap.set("x", "<leader>p", [["_dP]])

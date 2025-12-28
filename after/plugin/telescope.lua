local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>',  builtin.git_files, {})
vim.keymap.set('n', '<leader>pg', function ()
                                    builtin.live_grep({
                                      additional_args = {"-L"},
                                    })
                                  end
)
vim.keymap.set('n', '<leader>cf', function() 
                                    builtin.find_files({cwd = '/home/fredigar/.config/nvim'})
                                  end, 
                                  { noremap = true, silent = true }
)

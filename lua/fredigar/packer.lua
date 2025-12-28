vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
    "kylechui/nvim-surround",
    tag = "*", 
    config = function()
      require("nvim-surround").setup({
      })
    end
  })

  use 'neovim/nvim-lsp'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  -- use 'hrsh7th/cmp-cmdline'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'jackguo380/vim-lsp-cxx-highlight'

  use 'maxbane/vim-asm_ca65'

  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
  }

  use { "catppuccin/nvim", as = "catppuccin" }
  use { "thedenisnikulin/vim-cyberpunk" }
  use { "Fredigarthegreat/vim-cybergrunge" }

  use 'kana/vim-textobj-user'
  use 'wellle/targets.vim'

  use '/home/fredigar/src/plugins/journal.nvim'
  use '/home/fredigar/src/plugins/event-behavior.nvim'

end)

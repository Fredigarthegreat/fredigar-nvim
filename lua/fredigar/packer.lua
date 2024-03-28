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
        
	use 'jackguo380/vim-lsp-cxx-highlight'
	
	use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!

	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { {"nvim-lua/plenary.nvim"} }
	}

	use { "catppuccin/nvim", as = "catppuccin" }
end)

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('folke/snacks.nvim')
Plug('itchyny/lightline.vim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('ful1e5/onedark.nvim')
Plug('supermaven-inc/supermaven-nvim')
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('mason-org/mason.nvim')
Plug('mason-org/mason-lspconfig.nvim')

vim.call('plug#end')

vim.g.lightline = { colorscheme = 'one' }
vim.opt.showmode = false
vim.opt.number = true
vim.opt.wrap = false
vim.opt.laststatus = 3
vim.opt.hlsearch = false
vim.cmd.colorscheme("onedark")

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', 'y', 'ygv')
vim.keymap.set('v', 'p', 'pgvy')

vim.keymap.set('n', '<c-\\>', '<c-w>w')
vim.keymap.set({'i', 'v'}, '<c-\\>', '<ESC><c-w>w')

vim.keymap.set('n', 'ff', function() Snacks.picker.grep() end)
vim.keymap.set('n', 'ft', function() Snacks.terminal() end)

vim.keymap.set('n', 'h', '<BS>')
vim.keymap.set('n', 'l', '<Space>')
vim.keymap.set({'n', 'v'}, '<c-j>', 'jjjjj')
vim.keymap.set({'n', 'v'}, '<c-k>', 'kkkkk')
vim.keymap.set({'n', 'v'}, '<c-h>', 'hhhhh')
vim.keymap.set({'n', 'v'}, '<c-l>', 'lllll')

vim.keymap.set('n', '<c-b>', ':NvimTreeToggle<CR>')

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

vim.diagnostic.config({
	virtual_text = {
		prefix = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = ' ',
				[vim.diagnostic.severity.WARN] = ' ',
				[vim.diagnostic.severity.INFO] = ' ',
			}
			return icons[diagnostic.severity] or '● ' -- return cdot if no icon is found
		end,
		spacing = 4,
	},
	signs = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
})

require('supermaven-nvim').setup({keymaps = {accept_suggestion = "<C-y>"}})
require('snacks').setup({picker = {layout = { layout = { win_options = { statusline = {} } } }, win_options = { winbar = "" } } })
local function tree_attach(bufnr)
	local api = require('nvim-tree.api')
	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.del('n', '<C-k>', { buffer = bufnr })
end
require('nvim-tree').setup({ view = { width = 30 }, on_attach = tree_attach })
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		['<C-space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	})
})
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = {
		'pyright',
		'ts_ls',
		'lua_ls',
		'rust_analyzer',
		'bashls',
		'cssls',
		'html',
		'jsonls',
	},
})

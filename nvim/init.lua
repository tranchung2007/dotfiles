-- options
vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.guicursor = ""
vim.opt.splitbelow = true
vim.opt.splitright = true
-- vim.opt.autochdir = true
vim.opt.smartcase = true
vim.opt.cinoptions = "l1"
vim.cmd("set clipboard+=unnamedplus")
vim.diagnostic.config({ virtual_text = { current_line = true } })
-- vim.cmd('set keymap=vietnamese-telex_utf-8') --CHXHCNVN

-- keymaps
vim.keymap.set("n", "<leader>r", ":sp | term ", { noremap = true })

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        "kdheepak/monochrome.nvim",
        "stevearc/oil.nvim",
        "neovim/nvim-lspconfig",
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
        },
        {
            "saghen/blink.cmp",
            version = '*',
        },
        {
            "catgoose/nvim-colorizer.lua",
            event = "BufReadPre",
        },
    },
})

require("colorizer").setup({})
require("nvim-treesitter.configs").setup({})
require("nvim-autopairs").setup({})

require("blink.cmp").setup({
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
    },
    completion = {
        list = {
            max_items = 30,
            selection = {
                preselect = false,
                auto_insert = false,
            },
        },
        menu = {
            draw = {
                columns = { { 'label', 'label_description', gap = 2 }, { 'kind' } },
            },
        },
    },
    keymap = {
        preset = 'none',
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-e>'] = { 'hide', 'show' },
    },
    cmdline = {
        keymap = {
            preset = 'cmdline',
            ['<CR>'] = { 'accept', 'fallback' },
        },
    },
})

local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
require("lspconfig").clangd.setup({
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--header-insertion=never",
	},
})
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
})

require("oil").setup({
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	default_file_explorer = true,
	columns = {
		"permissions",
        "birthtime",
		"size",
	},
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["."] = { "actions.open_cmdline" },
		["gl"] = { "actions.open_terminal" },
        ["gm"] = { "actions.send_to_qflist" }
	},
})

vim.g.monochrome_style = "amplified"
vim.cmd.colorscheme("monochrome")

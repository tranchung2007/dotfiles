vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 4
vim.o.guicursor = ""
vim.o.cinoptions = "l1"
vim.o.undofile = true
vim.opt.completeopt = { "noselect", "noinsert", "menu" }
vim.cmd("set clipboard+=unnamedplus")
vim.diagnostic.config({ virtual_text = { current_line = true }})

vim.keymap.set("n", "<leader>r", ":sp | term ", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":sp | term rg --vimgrep --files | rg ", { noremap = true })
vim.keymap.set("n", "<leader>fw", ":sp | term rg --vimgrep ", { noremap = true })
vim.keymap.set("n", "<leader>c", "<cmd>bd!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>b", "<cmd>cgetb | bd! | cope<CR>", { silent = true, noremap = true })

local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('miikanissi/modus-themes.nvim')
    Plug('stevearc/oil.nvim')
    Plug('dense-analysis/ale')
    Plug('nvim-treesitter/nvim-treesitter')
vim.call('plug#end')

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
require("oil").setup({
    constrain_cursor = "name",
    columns = {
        "permissions",
        "birthtime",
        "size",
    },
})
-- require("nvim-treesitter").setup({})

-- vim.lsp.config['clangd'] = {
--     cmd = { 'clangd', '--header-insertion=never' },
--     filetypes = { 'c', 'cpp', 'h', 'hpp' },
-- }
-- vim.lsp.enable('clangd')

vim.cmd.colorscheme('modus_vivendi')

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

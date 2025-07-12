-- Based on https://github.com/rexim/dotfiles/blob/master/.vimrc
vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.guicursor = ""
vim.opt.cinoptions = "l1"
vim.opt.undofile = true
vim.opt.title = true
vim.opt.completeopt = { "noselect", "noinsert", "menu" }
vim.cmd("set clipboard+=unnamedplus")
vim.diagnostic.config({ virtual_text = { current_line = true } })
-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Stolen from https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/autocmds.lua
-- Don't auto commenting new lines
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
autocmd('BufEnter', {
    pattern = '',
    command = 'set fo-=c fo-=r fo-=o'
})

-- Stolen from https://www.manjotbal.ca/blog/neovim-whitespace.html
vim.opt.list = true
vim.opt.listchars = 'tab:» ,lead:·,trail:·'
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='LightRed' })
autocmd('BufEnter', {
    pattern = '*',
    command = [[
        syntax clear TrailingWhitespace |
        syntax match TrailingWhitespace "\_s\+$"
    ]]}
)

-- Some useful keymaps
vim.keymap.set("n", "<A-r>", ":sp | term ", { noremap = true })
vim.keymap.set("n", "<C-x><C-d>", ":sp | term rg --vimgrep --files | rg ", { noremap = true })
vim.keymap.set("n", "<C-x><C-f>", ":sp | term rg --vimgrep -SFM 200 ", { noremap = true })
vim.keymap.set("n", "<A-j>", "<cmd>bd!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>cgetb | bd! | cope<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-Tab>", ":buffer<space><C-z>", { noremap = true })

-- Stolen from https://tui.ninja/neovim/tips/moving_lines
-- Move single-line in normal mode
vim.keymap.set("n", "<A-n>", ":move .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-p>", ":move .-2<CR>==", { silent = true })
-- Move multi-line in visual mode
vim.keymap.set("v", "<A-n>", ":move '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-p>", ":move '<-2<CR>gv=gv", { silent = true })

-- Urgirlfriend plugin manager (because she is lazy)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "miikanissi/modus-themes.nvim", priority = 1000 },
        { "blazkowolf/gruber-darker.nvim", priority = 999 },
        {
            "stevearc/oil.nvim",
            ---@module 'oil'
            ---@type oil.SetupOpts
            opts = {
                vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
                constrain_cursor = "name",
                columns = {
                    "permissions",
                    "birthtime",
                    "size",
                },
                confirmation = {
                    border = "none",
                },
                watch_for_changes = true,
            },
            lazy = false,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                    highlight = true,
                    indent = true,
                    autotag = true,
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<C-space>",
                            node_incremental = "<C-space>",
                            scope_incremental = "<A-space>",
                            node_decremental = "<bs>",
                        },
                    },
                })
            end,
        },
        {
            "yorickpeterse/nvim-pqf",
            config = function()
                require('pqf').setup({
                    signs = {
                        error = { text = 'E', hl = 'DiagnosticSignError' },
                        warning = { text = 'W', hl = 'DiagnosticSignWarn' },
                        info = { text = 'I', hl = 'DiagnosticSignInfo' },
                        hint = { text = 'H', hl = 'DiagnosticSignHint' },
                    },
                    show_multiple_lines = false,
                    max_filename_length = 20,
                    filename_truncate_prefix = '[..]',
                })
            end,
        },
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
            },
            config = function()
                local cmp = require'cmp'
                cmp.setup({
                    performance = {
                        max_view_entries = 7,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    }),
                    sources = cmp.config.sources({
                        { name = 'path' },
                    }, {
                        { name = 'buffer' },
                    })
                })
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = 'path' }
                    }, {
                        { name = 'cmdline' }
                    }),
                    matching = { disallow_symbol_nonprefix_matching = false }
                })
                cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' }
                    }
                })
            end
        },
    },
})

vim.cmd.colorscheme("gruber-darker")

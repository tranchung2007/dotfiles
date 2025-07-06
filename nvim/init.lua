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
vim.opt.completeopt = { "noselect", "noinsert", "menu" }
vim.cmd("set clipboard+=unnamedplus")
vim.diagnostic.config({ virtual_text = { current_line = true } })

-- Stolen from https://www.manjotbal.ca/blog/neovim-whitespace.html
vim.o.list = true
vim.o.listchars = 'tab:» ,lead:·,trail:·'
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='LightRed' })
vim.api.nvim_create_autocmd('BufEnter', {
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
vim.keymap.set("n", "<A-n>", ":move .+1<CR>==")
vim.keymap.set("n", "<A-p>", ":move .-2<CR>==")
-- Move multi-line in visual mode
vim.keymap.set("v", "<A-n>", ":move '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-p>", ":move '<-2<CR>gv=gv")

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
                    show_multiple_lines = true,
                    max_filename_length = 20,
                    filename_truncate_prefix = '[...]',
                })
            end,
        },
        {
            'johnfrankmorgan/whitespace.nvim',
            config = function()
                require('whitespace-nvim').setup({})
            end
        },
    },
})

vim.cmd.colorscheme("gruber-darker")

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
vim.diagnostic.config({ virtual_text = { current_line = true } })

vim.keymap.set("n", "<A-r>", ":sp | term ", { noremap = true })
vim.keymap.set("n", "<C-x><C-d>", ":sp | term rg --vimgrep --files | rg ", { noremap = true })
vim.keymap.set("n", "<C-x><C-f>", ":sp | term rg --vimgrep -SFM 200 ", { noremap = true })
vim.keymap.set("n", "<A-c>", "<cmd>bd!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>cgetb | bd! | cope<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-Tab>", ":buffer<space><C-z>", { noremap = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "miikanissi/modus-themes.nvim", priority = 1000 },
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
                require('pqf').setup({})
            end,
        },
    },
})

vim.cmd.colorscheme("modus_vivendi")

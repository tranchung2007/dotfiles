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

vim.keymap.set("n", "<leader>r", ":sp | term ", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":sp | term rg --vimgrep --files | rg ", { noremap = true })
vim.keymap.set("n", "<leader>fw", ":sp | term rg --vimgrep ", { noremap = true })
vim.keymap.set("n", "<leader>c", "<cmd>bd!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>b", "<cmd>cgetb | bd! | cope<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader><Tab>", ":b<space><C-z>", { noremap = true })

local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('miikanissi/modus-themes.nvim')
    Plug('stevearc/oil.nvim')
    Plug('nvim-treesitter/nvim-treesitter')
vim.call('plug#end')

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
            },
            lazy = false,
        },
        -- {
        --     "dense-analysis/ale",
        --     config = function()
        --         vim.g.ale_completion_enabled = 1
        --         vim.cmd("set omnifunc=ale#completion#OmniFunc")
        --         vim.g.ale_fixers = {
        --             ["*"] = { "remove_trailing_lines", "trim_whitespace" },
        --         }
        --     end,
        -- },
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                    highlight = {
                        enable = true,
                    },
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
    },
})
require("nvim-treesitter").setup({})

vim.cmd.colorscheme("modus_vivendi")

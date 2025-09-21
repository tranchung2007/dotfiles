vim.o.number = true
vim.o.relativenumber = true
vim.opt.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.ignorecase = true
vim.o.smartcase = true
vim.cmd("set clipboard+=unnamedplus")

---------------------------------------
local vim = vim
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
    Plug("stevearc/oil.nvim")
    Plug("benomahony/oil-git.nvim")
    Plug("saghen/blink.cmp", { ["tag"] = "*" })
    Plug("smilhey/ed-cmd.nvim")
    Plug("ibhagwan/fzf-lua")
    Plug("nvim-treesitter/nvim-treesitter")
    Plug("darianmorat/gruvdark.nvim")
vim.call("plug#end")

require("nvim-treesitter.configs").setup({
    auto_install = true,
    hightlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = { enable = true },
    indent = {
        enable = true,
    },
})

require("fzf-lua").setup({ { "borderless" } })
vim.keymap.set("n", "<C-Space>", "<CMD>FzfLua buffers<CR>")
vim.keymap.set("n", "<Space>gr", "<CMD>FzfLua live_grep_native<CR>")
vim.keymap.set("n", "<Space>gn", "<CMD>FzfLua resume<CR>")
vim.keymap.set("v", "<C-s>", "<CMD>FzfLua grep_visual<CR>")

require("ed-cmd").setup({})

require("blink.cmp").setup({
    sources = {
        providers = {
            buffer = {
                opts = {
                    get_bufnrs = function()
                        return vim.tbl_filter(function(bufnr)
                            return vim.bo[bufnr].buftype == ""
                        end, vim.api.nvim_list_bufs())
                    end,
                },
            },
        },
    },
})

require("oil").setup({
    constrain_cursor = "name",
    watch_for_changes = true,
    columns = {
        "permissions",
        "birthtime",
        "size",
    },
    view_options = {
        show_hidden = true,
    },
    vim.keymap.set(
        "n",
        "<Space>gr",
        "<CMD>lua FzfLua.live_grep_native({ cwd = require('oil').get_current_dir() })<CR>"
    ),
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
---------------------------------------

-- whitespace-mode
vim.opt.list = true
vim.opt.listchars = "tab:» ,lead:·,trail:·"
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- move line
vim.keymap.set("n", "<A-n>", "<CMD>move .+1<CR>==")
vim.keymap.set("n", "<A-p>", "<CMD>move .-2<CR>==")
vim.keymap.set("v", "<A-n>", "<CMD>move '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-p>", "<CMD>move '<-2<CR>gv=gv")

-- simple command run
vim.keymap.set("n", "<Space>r", ":bel sp | term ")
vim.keymap.set("n", "<Space>k", "<CMD>bd!<CR>")
vim.keymap.set("n", "<Space>a", "<CMD>cgetb | bd! | cope<CR>")

vim.cmd("colorscheme retrobox")

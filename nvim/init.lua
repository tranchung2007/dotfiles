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
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('stevearc/oil.nvim')
vim.call('plug#end')

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
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
---------------------------------------

-- whitespace-mode
vim.opt.list = true
vim.opt.listchars = 'tab:» ,lead:·,trail:·'
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='LightRed' })
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    command = [[
        syntax clear TrailingWhitespace |
        syntax match TrailingWhitespace "\_s\+$"
    ]]}
)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- move line
vim.keymap.set("n", "<A-n>", ":move .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-p>", ":move .-2<CR>==", { silent = true })
vim.keymap.set("v", "<A-n>", ":move '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-p>", ":move '<-2<CR>gv=gv", { silent = true })

vim.cmd("colorscheme retrobox")

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
vim.opt.cindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.scrolloff = 8
vim.opt.guicursor = ""
vim.cmd("set clipboard+=unnamedplus")
vim.diagnostic.config({ virtual_text = { current_line = true } })
-- vim.cmd('set keymap=vietnamese-telex_utf-8') --CHXHCNVN

-- keymaps
vim.keymap.set("n", "<leader>r", ":sp | term ", { noremap = true })

-- plugins
local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')
-- Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('windwp/nvim-autopairs', { ['on'] = 'InsertEnter' })
Plug('kdheepak/monochrome.nvim')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('neovim/nvim-lspconfig')
Plug('stevearc/oil.nvim')
vim.call('plug#end')

-- require("nvim-treesitter.configs").setup {}
require("nvim-autopairs").setup({})
local cmp = require("cmp")
require("cmp").setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Enter>"] = cmp.mapping.confirm({ select = true }),
        ['<C-j>'] = cmp.mapping.abort(),
    }),
    performance = {
        debounce = 30,
        throte = 15,
        max_view_entries = 15,
    },
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").clangd.setup {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--header-insertion=never"
    },
}
require("lspconfig").lua_ls.setup {
    capabilities = capabilities,
}
require("oil").setup({
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
    default_file_explorer = true,
    columns = {
        "permissions", "size", "mtime",
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
        ["gt"] = { "actions.open_terminal" },
    },
})
vim.g.monochrome_style = "amplified"
vim.cmd.colorscheme('monochrome')
-- custom command

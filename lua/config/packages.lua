local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.linespace = 0
vim.opt.clipboard = "unnamedplus"

vim.opt.laststatus = 3

vim.keymap.set('n', '<leader>t', ':Ex<CR>', { desc = 'File view' })

local plugins = {
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/stevearc/dressing.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/yetone/avante.nvim", build = "nice -n 19 make -j2" },
    { src = "https://github.com/sainnhe/gruvbox-material" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
    { src = "https://github.com/L3MON4D3/LuaSnip",                         build = "make install_jsregexp" },
    { src = "https://github.com/stevearc/conform.nvim" },
}

vim.pack.add(plugins)

-- 1. Register physical binaries with explicit paths
-- Doing this BEFORE the autocommand ensures Neovim knows where the engines are
local parser_dir = vim.fn.expand("$HOME/.local/share/nvim/site/parser/")

-- Only attempt registration if the folder actually exists
if vim.fn.isdirectory(parser_dir) == 1 then
    local built_langs = {
        "c", "rust", "go", "bash", "lua", "javascript",
        "typescript", "tsx", "css", "html"
    }

    for _, lang in ipairs(built_langs) do
        local path = parser_dir .. lang .. ".so"
        if vim.fn.filereadable(path) == 1 then
            vim.treesitter.language.add(lang, { path = path })
        end
    end
end

-- 2. Define Language Aliases
-- Tells Neovim: "When you see an 'sh' file, use the 'bash' engine and queries"
vim.treesitter.language.register('bash', 'sh')
vim.treesitter.language.register('bash', 'bashrc')

-- 3. The "Silent" Starter
-- This triggers the coloring only when a buffer is loaded
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local ignore = { "netrw", "TelescopePrompt", "AvanteInput", "cmp_menu" }
        if vim.tbl_contains(ignore, vim.bo.filetype) then return end

        -- pcall handles the "what if the parser isn't built yet?" scenario gracefully
        pcall(vim.treesitter.start)
    end,
})


require("config.colorscheme")
require("config.lsp")
require("config.completion")
require("config.telescope")
require("config.conform")
require("config.avante")

return M

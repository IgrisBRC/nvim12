-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Quality of Life
local opt = vim.opt
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Relative numbers for easier jumping
opt.shiftwidth = 4          -- Size of an indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.ignorecase = true       -- Ignore case in search...
opt.smartcase = true        -- ...unless uppercase is used
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.updatetime = 250        -- Faster completion/hover response

-- Bootstrap vim.pack logic
require("config.packages")

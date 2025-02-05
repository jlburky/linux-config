-- To view detail about any option, type ":h <option>
vim.cmd("let g:netrw_liststyle = 3")

-- May want to set this eventually...
--vim.cmd("let g:python3_host_prog = '/path/to/venvs/pynvim/bin/python'")

local opt = vim.opt

-- Display
opt.signcolumn = "yes" -- shown sign column so text doesn't shift
opt.background = "dark" -- always choose dark colorscheme option
opt.termguicolors = true -- enable nvim truecolor (true) or 256 (false)

-- Line displays
opt.relativenumber = true -- show relative line numbers
opt.number = true -- show absolute line number

-- Tabs & indention
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width 
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line to new line

-- Search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you used mixed-case, case-sensitive

-- Line wrapping
opt.wrap = false -- I may want this to true

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- Maintain file history even after it's closed
opt.undofile = true

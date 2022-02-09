local g = vim.g
local cmd = vim.cmd
local o = vim.o
local wo = vim.wo
local bo = vim.bo

o.number = true -- Show line numbers
o.wrap = false -- Don't visually wrap lines
o.showmode = false -- Don't show mode (--INSERT--, etc)
o.cursorline = true -- Highlight the current cursor line
o.hidden = true -- Allow buffer switching without having to save
o.list = true -- Show non-printable characters
o.hlsearch = true -- Highlight searched text
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Don't ignore case when using uppercase in a search
o.confirm = true -- Ask for confirmation when closing unsaved files

-- colorscheme
cmd("colorscheme gruvbox")
o.termguicolors = true
o.background = "dark"

-- Vertical split coloring
cmd("highlight VertSplit ctermbg=8 ctermfg=black")
o.fillchars = o.fillchars .. "vert:│"

-- Better list characters
o.listchars = "tab:› ,trail:-"

-- Incremental scrolling
o.sidescroll = 1
o.scrolloff = 1
o.sidescrolloff = 5

-- Don't autoselect the first entry when doing completion
o.completeopt = "longest,menuone"

-- Disable backup files
o.backup = false
o.writebackup = false
o.swapfile = false

-- Tab configurations
o.smartindent = true
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2

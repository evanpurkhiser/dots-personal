local exec = vim.api.nvim_exec
local set = vim.opt
local cmd = vim.cmd
local g = vim.g

set.number = true -- Show line numbers
set.wrap = false -- Don't visually wrap lines
set.showmode = false -- Don't show mode (--INSERT--, etc)
set.cursorline = true -- Highlight the current cursor line
set.hidden = true -- Allow buffer switching without having to save
set.list = true -- Show non-printable characters
set.hlsearch = true -- Highlight searched text
set.ignorecase = true -- Ignore case when searching
set.smartcase = true -- Don't ignore case when using uppercase in a search
set.confirm = true -- Ask for confirmation when closing unsaved files

-- colorscheme
cmd("colorscheme gruvbox-flat")
g.gruvbox_flat_style = "dark"

set.termguicolors = true
set.background = "dark"

-- Vertical split coloring
cmd("highlight VertSplit ctermbg=8 ctermfg=black")
set.fillchars:append("vert:│")

-- Better list characters
set.listchars = "tab:› ,trail:-"

-- Incremental scrolling
set.sidescroll = 1
set.scrolloff = 1
set.sidescrolloff = 5

-- Don't autoselect the first entry when doing completion
set.completeopt = "longest,menuone"

-- Disable backup files
set.backup = false
set.writebackup = false
set.swapfile = false

-- Tab configurations
set.smartindent = true
set.expandtab = true
set.tabstop = 2
set.shiftwidth = 2

-- Disable netrw
g.loaded_netrwPlugin = false
g.loaded_netrwSettngs = false
g.loaded_netrwFileHandlers = false

-- Enable spell check in git commit messages
exec(
  [[
  augroup CommitSpellCheck
    au!
    au BufRead COMMIT_EDITMSG setlocal spell
  augroup END
  ]],
  false
)

-- Enable spell check in git commit messages
exec(
  [[
  augroup HelpWindow
    au!
    au FileType help wincmd L
  augroup END
  ]],
  false
)

-- Highlight
exec(
  [[
  augroup YankHighlight
    au!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=800}
  augroup end
  ]],
  false
)

-- Make searches nice and in-your-face
cmd("highlight! link Search Todo")

--- Spelling should be done at the toplevel (non-syntax text is checked)
cmd("syntax spell toplevel")

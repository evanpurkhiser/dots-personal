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
vim.api.nvim_set_hl(0, "VertSplit", { link = "FloatBorder" })
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

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Enable spell check in git commit messages",
  group = vim.api.nvim_create_augroup("CommitSpellCheck", {}),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    set.spell = true
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("YankHighlight", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 800 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Open help to the right",
  group = vim.api.nvim_create_augroup("HelpWindow", {}),
  pattern = "help",
  command = "wincmd L",
})

-- Make searches nice and in-your-face
vim.api.nvim_set_hl(0, "Search", { link = "Todo" })

--- Spelling should be done at the toplevel (non-syntax text is checked)
cmd("syntax spell toplevel")

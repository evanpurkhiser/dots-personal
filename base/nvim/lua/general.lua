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

exec(
  [[
  highlight Search ctermbg=8 ctermfg=10

  highlight SpecialKey ctermbg=8 ctermfg=10

  " More in-your-face spelling highlights
  highlight SpellBad cterm=bold ctermfg=7 ctermbg=2

  " Clear the background of the sign column (guter)
  highlight clear SignColumn

  " Spelling should be done at the toplevel (non-syntax text is checked)
  syntax spell toplevel
  ]],
  false
)

exec(
  [[
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --follow --color never ' .
    \   '-g "!static/dist/**/*" '.
    \   '-g "!bin/yarn" '.
    \   '-g "!CHANGES" '.
    \   '-g "!stats.json" ' .
    \   '-g "!static/images/*" ' .
    \   '-g "!static/images/**/*" ' .
    \   '-g "!static/app/icons/*" ' .
    \   '-g "!static/less/debugger*" ' .
    \   '-g "!static/vendor/*" ' .
    \   '-g "!src/sentry/static/sentry/**/*" ' .
    \   '-g "!**/south_migrations/*" ' .
    \   '-g "!src/sentry/static/sentry/dist/**/*" ' .
    \   '-g "!src/sentry/static/sentry/images/*" ' .
    \   '-g "!src/sentry/static/sentry/images/**/*" ' .
    \   '-g "!src/sentry/static/sentry/app/icons/*" ' .
    \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/closedSymbol.jsx" ' .
    \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/detectedSymbol.jsx" ' .
    \   '-g "!src/sentry/static/sentry/less/debugger*" ' .
    \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
    \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
    \   '-g "!tests/js/**/*.snap" ' .
    \   '-g "!tests/fixtures/*" ' .
    \   '-g "!tests/fixtures/**/*" ' .
    \   '-g "!tests/*/fixtures/*" ' .
    \   '-g "!tests/**/fixtures/*" ' .
    \   '-g "!tests/**/snapshots/**/*" ' .
    \   '-g "!tests/sentry/lang/*/fixtures/*" ' .
    \   '-g "!tests/sentry/lang/**/*.map" ' .
    \   '-g "!tests/sentry/grouping/**/*" ' .
    \   '-g "!tests/sentry/db/*" ' .
    \   '-g "!src/sentry/locale/**/*" ' .
    \   '-g "!src/sentry/data/**/*" ' .
    \   '-g "!src/debug_toolbar/**/*" ' .
    \   shellescape(<q-args>), 1,
    \   <bang>1 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>1)
  nnoremap <leader>f :Rg<CR>
  ]],
  false
)

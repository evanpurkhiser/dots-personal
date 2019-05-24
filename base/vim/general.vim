scriptencoding utf-8

" General vim configurations
"
" vim-sensible takes care of most of the really common configuration changes
" for us. These configurations are more personal and to my liking.

set background=dark
silent! colorscheme solarized

" Vertical split coloring
highlight VertSplit ctermbg=8 ctermfg=black
set fillchars+=vert:│

set number     " Show line numbers
set nowrap     " Don't visually wrap lines
set noshowmode " Don't show mode (--INSERT--, etc)
set cursorline " Highlight the current cursor line
set hidden     " Allow buffer switching without having to save
set list       " Show non-printable characters
set hlsearch   " Highlight searched text
set ignorecase " Ignore case when searching
set smartcase  " Don't ignore case when using uppercase in a search
set confirm    " Ask for confirmation when closing unsaved files

" Incremental scrolling
set sidescroll=1

" Remove o option from format options (o caused issuing o/O on a comment line
" to start a new comment line, undesired by me)
set formatoptions-=o

" Don't autoselect the first entry when doing completion
set completeopt=longest,menuone

" Disable backup files
set nobackup nowritebackup noswapfile

" Tab configurations
set smartindent expandtab tabstop=2 shiftwidth=2

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" Better list characters
set listchars=tab:\›\ ,trail:-
highlight SpecialKey ctermbg=8 ctermfg=10

" More in-your-face spelling highlights
highlight SpellBad cterm=bold ctermfg=7 ctermbg=1

" Enable spell checking on git commits
augroup commit_sp
  au!
  au BufRead COMMIT_EDITMSG setlocal spell
augroup END

" Spelling should be done at the toplevel (non-syntax text is checked)
syntax spell toplevel

" Clear the background of the sign column (guter)
highlight clear SignColumn

" Disable netrw
let g:loaded_netrwPlugin = 1

" Airline plugin configuration
" ----------------------------
let g:airline_left_sep = ''                    " Hide separators
let g:airline_right_sep = ''                   " -
let g:airline#extensions#syntastic#enabled = 0 " No syntastic

let g:airline_section_y = ''           " Hide file format / encoding
let g:airline_section_z = '%2c% %3p%%' " Only show scroll percentage

" Remove the modified indicator from the file
silent! call airline#parts#define_raw('file', '%f')

" Shorter airline whitespace warning message
let g:airline#extensions#whitespace#trailing_format = 'ws:%s'

" Vim airline tabline config
" --------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" Override some solarized theme settings
let g:airline_solarized_dark_inactive_border = 1

silent! call airline#themes#solarized#refresh()
let g:airline#themes#mine#palette = get(g:, 'airline#themes#solarized#palette', {})

let g:airline#themes#mine#palette.tabline = {
      \ 'airline_tabfill': ['', '', 07, 00],
      \ 'airline_tabhid':  ['', '', 10, 00],
      \ 'airline_tab':     ['', '', 14, 08],
      \ 'airline_tabsel':  ['', '', 00, 15],
      \ 'airline_tabmod':  ['', '', 07, 01],
      \ }

let g:airline_theme = 'mine'

" Vim indent line configuration
" -----------------------------
let g:indentLine_char = '│'
let g:indentLine_color_term = 0

" Bufkill configuration
" ---------------------
let g:BufKillActionWhenBufferDisplayedInAnotherWindow = 'kill'
let g:BufKillCreateMappings = 0

" Deoplete and language server completeion
" ----------------------------------------
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
      \ 'rust':           ['rustup', 'run', 'nightly', 'rls'],
      \ 'javascript':     ['javascript-typescript-stdio'],
      \ 'javascript.jsx': ['javascript-typescript-stdio'],
      \ 'python':         ['pyls'],
      \ 'go':             ['go-langserver'],
      \ }

" Neomake will handle linting
let g:LanguageClient_diagnosticsEnable = 0

" Deoplete / completion debugging
let s:lc_debug = 0
if  s:lc_debug
  let g:LanguageClient_loggingLevel = 'INFO'
  let g:LanguageClient_loggingFile  = expand('~/LanguageClient.log')
  let g:LanguageClient_serverStderr = expand('~/LanguageServer.log')
  call deoplete#enable_logging('INFO', expand('deoplete.log'))
endif

" Disable vim-rooter echoing
let g:rooter_silent_chdir = 1

" Godef is much faster than guru ATM
let g:go_def_mode = 'godef'

" Do not create mappings for buffer killing
let g:BufKillCreateMappings = 0

" Open help windows on the right in a vertial split
augroup help_win
  au!
  au FileType help wincmd L
augroup END

" Neomake configuration
" ---------------------
silent! call neomake#configure#automake('nrwi', 500)

let g:neomake_error_sign   = {'text': '-', 'texthl': 'NeomakeErrorSign'}
let g:neomake_info_sign    = {'text': '-', 'texthl': 'NeomakeInfoSign'}
let g:neomake_warning_sign = {'text': '-', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '-', 'texthl': 'NeomakeMessageSign'}

hi NeomakeErrorSign   ctermfg=01 ctermbg=01
hi NeomakeWarningSign ctermfg=03 ctermbg=03
hi NeomakeInfoSign    ctermfg=04 ctermbg=04
hi NeomakeMessageSign ctermfg=07 ctermbg=07

" Neoformat configuration
" -----------------------
let g:neoformat_run_all_formatters = 1
let g:neoformat_enabled_python = ['autopep8']
let g:neoformat_enabled_javascript = ['eslint', 'prettier']
let g:neoformat_enabled_go = ['gofmt']
let g:neoformat_enabled_yaml = []

" Use gofmt -s
let g:neoformat_go_gofmt = {
      \ 'exe': 'gofmt',
      \ 'args': ['-s'],
      \ 'stdin': 1
      \ }

" format on save.
" Silence E790: https://vi.stackexchange.com/a/13401/1787
if match(&runtimepath, 'neoformat') != -1
  augroup fmt
    au!
    au BufWritePre * try | undojoin | catch /^Vim\%((\a\+)\)\=:E790/ | finally | Neoformat | endtry
  augroup END
endif

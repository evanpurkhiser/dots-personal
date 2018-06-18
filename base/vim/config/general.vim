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

" Spelling should be done at the toplevel (non-syntax text is checked)
syntax spell toplevel

" Enable spell checking on git commits
autocmd BufRead COMMIT_EDITMSG setlocal spell

" Disable backup files
set nobackup nowritebackup noswapfile

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" Clear the background of the sign column (guter)
highlight clear SignColumn

" netrw configuration
let g:netrw_banner = 0     " Don't show help banner
let g:netrw_dirhistmax = 0 " Don't write history file

" Airline plugin configuration
" ----------------------------
let g:airline_left_sep = ''                    " Hide separators
let g:airline_right_sep = ''                   " -
let g:airline#extensions#syntastic#enabled = 0 " No syntastic

let g:airline_section_y = ""           " Hide file format / encoding
let g:airline_section_z = "%2c% %3p%%" " Only show scroll percentage

" Remove the modified indicator from the file
call airline#parts#define_raw('file', '%f')

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

autocmd User AirlineAfterInit
  \ highlight airline_tabfill ctermbg=0 ctermfg=7 |
  \ highlight airline_tabhid ctermbg=0 ctermfg=10 |
  \ highlight airline_tab ctermbg=8 ctermfg=14    |
  \ highlight airline_tabsel ctermbg=15 ctermfg=0 |
  \ highlight airline_tabmod ctermbg=1 ctermfg=7

" Vim indent line configuration
" -----------------------------
let g:indentLine_char = '│'
let g:indentLine_color_term = 0

" Better list characters
highlight SpecialKey ctermbg=8 ctermfg=10
set lcs=tab:\›\ ,trail:-

" Disable vim-rooter echoing
let g:rooter_silent_chdir = 1

" Godef is much faster than guru ATM
let g:go_def_mode = 'godef'

" Load snippets directory
let g:UltiSnipsSnippetDirectories=["UtiSnips", "snips"]

let g:UltiSnipsExpandTrigger = "<c-f>"

" Do not create mappings for buffer killing
let g:BufKillCreateMappings = 0

" Don't autoselect the first entry when doing completion
set completeopt=longest,menuone

" Open help windows on the right in a vertial split
autocmd FileType help wincmd L

" Quit when nerdtree is the very last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | quit | endif

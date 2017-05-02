" General vim configurations
"
" vim-sensible takes care of most of the really common configuration changes
" for us. These configurations are more personal and to my liking.

set background=dark
silent! colorscheme solarized

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

" Disable backup files
set nobackup nowritebackup noswapfile

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" Clear the background of the sign column (guter)
highlight clear SignColumn

" netrw plugin configuration
let g:netrw_banner = 0     " Don't show help banner
let g:netrw_dirhistmax = 0 " Don't write history file

" airline plugin configuration
let g:airline_left_sep = ''                    " Hide separators
let g:airline_right_sep = ''                   " -
let g:airline_detect_modified = 0              " Don't change color for modified files
let g:airline#extensions#syntastic#enabled = 0 " No syntastic

let g:airline_section_y = ""      " Hide file format / encoding
let g:airline_section_z = "%2c% %3p%%" " Only show scroll percentage

" Shorter airline whitespace warning message
let g:airline#extensions#whitespace#trailing_format = 'ws:%s'

" bufferline plugin configuration
let g:bufferline_echo = 0       " Don't echo buffer list to command line
let g:bufferline_show_bufnr = 0 " Don't show buffer number

" automagically expand newlines in paired items
" See: http://stackoverflow.com/questions/4477031/vim-auto-indent-with-newline
let g:delimitMate_expand_cr = 1

" Vim indent line configuration
let g:indentLine_char = '│'
let g:indentLine_color_term = 0

" Better list characters
highlight SpecialKey ctermbg=8 ctermfg=10
set lcs=tab:\›\ ,trail:-

" Error checking
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Don't rebuild go projects with syntastic
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']

" Better syntastic symbols
let g:syntastic_error_symbol = '✕'
let g:syntastic_warning_symbol = '✕'
let g:syntastic_style_error_symbol = '✕'
let g:syntastic_style_warning_symbol = '✕'

" Use eslint for javascript
let g:syntastic_javascript_checkers = ['eslint']

" Godef is much faster than guru ATM
let g:go_def_mode = 'godef'

" Load snippets directory
let g:UltiSnipsSnippetDirectories=["UtiSnips", "snips"]

let g:UltiSnipsExpandTrigger = "<c-f>"

" Don't autoselect the first entry when doing completion
set completeopt=longest,menuone

" automagically add semicolons when closing parenthesis
autocmd FileType c,c++,perl,php let b:delimitMate_eol_marker = ";"

" Enable spell checking on git commits
autocmd BufRead COMMIT_EDITMSG setlocal spell

" Open help windows on the right in a vertial split
autocmd FileType help wincmd L

" Quit when nerdtree is the very last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | quit | endif

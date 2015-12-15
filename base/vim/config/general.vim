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
set autochdir  " Always stay in the working directory of the open file

" Spelling should be done at the toplevel (non-syntax text is checked)
syntax spell toplevel

" Disable backup files
set nobackup nowritebackup noswapfile

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" netrw plugin configuration
let g:netrw_banner = 0     " Don't show help banner
let g:netrw_dirhistmax = 0 " Don't write history file

" airline plugin configuration
let g:airline_left_sep = ''                    " Hide separators
let g:airline_right_sep = ''                   " -
let g:airline_detect_modified = 0              " Don't change color for modified files
let g:airline#extensions#syntastic#enabled = 0 " No syntastic

" bufferline plugin configuration
let g:bufferline_echo = 0 " Don't echo buffer list to command line

" automagically expand newlines in paired items
" See: http://stackoverflow.com/questions/4477031/vim-auto-indent-with-newline
let g:delimitMate_expand_cr = 1

" Configure Command-T
let g:CommandTMatchWindowReverse = 1
let g:CommandTSmartCase = 0
highlight! link CommandTCharMatched Error

" Vim indent line configuration
let g:indentLine_char = '│'
let g:indentLine_color_term = 0

" Don't rebuild go projects with syntastic
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']

" Load snippets directory
let g:UltiSnipsSnippetDirectories=["UtiSnips", "snips"]

" Supertab should use context for completion
" Allows supertab to work with go-completion and ultisnip
let g:SuperTabDefaultCompletionType = "context"

" automagically add semicolons when closing parenthesis
autocmd FileType c,c++,perl,php let b:delimitMate_eol_marker = ";"

" Enable spell checking on git commits
autocmd BufRead COMMIT_EDITMSG setlocal spell

" Open help windows on the right in a vertial split
autocmd FileType help wincmd L

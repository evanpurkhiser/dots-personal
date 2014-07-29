" General vim configurations
"
" vim-sensible takes care of most of the really common configuration changes
" for us. These configurations are more personal and to my liking.

colorscheme hybrid

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

" Disable backup files
set nobackup nowritebackup noswapfile

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" netrw: Hide banner and dsable history file
let g:netrw_banner=0
let g:netrw_dirhistmax = 0

" Enable spell checking on git commits
autocmd BufRead COMMIT_EDITMSG setlocal spell
" Vundles
"
" Load in all vundle installed plugins

filetype off
call vundle#begin("$XDG_CONFIG_HOME/vim/bundle")

" Let vundle manage itself
Plugin 'gmarik/vundle'

" Sensible options that should always be set
Plugin 'tpope/vim-sensible'

" Map common readline bindings in insert and command mode
Plugin 'tpope/vim-rsi.git'

" Mappings for surrounding text
Plugin 'tpope/vim-surround'

" Automagically detect the indenting style in the file
Plugin 'tpope/vim-sleuth'

" Exchange two sections of text with ease (cxi)
Plugin 'tommcdo/vim-exchange'

" Automatically enable 'paste' when pasting from a supporting terminal
" http://www.xfree86.org/current/ctlseqs.html#Bracketed Paste Mode
Plugin 'ConradIrwin/vim-bracketed-paste'

" Do completion with <Tab> instead of <C-P>
Plugin 'ervandew/supertab'

" Fuzzy file / buffer / mru finder
Plugin 'wincent/Command-T'

" Makes alignment a breeze (:Tab)
Plugin 'godlygeek/tabular'

" List buffers in the status line
Plugin 'bling/vim-bufferline'

" Prettier status line
Plugin 'bling/vim-airline'

" Close matching pairs automagically with a few other neat features
Plugin 'Raimondi/delimitMate'

" Color schemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'w0ng/vim-hybrid'
Plugin 'chriskempson/base16-vim'

" Syntax aware
Plugin 'vim-scripts/nginx.vim'
Plugin 'juvenn/mustache.vim'
Plugin 'evidens/vim-twig'
Plugin 'StanAngeloff/php.vim'
Plugin '2072/PHP-Indenting-for-VIm'

" Syntax checking
Plugin 'scrooloose/syntastic'

call vundle#end()
filetype plugin indent on

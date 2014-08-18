" Vundles
"
" Load in all vundle installed plugins

filetype off
call vundle#rc("$XDG_CONFIG_HOME/vim/bundle")

" Let vundle manage itself
Bundle 'gmarik/vundle'

" Sensible options that should always be set
Bundle 'tpope/vim-sensible'

" Map common readline bindings in insert and command mode
Bundle 'tpope/vim-rsi.git'

" Mappings for surrounding text
Bundle 'tpope/vim-surround'

" Automagically detect the indenting style in the file
Bundle 'tpope/vim-sleuth'

" Exchange two sections of text with ease (cxi)
Bundle 'tommcdo/vim-exchange'

" Automatically enable 'paste' when pasting from a supporting terminal
" http://www.xfree86.org/current/ctlseqs.html#Bracketed Paste Mode
Bundle 'ConradIrwin/vim-bracketed-paste'

" Do completion with <Tab> instead of <C-P>
Bundle 'ervandew/supertab'

" Fuzzy file / buffer / mru finder
Bundle 'ctrlpvim/ctrlp.vim'

" Makes alignment a breeze (:Tab)
Bundle 'godlygeek/tabular'

" List buffers in the status line
Bundle 'bling/vim-bufferline'

" Prettier status line
Bundle 'bling/vim-airline'

" Close matching pairs automagically with a few other neat features
Bundle 'Raimondi/delimitMate'

" Color schemes
Bundle 'altercation/vim-colors-solarized'
Bundle 'w0ng/vim-hybrid'

" Syntax highlighting
Bundle 'vim-scripts/nginx.vim'
Bundle 'juvenn/mustache.vim'
Bundle 'evidens/vim-twig'

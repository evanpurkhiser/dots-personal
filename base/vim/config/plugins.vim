" Plugins

let g:plug_window = 'enew'

call plug#begin("$XDG_CONFIG_HOME/vim/plugged")

" Sensible options that should always be set
Plug 'tpope/vim-sensible'

" Map common readline bindings in insert and command mode
Plug 'tpope/vim-rsi'

" Mappings for surrounding text
Plug 'tpope/vim-surround'

" Automagically detect the indenting style in the file
Plug 'tpope/vim-sleuth'

" Exchange two sections of text with ease (cxi)
Plug 'tommcdo/vim-exchange'

" Automatically enable 'paste' when pasting from a supporting terminal
" http://www.xfree86.org/current/ctlseqs.html#Bracketed Paste Mode
Plug 'ConradIrwin/vim-bracketed-paste'

" Do completion with <Tab> instead of <C-P>
Plug 'ervandew/supertab'

" Fuzzy file / buffer / mru finder
Plug 'wincent/Command-T', { 'do': 'cd ruby/command-t && ruby extconf.rb && make' }

" Makes alignment a breeze (:Tab)
Plug 'godlygeek/tabular'

" List buffers in the status line
Plug 'bling/vim-bufferline'

" Prettier status line
Plug 'bling/vim-airline'

" Close matching pairs automagically with a few other neat features
Plug 'Raimondi/delimitMate'

" Color schemes
Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'
Plug 'chriskempson/base16-vim'

" Syntax aware
Plug 'vim-scripts/nginx.vim'
Plug 'juvenn/mustache.vim'
Plug 'evidens/vim-twig'
Plug 'StanAngeloff/php.vim'
Plug '2072/PHP-Indenting-for-VIm'

" Syntax checking
Plug 'scrooloose/syntastic'

call plug#end()

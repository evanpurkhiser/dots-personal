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

" Amazing completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Fuzzy file / buffer / mru finder
Plug 'wincent/Command-T', { 'do': 'cd ruby/command-t && ruby extconf.rb && make' }

" Makes alignment a breeze (:Tab)
Plug 'godlygeek/tabular'

" List buffers in the status line
Plug 'bling/vim-bufferline'

" Prettier status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Close matching pairs automagically with a few other neat features
Plug 'Raimondi/delimitMate'

" Adds argument text objects
Plug 'b4winckler/vim-angry'

" Show vertical lines for tab alignment
Plug 'Yggdroot/indentLine'

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
Plug 'pearofducks/ansible-vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'saltstack/salt-vim'

" Go awareness
Plug 'fatih/vim-go'

" ReStructured text table helper
Plug 'nvie/vim-rst-tables', { 'do': 'python build.py' }

" File browsing
Plug 'scrooloose/nerdtree'

" Syntax checking
Plug 'scrooloose/syntastic'

" Full project text search
Plug 'mileszs/ack.vim'

call plug#end()

set nocompatible

" Follow XDG directory specifications
let $MYVIMRC="$XDG_CONFIG_HOME/nvim/vimrc"
set directory=$XDG_CACHE_HOME/nvim
set viminfo+=n$XDG_CACHE_HOME/viminfo
set runtimepath=$XDG_CONFIG_HOME/nvim,$XDG_CONFIG_HOME/nvim/after,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$XDG_CONFIG_HOME/nvim/bundle/vundle

runtime plugins.vim
runtime utility.vim
runtime general.vim
runtime mapping.vim
runtime filetypes.vim

" Load other config files
for config in split(globpath('$XDG_CONFIG_HOME/nvim/config.d', '*.vim'), '\n')
    execute('source '.config)
endfor

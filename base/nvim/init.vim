set directory=$XDG_CACHE_HOME/nvim
set viminfo+=n$XDG_CACHE_HOME/viminfo

lua require('plugins')
lua require('general')

runtime utility.vim
runtime general.vim
runtime mapping.vim

" Load other config files
for config in split(globpath('$XDG_CONFIG_HOME/nvim/config.d', '*.vim'), '\n')
    execute('source '.config)
endfor

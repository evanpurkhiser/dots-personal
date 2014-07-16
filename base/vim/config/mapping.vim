" Key mappings
"
" My personal mappings for various commands and key combinations

" Add a way to write a file as sudo
cmap w!! w !sudo tee > /dev/null %

" Remap Ctrl+C to be the same as escape without telling us to use :q to quit
nnoremap <C-c> <silent> <ESC>


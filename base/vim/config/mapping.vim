" Key mappings
"
" My personal mappings for various commands and key combinations

" Add a way to write a file as sudo
cmap w!! w !sudo tee > /dev/null %

" Remap Ctrl+C to be the same as escape without telling us to use :q to quit
nnoremap <C-c> <silent> <ESC>

" Disable EX mode
map Q <Nop>

""" Buffer Managment
nnoremap <silent>       <Tab>   :bnext<CR>
nnoremap <silent>       <S-Tab> :bprev<CR>
nnoremap <expr><silent> <C-q>   ':confirm '.(NoBuffersOpen() ? 'quit' : 'bdelete').'<CR>'

""" Tabularizatins
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" Don't move on *
nnoremap <silent> * :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" Source line and selection in vim
vnoremap <leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

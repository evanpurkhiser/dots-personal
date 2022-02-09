" Key mappings
"
" My personal mappings for various commands and key combinations

" Smart save: Attempt to use SudoWrite if the file isn't writeable
nnoremap <expr> <C-s>
  \ expand('%') != '' && getfperm(expand('%')) != '' && !filewritable(expand('%')) ?
  \ ':write suda://%<CR>' : ':write<CR>'

" Remap Ctrl+C to be the same as escape without telling us to use :q to quit.
" the 'r' command is special cased to a NOP.
nnoremap r<C-c> <NOP>
nnoremap  <C-c> <NOP>
inoremap  <C-c> <Esc>
nnoremap  <C-c> <Esc>

" Disable EX mode
map Q <Nop>

""" Buffer Managment
nnoremap <silent>       <C-]>  :bnext<CR>
nnoremap <silent>       <C-[>  :bprev<CR>
nnoremap <silent><expr> <C-q> ':confirm '.(NoBuffersOpen() ? 'quit' : 'BD').'<CR>'

""" Window movment
nnoremap <Tab> <C-W><C-w>
nnoremap <S-Tab> <C-W><S-W>

""" fzf
nmap <Leader><Leader> :GFiles --exclude-standard --cached --others<CR>
nmap <Leader>p        :Files<CR>
nmap <Leader>b        :Buffers<CR>

" Quick system copy and paste
nmap <Leader>y "+y
nmap <Leader>Y "+Y
vmap <Leader>y "+y

" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" Yank file path
nmap <silent><Leader>yp :let @+ = expand('%:p')<CR>:echom "Path copied to system clipboard"<CR>

" Clear search / quickfix
nnoremap <silent><C-l> :nohlsearch<CR>:cclose<CR>:lclose<CR>:call clearmatches()<CR>

" Remove space
nmap <Leader>ds dipO<Esc>

" Don't move on *
nnoremap <silent> *
  \ :let stay_star_view = winsaveview()<CR>*
  \ :call winrestview(stay_star_view)<CR>

" Search for selected text
vnoremap <silent> * :<C-U>
  \ let old_reg = getreg('"')<Bar>
  \ let old_regtype = getregtype('"')<Bar>
  \ let stay_star_view = winsaveview()<CR>
  \ gvy/<C-R><C-R>=substitute(
  \ escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \ gV:call setreg('"', old_reg, old_regtype)<CR>
  \ :call winrestview(stay_star_view)<CR>

" Source line and selection in vim
vnoremap <leader>S y:execute @@<CR>:echo 'Sourced selection'<CR>
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line'<CR>

" Repeat the last executed macro
nnoremap , @@

" Use tab like you would expect
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ga <Plug>(coc-codeaction)
vmap <silent> ga <Plug>(coc-codeaction-selected)

" Trigger info window
nnoremap <silent> <Space> :call CocActionAsync('doHover')<CR>

" Diagnostic navigation
nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)

" Show signature help when jumping between placeholders
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

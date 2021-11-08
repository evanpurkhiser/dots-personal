" File type specific configurations
" 
" Mostly consisting of Auto commands applied when matching files are opened

augroup my_fts
  au BufRead,BufNewFile *.md        set filetype=markdown
  au BufRead,BufNewFile *.rt        set filetype=html
  au BufRead,BufNewFile *.raml      set filetype=yaml
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
  au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* set filetype=nginx
augroup END

" File type specific configurations
" 
" Mostly consisting of Auto commands applied when matching files are opened

au BufRead,BufNewFile *.md        set filetype=markdown
au BufRead,BufNewFile *.rt        set filetype=html
au BufRead,BufNewFile *.raml      set filetype=yaml
au BufRead,BufNewFile Vagrantfile set filetype=ruby
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* set filetype=nginx

au BufRead,BufNewFile *.go set noexpandtab

" High quality async completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

let language_client_install = [
    \ 'bash install.sh',
    \ 'yarn global add javascript-typescript-langserver',
    \ 'yarn global add bash-language-server',
    \ 'pip install python-language-server']

" Language completion
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': join(language_client_install, ' && '),
    \ }

" Currently there is no language client that supports go-completion. Use
" deoplete-go for this job. We can still rely on sourcegraph/go-langserver for
" goto defs etc.
Plug 'zchee/deoplete-go', { 'do': 'make'}

" Linting + Fixing support
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

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

" Linting support
Plug 'neomake/neomake'

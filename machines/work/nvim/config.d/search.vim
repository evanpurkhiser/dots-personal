set grepprg=rg\ --vimgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --follow --color never ' .
  \   '-g "!static/dist/**/*" '.
  \   '-g "!bin/yarn" '.
  \   '-g "!CHANGES" '.
  \   '-g "!stats.json" ' .
  \   '-g "!static/images/*" ' .
  \   '-g "!static/images/**/*" ' .
  \   '-g "!static/app/icons/*" ' .
  \   '-g "!static/less/debugger*" ' .
  \   '-g "!static/vendor/*" ' .
  \   '-g "!src/sentry/static/sentry/**/*" ' .
  \   '-g "!**/south_migrations/*" ' .
  \   '-g "!src/sentry/static/sentry/dist/**/*" ' .
  \   '-g "!src/sentry/static/sentry/images/*" ' .
  \   '-g "!src/sentry/static/sentry/images/**/*" ' .
  \   '-g "!src/sentry/static/sentry/app/icons/*" ' .
  \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/closedSymbol.jsx" ' .
  \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/detectedSymbol.jsx" ' .
  \   '-g "!src/sentry/static/sentry/less/debugger*" ' .
  \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
  \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
  \   '-g "!tests/js/**/*.snap" ' .
  \   '-g "!tests/fixtures/*" ' .
  \   '-g "!tests/fixtures/**/*" ' .
  \   '-g "!tests/*/fixtures/*" ' .
  \   '-g "!tests/**/fixtures/*" ' .
  \   '-g "!tests/**/snapshots/**/*" ' .
  \   '-g "!tests/sentry/lang/*/fixtures/*" ' .
  \   '-g "!tests/sentry/lang/**/*.map" ' .
  \   '-g "!tests/sentry/grouping/**/*" ' .
  \   '-g "!tests/sentry/db/*" ' .
  \   '-g "!src/sentry/locale/**/*" ' .
  \   '-g "!src/sentry/data/**/*" ' .
  \   '-g "!src/debug_toolbar/**/*" ' .
  \   shellescape(<q-args>), 1,
  \   <bang>1 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>1)
nnoremap <leader>f :Rg<CR>

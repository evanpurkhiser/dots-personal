" Utility functions
"
" This contains various utility functions that may be used throughout my
" vim configuration. Many of these are probably used by mappings

" Test if there is only an empty buffer in the buffer list
function NoBuffersOpen()
    let l:bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    return len(bufs) == 1 && empty(bufname(bufs[0]))
endfunction

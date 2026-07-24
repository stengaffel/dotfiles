let g:plantuml_jar = ''
let g:browser_binary = ''

if !empty(g:plantuml_jar) && !empty(g:browser_binary)
    nnoremap <leader>pp :execute '!java -jar ' . g:plantuml_jar . ' -tsvg ' . expand("%:p")<cr>
    nnoremap <leader>po :execute '!' . g:browser_binary . ' ' . expand("%:p:r") . '.svg &'<cr>
endif

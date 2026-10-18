function! s:open_scratch_menu(options, callback_func) abort
    let l:origin_winid = win_getid()

    if exists('g:scratch_menu') && win_id2win(g:scratch_menu.scratch_winid) > 0
        call CloseScratchWindow(0)
    endif
    botright new

    setlocal filetype=mypopup
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodified

    setlocal number
    setlocal relativenumber
    setlocal cursorline

    let g:scratch_menu = {
        \ 'origin_winid': l:origin_winid,
        \ 'scratch_winid': win_getid(),
        \ 'options': s:initialize_options(a:options),
        \ 'filtered_options': [],
        \ 'callback_func': a:callback_func,
        \ 'state': {"max_len": -1,
        \           "one_line_per_file": 0,
        \           "use_full_filepaths": 0}
        \ }

    call UpdateMenu()

    let l:height = max([20, min([len(a:options), 30])])
    execute 'resize ' . l:height

    nnoremap <buffer> <silent> <cr> :call SubmitSelection()<cr>
    nnoremap <buffer> <silent> q :call CloseScratchWindow(1)<cr>
    nnoremap <buffer> <silent> f
        \ :let g:scratch_menu.state.one_line_per_file = (g:scratch_menu.state.one_line_per_file+1) % 2 \|
        \ :call UpdateMenu()<cr>
    nnoremap <buffer> <silent> p
        \ :let g:scratch_menu.state.use_full_filepaths = (g:scratch_menu.state.use_full_filepaths+1) % 2 \|
        \ :call UpdateMenu()<cr>
endfunction

function! s:initialize_options(options) abort
    function! s:build_option(_, val) abort
        let l:matches = matchlist(a:val, '\v^([^:]*/([^:/]+)):([0-9]+):%([0-9]+:)?(.*)')
        return {
            \ 'full_option': a:val,
            \ 'full_filepath': l:matches[1],
            \ 'filename': l:matches[2],
            \ 'linenr': str2nr(l:matches[3]),
            \ 'matched_line': trim(l:matches[4]),
            \ }
    endfunction
    let l:new_options = map(a:options, function('s:build_option'))
    call sort(l:new_options, {a, b ->
        \ a.filename < b.filename ? -1 : a.filename > b.filename ? 1 :
        \ a.linenr < b.linenr ? -1 : a.linenr > b.linenr ? 1 : 0
        \ })
    return l:new_options
endfunction

function! UpdateMenu() abort
    let s:location_format_pattern = '\v([^:/]+:%([0-9]+:){1,2})'
    if g:scratch_menu.state.use_full_filepaths
        let s:location_format_pattern = '\v^([^:]+:%([0-9]+:){1,2})'
    endif
    function! s:format_line(idx, val) abort
        let matches = matchlist(a:val.full_option, s:location_format_pattern . '(.*)')
        return printf('%-' . (g:scratch_menu.state.max_len+5) . 's', matches[1]) . trim(matches[2])
    endfunction
    let g:scratch_menu.state.max_len = max(map(copy(g:scratch_menu.options), {idx, val ->
        \ strdisplaywidth(matchstr(val.full_option, s:location_format_pattern))}))
    let l:options = copy(g:scratch_menu.options)
    if g:scratch_menu.state.one_line_per_file
        function! s:filter_duplicate_filepaths(seen, val) abort
            let l:key = string(a:val.full_filepath)
            if has_key(a:seen, l:key)
                return 0
            endif
            let a:seen[l:key] = 1
            return 1
        endfunction
        let l:seen_filepaths = {}
        call filter(l:options, {_, val -> s:filter_duplicate_filepaths(l:seen_filepaths, val)})
    endif
    let g:scratch_menu.filtered_options = deepcopy(l:options)
    call map(l:options, function('s:format_line'))
    call deletebufline('%', 2, '$')
    call setline(1, l:options)
endfunction

function! CloseScratchWindow(return_to_origin) abort
    if a:return_to_origin
        call win_gotoid(g:scratch_menu.origin_winid)
    endif
    call win_execute(g:scratch_menu.scratch_winid, 'bwipeout!')
endfunction

function! SubmitSelection() abort
    let l:line = line('.')
    let l:selection = g:scratch_menu.filtered_options[l:line - 1]
    let l:Callback = g:scratch_menu.callback_func

    if win_gotoid(g:scratch_menu.origin_winid)
        call win_execute(g:scratch_menu.scratch_winid, 'bwipeout!')
        call l:Callback(l:selection.full_option)
    endif
endfunction

function! s:extract_file_location(option_str) abort
    let l:matches = matchlist(a:option_str, '\v^([^:]+):([0-9]+):([0-9]+)')
    if empty(l:matches)
        let l:matches = matchlist(a:option_str, '\v^([^:]+):([0-9]+)')
    endif
    if empty(l:matches)
        throw 'Could not extract file location from option: ' . a:option_str
    endif
    return {
        \ 'filename': l:matches[1],
        \ 'line': l:matches[2],
        \ 'column': len(l:matches) > 3 ? l:matches[3] : "",
        \ }
endfunction

function! s:scratch_open_file(option_str) abort
    let l:file_location = s:extract_file_location(a:option_str)
    execute 'edit ' . l:file_location.filename

    if file_location.line
        call cursor(file_location.line, file_location.column)
    endif
endfunction

function! FindUsages(pattern) abort
    let l:command = ""
    if executable('rg')
        let l:command = "rg --hidden --vimgrep -wF '" . a:pattern . "'"
    else
        let l:command = "grep -EInr '" . a:pattern . "'"
    endif
    let l:options = systemlist(l:command)
    if empty(l:options)
        throw 'Could not find matches for pattern: ' . a:pattern
    endif
    echom ' ' . l:command
    call s:open_scratch_menu(l:options, function('s:scratch_open_file'))
endfunction


" ========== AUTO COMMANDS ==========
function! s:apply_basic_syntax_highlighting() abort
    syntax match MyPopupFileName /\v^\zs[^:]+/ nextgroup=MyPopupLineNr
    highlight link MyPopupFileName Boolean

    syntax match MyPopupLineNr /\v:[0-9]+:/ contained nextgroup=MyPopupColNr
    highlight link MyPopupLineNr String

    syntax match MyPopupColNr /\v[0-9]+\ze:/ contained
    highlight link MyPopupColNr Constant
endfunction

function! s:setup_footer_update() abort
    function! s:update_footer() abort
        let &l:statusline = '%#HLStatusLineNormal# '
            \ . matchstr(g:scratch_menu.filtered_options[line('.')-1].full_option, '\v^[^:]+')
            \ . '%=   %5.l/%L %P, %3.c '
        redrawstatus
    endfunction
    autocmd CursorMoved <buffer> call s:update_footer()
endfunction
augroup mypopup_footer_update
    autocmd!
augroup END

augroup mypopup_augroup
    autocmd!
    autocmd FileType mypopup call s:apply_basic_syntax_highlighting()
    autocmd FileType mypopup call s:setup_footer_update()
augroup END
" ===================================

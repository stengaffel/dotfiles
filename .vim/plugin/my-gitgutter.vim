highlight SignAdd guifg=#50fa7b guibg=#44475a
highlight SignDel guifg=#ff5555 guibg=#44475a
highlight SignMod guifg=#ffb86c guibg=#44475a

call sign_define('GitAddSign', {'text': '+', 'texthl': 'SignAdd'})
call sign_define('GitDelSign', {'text': '-', 'texthl': 'SignDel'})
call sign_define('GitModSign', {'text': '~', 'texthl': 'SignMod'})

let s:sign_group = 'my_sign_group'

function! UpdateDiffSigns() abort
    let l:git_prefix = 'git -C ' . expand('%:p:h')
    if system(l:git_prefix . ' rev-parse --is-inside-work-tree') !~ 'true'
        return
    endif
    call sign_unplace(s:sign_group, {'buffer': bufnr('%')})
    let l:diff_str_list = systemlist(l:git_prefix . ' diff -U0 ' . expand('%:p'))
    for l:line in l:diff_str_list
        if l:line =~ '\v^\@\@'
            let l:match = matchlist(l:line, '\v\+([0-9]+)%(\,([0-9]+))?')
            let l:start_line = str2nr(l:match[1])
            let l:count = empty(l:match[2]) ? 1 : str2nr(l:match[2])

            let l:match_del = matchlist(l:line, '\v\-([0-9]+)%(\,([0-9]+))?')
            let l:start_line_del = str2nr(l:match_del[1])
            let l:count_del = empty(l:match_del[2]) ? 1 : str2nr(l:match_del[2])

            if l:count == 0
                let l:target_line = max([1, l:start_line])
                call sign_place(0, s:sign_group, 'GitDelSign', bufnr('%'), {'lnum': l:target_line})
            elseif l:count_del == 0
                for l:i in range(0, l:count-1)
                    call sign_place(0, s:sign_group, 'GitAddSign', bufnr('%'), {'lnum': l:start_line + l:i})
                endfor
            else
                for l:i in range(0, l:count-1)
                    call sign_place(0, s:sign_group, 'GitModSign', bufnr('%'), {'lnum': l:start_line + l:i})
                endfor
            endif
        endif
    endfor
endfunction


function! ToggleMyGitGutter() abort
    if executable('git')
        if !exists('g:mygitgutter_enabled')
            let g:mygitgutter_enabled = 0
        endif

        if g:mygitgutter_enabled
            autocmd! mygitgutter
            augroup! mygitgutter
            call sign_unplace(s:sign_group)
            let g:mygitgutter_enabled = 0
        else
            augroup mygitgutter
                autocmd!
                au BufReadPost,BufWritePost * call UpdateDiffSigns()
                call UpdateDiffSigns()
            augroup END
            let g:mygitgutter_enabled = 1
        endif
    endif
endfunction

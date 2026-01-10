function! MyComplete(ArgLead, CmdLine, CursorPos) abort
    let matches = []
    if executable('rg')
        let processed_arglead = substitute(a:ArgLead, '\v*', '[^/]*', 'g')
        let matches = split(system('rg --files | rg /' . processed_arglead . '[^\/]*$'), '\n')
    endif
    return matches
endfunction
function! OpenFile(filename) abort
    execute 'edit ' . a:filename
endfunction
command -complete=customlist,MyComplete -nargs=1 MyFind call OpenFile(<f-args>)

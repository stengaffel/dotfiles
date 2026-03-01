function! MyComplete(ArgLead, CmdLine, CursorPos) abort
    let matches = []
    if executable('rg')
        let processed_arglead = substitute(a:ArgLead, '\v*', '[^/]*', 'g')
        let matches = systemlist('rg --files | rg /' . processed_arglead . '[^\/]*$')
        call sort(matches)
    endif
    return matches
endfunction
function! OpenFile(filename) abort
    execute 'edit ' . a:filename
endfunction
command -complete=customlist,MyComplete -nargs=1 MyFind call OpenFile(<f-args>)


function! SimpleFindDefinition(language) abort
    let pattern = expand('<cword>')

    if a:language == "python"
        let definition_pattern = "'(def|class)[ ]*" . pattern . "[^a-zA-Z0-9\_]'"
    endif
    let matches = systemlist("rg --color=never --line-number --column " . definition_pattern)

    function! ExtractFromMatch(key, val) abort
        let matches = matchlist(a:val, '\v^([^:]+)\:([0-9]+)\:([0-9]+)\:(.+)')
        return matches[1:5]
    endfunction

    call map(matches, function('ExtractFromMatch'))
    call sort(matches)
    let options = map(copy(matches), 'v:key+1 . ". \e[32m" . v:val[0] . "\e[0m -- " . v:val[1] . ":" . v:val[2] . " -- " . v:val[3]')
    call insert(options, 'Found matches:', 0)

    let choice = 0
    if len(matches) > 1
        let choice = inputlist(options) - 1
    endif
    if 0 <= choice && choice < len(matches)
        let final_path = matches[choice][0]
        let line_num = matches[choice][1]
        let line_col = matches[choice][2]
        execute 'edit ' . final_path
        call cursor(line_num, line_col)
    endif
endfunction

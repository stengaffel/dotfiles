set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "dracula_clean"

let s:background_color = '#282a36'
let s:current_line_color = '#44475a'
let s:foreground_color = '#f8f8f2'
let s:comment_color = '#6272a4'
let s:cyan = '#8be9fd'
let s:green = '#50fa7b'
let s:orange = '#ffb86c'
let s:pink = '#ff79c6'
let s:purple = '#bd93f9'
let s:red = '#ff5555'
let s:yellow = '#f1fa8c'

function s:hi(group, guifg, guibg, guisp, gui, cterm) abort
    let cmd = ''
    if a:guifg != ''
        let cmd = cmd . ' guifg=' . a:guifg
    endif
    if a:guibg != ''
        let cmd = cmd . ' guibg=' . a:guibg
    endif
    if a:guisp != ''
        let cmd = cmd . ' guisp=' . a:guisp
    endif
    if a:gui != ''
        let cmd = cmd . ' gui=' . a:gui
    endif
    if a:cterm != ''
        let cmd = cmd . ' cterm=' . a:cterm
    endif
    if cmd != ''
        execute 'highlight ' . a:group . cmd
    endif
endfunction

call s:hi('Normal', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Directory', s:cyan, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('LineNrAbove', 'GREY', 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('LineNr', s:yellow, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('LineNrBelow', 'GREY', 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('EndOfBuffer', s:comment_color, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Statement', s:pink, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Number', s:purple, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('String', s:yellow, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Constant', s:purple, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Comment', s:comment_color, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Function', s:green, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Pmenu', 'BLACK', s:cyan, 'NONE', 'NONE', 'NONE')
call s:hi('PmenuSel', 'BLACK', s:yellow, 'NONE', 'NONE', 'NONE')
call s:hi('ColorColumn', 'BLACK', 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Todo', 'BLACK', s:yellow, 'NONE', 'NONE', 'NONE')
call s:hi('WildMenu', 'BLACK', s:purple, 'NONE', 'NONE', 'NONE')
call s:hi('TabLineFill', s:current_line_color, 'WHITE', 'NONE', 'NONE', 'NONE')
call s:hi('TabLine', 'WHITE', s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('VertSplit', s:foreground_color, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Title', s:foreground_color, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Visual', 'BLACK', 'WHITE', 'NONE', 'NONE', 'NONE')
call s:hi('Folded', s:cyan, 'gray30', 'NONE', 'NONE', 'NONE')
call s:hi('FoldColumn', s:cyan, 'gray30', 'NONE', 'NONE', 'NONE')
call s:hi('Identifier', s:cyan, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('PreProc', s:pink, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Special', s:pink, 'NONE', 'NONE', 'NONE', 'NONE')
call s:hi('Boolean', s:cyan, 'NONE', 'NONE', 'NONE', 'NONE')

call s:hi('DiffAdd', 'BLACK', s:green, 'NONE', 'NONE', 'NONE')
call s:hi('DiffDelete', 'BLACK', s:red, 'NONE', 'NONE', 'NONE')
call s:hi('DiffChange', 'BLACK', s:orange, 'NONE', 'NONE', 'NONE')
call s:hi('DiffText', 'BLACK', s:yellow, 'NONE', 'NONE', 'NONE')

call s:hi('HLStatusLineNormal', s:foreground_color, s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineMod', s:red, s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineReadOnly', s:cyan, s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineEdge', s:foreground_color, s:comment_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineGitBranch', s:yellow, s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineGitAdd', s:green, s:current_line_color, 'NONE', 'NONE', 'NONE')
call s:hi('HLStatusLineGitDel', s:red, s:current_line_color, 'NONE', 'NONE', 'NONE')

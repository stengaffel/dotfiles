let mapleader=' '

if has("gui_running")
    set termguicolors
    colorscheme shine
    set guioptions-=m
    set guioptions-=r
    set guioptions-=T
    set guioptions-=L
    set guioptions-=e
    set guifont=Consolas:h12
    set belloff=all
    augroup CustomHighlighting
        autocmd!
        autocmd ColorScheme * hi clear TabLineFill | hi link TabLineFill TabLine
    augroup END
else
    if has("termguicolors")
        set termguicolors
        colorscheme dracula_clean
    else
        colorscheme ron
    endif
endif

filetype plugin indent on
syntax enable

" netrw file-tree view
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize=-40
nnoremap <leader>t :Lexplore<cr>
nnoremap <leader>ct :execute ':Lexplore ' . expand('%:p:h')<cr>

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set number
set relativenumber

set showcmd
set showmatch

set incsearch
set hlsearch

set backspace=indent,eol,start
set scrolloff=3

" change the cursor
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" set completion options
set wildmenu
set complete-=i
set completeopt=menuone,longest,noselect
inoremap n <C-n>
inoremap p <C-p>
inoremap k <C-x><C-k>
inoremap t <C-x><C-t>
inoremap f <C-x><C-f>
inoremap l <C-x><C-l>
inoremap v <C-x><C-v>

set path=,,**

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --\ '$*'
else
    set grepprg=grep\ -EHnr\ --\ '$*'
endif

function! ToggleQuickFix() abort
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        botright 10copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <leader>co :call ToggleQuickFix()<cr>

nnoremap <space>w <c-w>
nnoremap <leader>b :ls<cr>:buffer<space>
nnoremap <leader>f :find<space>
"nnoremap <leader>f :MyFind<space>
nnoremap <leader>j :jumps<cr>
nnoremap <leader>m :marks abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<cr>:normal! `
nnoremap <leader>/ :grep<space>
nnoremap <leader>cc :e ~/.vimrc<cr>
nnoremap <leader>cr :w<cr>:source %<cr>

" map kl to Esc
inoremap kl <Esc>

if executable('git')
    nnoremap <leader>gd :!clear<cr>:execute '!git -C ' . expand('%:p:h') . ' diff ' . expand('%:p')<cr>
    nnoremap <leader>gl :execute '!git -C ' . expand('%:p:h') . ' log --stat ' . expand('%:p')<cr>
    nnoremap <leader>gp :execute '!git -C ' . expand('%:p:h') . ' log --patch --stat ' . expand('%:p')<cr>
    nnoremap <leader>gt :call MyDiff()<cr>
    nnoremap <leader>gg :call ToggleMyGitGutter()<cr>
endif

set laststatus=2
if executable('git')
    let b:git_info = ['', '', '']
    function! GetGitInfo() abort
        let git_prefix = 'git -C ' . expand('%:p:h')
        if system(git_prefix . ' rev-parse --is-inside-work-tree') =~ 'true'
            let repo_name = matchstr(system(git_prefix . ' rev-parse --show-toplevel'), '\v\/\zs[^\/\n]+\ze[ \n]*$')
            let branch_name = matchstr(system(git_prefix . ' rev-parse --abbrev-ref HEAD'), '\v^[^\n]+\ze')
            let git_repo_and_branch = repo_name . ' (' . branch_name . ')'
            let diff_numstat = system(git_prefix . ' diff --numstat ' . expand('%:p'))
            let added_lines = matchstr(diff_numstat, '\v^[ ]*\zs[0-9]+\ze')
            let deleted_lines = matchstr(diff_numstat, '\v^[ \t]*[0-9]+[ \t]+\zs[0-9]+\ze')
            return [git_repo_and_branch, '+' . added_lines . ' ', '-' . deleted_lines]
        else
            return ['not a git repo', '+ ', '-']
        endif
    endfunction
    augroup gitinfo
        au!
        au BufReadPost,BufWritePost * let b:git_info = GetGitInfo()
    augroup END
    if !hlexists('HLStatusLineNormal')
        hi HLStatusLineNormal    guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineMod       guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineReadOnly  guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineEdge      guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineGitBranch guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineGitAdd    guifg=black guibg=white ctermfg=black ctermbg=white
        hi HLStatusLineGitDel    guifg=black guibg=white ctermfg=black ctermbg=white
    endif
    set statusline=%#HLStatusLineEdge#\ \ %n\ \ 
    set statusline+=%#HLStatusLineNormal#\ %.60t
    set statusline+=%#HLStatusLineMod#%m
    set statusline+=%#HLStatusLineReadOnly#%r
    set statusline+=%#HLStatusLineNormal#\ \|\ 
    set statusline+=%#HLStatusLineGitBranch#%{get(get(b:,'git_info',[]),0,'')}
    set statusline+=%#HLStatusLineNormal#\ \|\ 
    set statusline+=%#HLStatusLineGitAdd#%{get(get(b:,'git_info',[]),1,'')}
    set statusline+=%#HLStatusLineGitDel#%{get(get(b:,'git_info',[]),2,'')}
    set statusline+=%#HLStatusLineNormal#\ \|\ %Y\ \|\ %{&fileformat}\ \|\ %{&fileencoding}\ \|\ %=
    set statusline+=%#HLStatusLineEdge#\ \ %5.l\/%L\ %P,\ %3.c\ 
else
    set statusline=%3.n\.\ %.60t%m%r\ \[%Y\]\[%{&fileformat}\]\[%{&fileencoding}\]%=%l\/%L\ %P,\ %3.c\ 
endif

if has("gui_running")
    function! ChangeFontSize(operation) abort
        let font = matchstr(&guifont, '\v^\zs[^:]+\ze')
        let font_size = matchstr(&guifont, '\v^[^:]+:h\zs[0-9]+\ze')
        let new_font_size = -1
        if a:operation == 'inc'
            let new_font_size = (str2nr(font_size, 10) + 2)
        else
            let new_font_size = (str2nr(font_size, 10) - 2)
        endif
        execute 'set guifont=' . font . ':h' . new_font_size
    endfunction
    nnoremap <C-+> :call ChangeFontSize('inc')<cr>
    nnoremap <C--> :call ChangeFontSize('dec')<cr>
    set laststatus=0
endif

nnoremap <space><space> :echo "hi<" . synIDattr(synID(line("."), col("."), 1), "name") . ">"<cr>

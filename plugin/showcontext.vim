" showcontext.vim: a simple context viewer for Vim.
" Copyright (C) 11/21/2019 Mark Juers

" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.

" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.

" You should have received a copy of the GNU General Public License along
" with this program; if not, write to the Free Software Foundation, Inc.,
" 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

" autocmd that will set up the w:created variable

augroup created
    autocmd!
    autocmd VimEnter * let w:contextlist_open = 0
    autocmd WinEnter * if !exists('w:created') | let w:contextlist_open = 0 | endif
    autocmd VimEnter * autocmd WinEnter * let w:created=1
augroup END

function! s:ShowContext_bracketstatus(line, status) abort
    let l:brackets = {"closed": 0, "open": 0}
    for character in split(a:line, '\zs')
        if character == ")"
            let l:brackets["closed"] += 1
        endif
        if character == "("
            let l:brackets["open"] += 1
        endif
    endfor
    if a:status == "closed"
        if l:brackets["closed"] > l:brackets["open"]
            return 1
        else
            return 0
        endif
    elseif a:status == "open"
        if l:brackets["open"] > l:brackets["closed"]
            return 1
        else
            return 0
        endif
    endif
endfunction


" from https://vi.stackexchange.com/questions/20078/plugin-to-show-enclosing-indentation-levels/20089#20089
function! ShowContext() abort
    let items = []
    let l:l = line('.')
    let l:indent = 1000
    while l:l >= 0
        if s:ShowContext_bracketstatus(getline(l), "closed")
            let l:subindent = indent(l)
            while s:ShowContext_bracketstatus(getline(l:l), "open") == 0 && indent(l:l) >= l:subindent
                call add(items, getline(l:l))
                let l:l -= 1
            endwhile
        endif
        if indent(l) < l:indent && getline(l:l) != ''
            call add(items, getline(l:l))
            let l:indent = indent(l)
            if l:indent == 0
                break
            endif
        endif
        let l:l -= 1
    endwhile
    lgetexpr reverse(items)
endfunction

function! Toggle_contextlist()
    if w:contextlist_open == 1
        let w:contextlist_open = 0
        autocmd! ContextList
        above lclose
    else
        let w:contextlist_open = 1
        augroup ContextList
            autocmd!
            autocmd CursorHold * call ShowContext()
        augroup END
        above lopen
        wincmd p
    endif
endfunction

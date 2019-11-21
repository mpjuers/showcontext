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

" from https://vi.stackexchange.com/questions/20078/plugin-to-show-enclosing-indentation-levels/20089#20089
function! ShowContext() abort
  let items = []
  let l = line('.')
  let indent = 1000
  while l >= 0
    if indent(l) < indent && getline(l) != ''
      call add(items, getline(l))
      let indent = indent(l)
      if indent == 0
        break
      endif
    endif
    let l -= 1
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

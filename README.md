# What it is:

showcontext.vim opens a scratch buffer in the current window that shows the last
line with less than or equal indentation to the current line. This allows you to see where you are
in a file without scrolling back up.

![](showcontext.gif)

Out of the box, showcontext.vim does nothing; you must map the function
`ShowContext_toggle()` like so:
`nnoremap <leader>lc :call ShowContext_toggle()<CR>`

That's it!

Credit to Rich at vi.stackexchange for doing most of the work.
https://vi.stackexchange.com/questions/20078/plugin-to-show-enclosing-indentation-levels/20089#20089

# Installation

I use Vim-Plug.

Simply add `Plug "mpjuers/showcontext"` to your `.vimrc` in the appropriate
place and `:PlugInstall`. Should work with other plugin managers or manual 
installation (see docs) as well.

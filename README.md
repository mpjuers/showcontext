# What it is:

showcontext.vim opens a location list in the current window that shows the last
line with less than or equal indentation. This allows you to see where you are
in a file without scrolling back up.

Out of the box, showcontext.vim does nothing; you must map the function
Toggle_contextlist like so:
nnoremap <leader>lc :call Toggle_contextlist()<CR>

That's it!

Credit to Rich at vi.stackexchange for doing most of the work.
https://vi.stackexchange.com/questions/20078/plugin-to-show-enclosing-indentation-levels/20089#20089

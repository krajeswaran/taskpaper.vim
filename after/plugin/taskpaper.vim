" Vim after file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	Morgan Sutherland <m@msutherl.net>
" URL:		https://github.com/msutherl/taskpaper.vim
" Last Change:  2011-01-02
"

" map carriage return to create new todo entry. Fixed auto-tabbing
autocmd filetype taskpaper :nnoremap <buffer> <C-m> o- 
autocmd filetype taskpaper :inoremap <buffer> <C-m> <ESC>o- 

" map tab to indent tasks
autocmd filetype taskpaper :nnoremap <buffer> <tab> 0i<tab>

" map shift-tab to unindent tasks
autocmd filetype taskpaper :nnoremap <buffer> <S-tab> <lt><lt>a
autocmd filetype taskpaper :inoremap <buffer> <S-tab> <ESC><lt><lt>a

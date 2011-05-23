" Vim filetype detection file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-05-10
"
augroup taskpaper
     " more relaxed file detection requirements
     au! BufRead,BufNewFile *todo*  setfiletype taskpaper
     " Respect user's tab settings
     "au FileType taskpaper setlocal noexpandtab
augroup END

" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2003 May 02

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "my_murphy"

hi Normal		ctermbg=Black  ctermfg=green guibg=Black		 guifg=#00B700
hi Comment		term=bold	   ctermfg=LightRed   guifg=DarkBlue
hi Constant		term=underline ctermfg=LightGreen guifg=Red	gui=NONE
hi Identifier	term=underline ctermfg=LightGreen  guifg=DarkBlue
hi Ignore					   ctermfg=black	  guifg=bg
hi PreProc		term=underline ctermfg=LightBlue  guifg=Wheat
hi Search		term=reverse					  guifg=black	guibg=DarkYellow
hi Special		term=bold	   ctermfg=LightRed   guifg=magenta
hi Statement	term=bold	   ctermfg=lightgreen	  guifg=SeaGreen gui=NONE
hi Type						   ctermfg=LightGreen guifg=grey	gui=none
hi Error		term=reverse   ctermbg=Red	  ctermfg=White guibg=Red  guifg=White
hi Todo			term=standout  ctermbg=Yellow ctermfg=Black guifg=Black guibg=Green
" From the source:
hi Cursor										  guifg=black	guibg=Green
hi Directory	term=bold	   ctermfg=LightGreen  guifg=SeaGreen
hi ErrorMsg		term=standout  ctermbg=DarkRed	  ctermfg=White guibg=Red guifg=White
hi IncSearch	term=reverse   cterm=reverse	  gui=reverse
hi LineNr		term=underline ctermfg=lightgreen					guifg=DarkGreen
hi ModeMsg		term=bold	   cterm=bold		  gui=bold
hi MoreMsg		term=bold	   ctermfg=LightGreen gui=bold		guifg=SeaGreen
hi NonText		term=bold	   ctermfg=Blue		  gui=bold		guifg=black
hi Question		term=standout  ctermfg=LightGreen gui=bold		guifg=DarkGreen
hi SpecialKey	term=bold	   ctermfg=LightBlue  guifg=DarkGreen
hi StatusLine	term=reverse,bold cterm=reverse   gui=NONE		guifg=LightGreen guibg=DarkGreen
hi StatusLineNC term=reverse   cterm=reverse	  gui=NONE		guifg=white guibg=#333333
hi Title		term=bold	   ctermfg=LightMagenta gui=bold	guifg=Pink
hi WarningMsg	term=standout  ctermfg=LightRed   guifg=Red
hi Visual		term=reverse   cterm=reverse	  gui=NONE		guifg=white guibg=darkgreen

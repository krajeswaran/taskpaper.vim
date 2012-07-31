" plugin to handle the TaskPaper to-do list format
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2012-02-20

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

" Define a default date format
if !exists('g:task_paper_date_format')
    let g:task_paper_date_format = "%Y-%m-%d"
endif

" Define a default archive project name
if !exists('g:task_paper_archive_project')
    let g:task_paper_archive_project = "Archive"
endif

" When moving a task, should the cursor follow or stay in the same place
" (default: follow)
if !exists('g:task_paper_follow_move')
    let g:task_paper_follow_move = 1 
endif

" Define a default archive file location
" Note that current working directory should be writable
" and user should have permissions to create/write a file in current working
" directory
if !exists('task_paper_archive_file') | let task_paper_archive_file = "archive_todo.txt" | endif

" Hide @done tasks when searching tags
if !exists('g:task_paper_search_hide_done')
    let g:task_paper_search_hide_done = 0 
endif

"add '@' to keyword character set so that we can complete contexts as keywords
setlocal iskeyword+=@-@

" Change 'comments' and 'formatoptions' to continue to write a task item
setlocal comments=b:-
setlocal fo-=c fo+=rol

" Change 'comments' and 'formatoptions' to continue to write a task item
setlocal comments=b:-
setlocal fo-=c fo+=rol

" Set 'autoindent' to maintain indent level
setlocal autoindent

"show tasks from context under the cursor
function! s:ShowContext()

    let s:wordUnderCursor = expand("<cword>")
    if(s:wordUnderCursor =~ "@\k*")
        let @/ = "\\<".s:wordUnderCursor."\\>"
        "adapted from http://vim.sourceforge.net/tips/tip.php?tip_id=282
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:1
        setlocal foldmethod=expr foldlevel=0 foldminlines=0
        setlocal foldenable

        " hide the foldcolumn for clutter-free viewing
        setlocal foldcolumn=0
    else
        echo "'" s:wordUnderCursor "' is not a context."    
    endif

endfunction

function! s:ShowAll()
    setlocal foldmethod=syntax
    setlocal nofoldenable
endfunction  

function! s:FoldProject()

    let s:currentLine = getline('.')

    if(s:currentLine =~ ":$")
       setlocal foldenable
       setlocal foldmethod=syntax
       %foldclose!

       " now open only current fold
       exec "normal zo"
    else
       echo "'" s:currentLine "' is not a project."
    endif

    " hide the foldcolumn for clutter-free viewing
    setlocal foldcolumn=0

endfunction

" toggle @done context tag on a task
function! s:ToggleDone()

    let line = getline(".")
    if (line =~ '^\s*- ')
        let repl = line
        if (line =~ '@done')
            let repl = substitute(line, "@done\(.*\)", "", "g")
            echo "undone!"
        else
            let today = strftime(g:task_paper_date_format, localtime())
            let done_str = " @done(" . today . ")"
            let repl = substitute(line, "$", done_str, "g")
            echo "done!"
        endif
        call setline(".", repl)
    else 
        echo "not a task."
    endif

endfunction

" archive @done and @cancelled tasks in current buffer to a text file
function! s:ArchiveDoneTasks()

    let l:current_buffer = getline(1, "$")
 
    if empty(l:current_buffer)
       echo "need task(s) in current buffer to archive."
       return
    endif
 
    " read the existing archive file into a buffer
    let l:archive_buffer = readfile(g:task_paper_archive_file)
 
    let l:index = 1
    let l:found_done_tasks = 0

    " find done/cancelled tasks in current buffer
    while (l:index <= len(l:current_buffer))
       let l:line = get(l:current_buffer, l:index)
 
       if l:line =~ '^\s*- '
          if l:line =~ '@[Cc]ancelled\|@[Dd]one'
             call remove(l:current_buffer, l:index)
             call insert(l:archive_buffer, l:line)
             let l:found_done_tasks = 1
             continue
          endif
       endif
 
       let l:index = l:index + 1
    endwhile
 
    if l:found_done_tasks
       " write found done tasks to archive file
       call writefile(l:archive_buffer, g:task_paper_archive_file)

       " refresh current buffer
       %delete
       call append(0, l:current_buffer)
    else
       echo "no tasks found in done/cancelled status"
    endif
 
endfunction

" Set up mappings
if !exists("no_plugin_maps") && !exists("no_taskpaper_maps")
    nnoremap <silent> <buffer> <Plug>ShowAll
    \       :<C-u>call <SID>ShowAll()<CR>
    nnoremap <silent> <buffer> <Plug>ShowContext
    \       :<C-u>call <SID>ShowContext()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperFoldProjects
    \       :<C-u>call taskpaper#fold_projects()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperFoldNotes
    \       :<C-u>call taskpaper#search('\v^(\s*\|\t+-\s+.*\|.+:)$')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperFocusProject
    \       :<C-u>call taskpaper#focus_project()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperSearchKeyword
    \       :<C-u>call taskpaper#search()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperSearchTag
    \       :<C-u>call taskpaper#search_tag()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperGoToProject
    \       :<C-u>call taskpaper#go_to_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperNextProject
    \       :<C-u>call taskpaper#next_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperPreviousProject
    \       :<C-u>call taskpaper#previous_project()<CR>

    nnoremap <silent> <buffer> <Plug>ArchiveDoneTasks
    \       :<C-u>call <SID>ArchiveDoneTasks()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperArchiveDone
    \       :<C-u>call taskpaper#archive_done()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperShowToday
    \       :<C-u>call taskpaper#search_tag('today')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperShowCancelled
    \       :<C-u>call taskpaper#search_tag('cancelled')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleCancelled
    \       :call taskpaper#toggle_tag('cancelled', taskpaper#date())<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleDone
    \       :call taskpaper#toggle_tag('done', taskpaper#date())<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleToday
    \       :call taskpaper#toggle_tag('today', '')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperMoveToProject
    \       :call taskpaper#move_to_project()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperNewline
    \       o<C-r>=taskpaper#newline()<CR>
    inoremap <silent> <buffer> <Plug>TaskPaperNewline
    \       <CR><C-r>=taskpaper#newline()<CR>

    nmap <buffer> <Leader>ta <Plug>ShowAll
    nmap <buffer> <Leader>tc <Plug>ShowContext
    nmap <buffer> <Leader>tp <Plug>TaskPaperFoldProjects
    nmap <buffer> <Leader>t. <Plug>TaskPaperFoldNotes
    nmap <buffer> <Leader>tP <Plug>TaskPaperFocusProject

    nmap <buffer> <Leader>t/ <Plug>TaskPaperSearchKeyword
    nmap <buffer> <Leader>ts <Plug>TaskPaperSearchTag

    nmap <buffer> <Leader>tg <Plug>TaskPaperGoToProject
    nmap <buffer> <Leader>tj <Plug>TaskPaperNextProject
    nmap <buffer> <Leader>tk <Plug>TaskPaperPreviousProject

    nmap <buffer> <Leader>tD <Plug>TaskPaperArchiveDone
    nmap <buffer> <Leader>tz <Plug>ArchiveDoneTasks
    nmap <buffer> <Leader>tT <Plug>TaskPaperShowToday
    nmap <buffer> <Leader>tX <Plug>TaskPaperShowCancelled
    nmap <buffer> <Leader>td <Plug>TaskPaperToggleDone
    nmap <buffer> <Leader>tt <Plug>TaskPaperToggleToday
    nmap <buffer> <Leader>tx <Plug>TaskPaperToggleCancelled
    nmap <buffer> <Leader>tm <Plug>TaskPaperMoveToProject

    if mapcheck("o", "n") == ''
        nmap <buffer> o <Plug>TaskPaperNewline
    endif
    if mapcheck("\<CR>", "i") == ''
        imap <buffer> <CR> <Plug>TaskPaperNewline
    endif
endif

let &cpo = s:save_cpo

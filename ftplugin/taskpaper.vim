" plugin to handle the TaskPaper to-do list format
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-05-10

if exists("loaded_task_paper")
    finish
endif
let loaded_task_paper = 1

" Define a default date format
if !exists('task_paper_date_format') | let task_paper_date_format = "%Y-%m-%d" | endif

" Define a default archive file location
" Note that current working directory should be writable
" and user should have permissions to create/write a file in current working
" directory
if !exists('task_paper_archive_file') | let task_paper_archive_file = "archive_todo.txt" | endif

"add '@' to keyword character set so that we can complete contexts as keywords
setlocal iskeyword+=@-@

"set default folding: by project (syntax), open (up to 99 levels), disabled 
setlocal foldmethod=syntax
setlocal foldlevel=99
setlocal nofoldenable

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
    %foldopen!
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

" toggle @cancelled context tag on a task
function! s:ToggleCancelled()

    let line = getline(".")
    if (line =~ '^\s*- ')
        let repl = line
        if (line =~ '@cancelled')
            let repl = substitute(line, "@cancelled\(.*\)", "", "g")
            echo "uncancelled!"
        else
            let today = strftime(g:task_paper_date_format, localtime())
            let cancelled_str = " @cancelled(" . today . ")"
            let repl = substitute(line, "$", cancelled_str, "g")
            echo "cancelled!"
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
noremap <unique> <script> <Plug>ToggleDone       :call <SID>ToggleDone()<CR>
noremap <unique> <script> <Plug>ToggleCancelled   :call <SID>ToggleCancelled()<CR>
noremap <unique> <script> <Plug>ShowContext      :call <SID>ShowContext()<CR>
noremap <unique> <script> <Plug>ShowAll          :call <SID>ShowAll()<CR>
noremap <unique> <script> <Plug>FoldProject  :call <SID>FoldProject()<CR>
noremap <unique> <script> <Plug>ArchiveDoneTasks  :call <SID>ArchiveDoneTasks()<CR>

map <buffer> <silent> <Leader>td <Plug>ToggleDone
map <buffer> <silent> <Leader>tx <Plug>ToggleCancelled
map <buffer> <silent> <Leader>tc <Plug>ShowContext
map <buffer> <silent> <Leader>ta <Plug>ShowAll
map <buffer> <silent> <Leader>tp <Plug>FoldProject
map <buffer> <silent> <Leader>tz <Plug>ArchiveDoneTasks

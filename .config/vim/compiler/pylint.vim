" Vim compiler file for Python
" Compiler:     Style checking tool for Python
" Maintainer:   Oleksandr Tymoshenko <gonzo@univ.kiev.ua>
" Last Change:  2009 Apr 19
" Version:      0.5
" Contributors:
"     Artur Wroblewski
"     Menno
"
" Installation:
"   Drop pylint.vim in ~/.vim/compiler directory. Ensure that your PATH
"   environment variable includes the path to 'pylint' and 'pep8' executables.
"
"   Add the following line to the autocmd section of .vimrc
"
"      autocmd FileType python compiler pylint
"

if exists('current_compiler')
  finish
endif
let current_compiler = 'pylint'

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=(pylint\ -r\ n\ %;\ pep8\ %;\ echo\ '[%]')
CompilerSet efm=%t:\ %#%l\\,\ %#%c:\ %m,%f:%l:%c:\ %t%n\ %m,\[%f\],%-G%.%#


function! Pylint(writing)
    if !a:writing && &modified
        " Save before running
        write
    endif

    setlocal sp=>%s\ 2>&1

    silent Make!
endfunction

au BufWritePre * :%s/\s\+$//e
au BufWritePost * :call Pylint(1)
call Pylint(1)

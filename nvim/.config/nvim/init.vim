set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

set backupdir=$HOME/.config/nvim/backup/
set directory=$HOME/.config/nvim/backup/
set backup

execute pathogen#infect()

set backspace=indent,eol,start
set whichwrap=<,>,h,l,[,]
set ruler
set showcmd
set incsearch
set expandtab
set ignorecase
set smartcase
set tabstop=8
set softtabstop=4
set shiftwidth=4
set statusline=[FILE=%f]%r%h%w%=\ %{fugitive#statusline()}\ \ \ [TYPE=%Y]\ \ \ [POS=%03l(%L),%03v]\ \ \ [%p%%]
set laststatus=2
set completeopt-=preview
" set omnifunc=syntaxcomplete#Complete
set tags=$HOME/.cache/ctags/src,$HOME/.cache/ctags/include
set switchbuf=useopen
set nofoldenable

let g:autoswap_detect_tmux = 1
let g:DirDiffExcludes = "CVS,*.class,*.exe,.*.swp,.git,.bzr"
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2
let g:jedi#completions_command = "<C-n>"
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  " set t_Co=256
  colorscheme lettuce
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  filetype plugin indent on
  
  autocmd InsertLeave * se nocul
  autocmd InsertEnter * se cul

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd WinEnter *
    \ if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" |
    \ q |
    \ endif
else
  set autoindent
endif " has("autocmd")

vmap <C-c> y:call system("xclip -i -selection clipboard",getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
nmap <C-y> <C-o>

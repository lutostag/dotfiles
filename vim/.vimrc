if has("nvim")
  set undodir=$HOME/.config/nvim/undo " where to save undo histories
  set backupdir=$HOME/.config/nvim/backup/
  set directory=$HOME/.config/nvim/backup/
else
  set nocompatible
  set undodir=$HOME/.config/vim/undo " where to save undo histories
  set backupdir=$HOME/.config/vim/backup/
  set directory=$HOME/.config/vim/backup/
  set viminfo+=n$HOME/.config/vim/viminfo
  set runtimepath+=$HOME/.config/vim
endif

set undofile                " Save undo's after file closes
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
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
set tags=$HOME/.cache/ctags/src,$HOME/.cache/ctags/include
set switchbuf=useopen
set nofoldenable
set clipboard=unnamedplus
set mouse=a

autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

let g:autoswap_detect_tmux = 1
autocmd! BufWritePost * Neomake
let g:DirDiffExcludes = "CVS,*.class,*.exe,.*.swp,.git,.bzr"
let g:jedi#force_py_version = 3
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 1
let g:jedi#show_call_signatures_delay = 0
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set t_Co=256
  let g:rehash256 = 1
  colorscheme molokai
  hi Normal guibg=NONE ctermbg=NONE ctermfg=white
  hi NonText guibg=NONE ctermbg=NONE
  set hlsearch
endif

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

filetype plugin indent on

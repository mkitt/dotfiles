set nocompatible
runtime! macros/matchit.vim
filetype plugin indent on
syntax enable
set autoindent
set autoread
set clipboard=unnamed
if executable('rg') | set grepprg=rg\ | endif
set history=1000
set hlsearch
set mouse=a
set nobackup
set noswapfile
set nowrap
set nowritebackup
set ruler
set number
set smartindent
set smarttab
set splitright splitbelow
set title
set undolevels=1000
set wildignore+=*.DS_Store
set wildmenu
let g:netrw_liststyle=3

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <silent><leader>\ :nohlsearch<CR>
noremap <silent><leader>CW :%s/\s\+$//<CR>

if has("autocmd")
  augroup FTOptions
    autocmd!
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal spell
    autocmd FileType markdown,text,txt setlocal textwidth=80 linebreak nolist wrap spell
  augroup END
endif

colorscheme delek

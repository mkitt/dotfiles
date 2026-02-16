set autoindent
set clipboard=unnamed
if executable('rg') | set grepprg=rg\ | endif
set mouse=a
set nobackup
set noswapfile
set nowrap
set nowritebackup
set number
set splitright splitbelow
set title
set wildignore+=*.DS_Store
let g:netrw_liststyle=3

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <silent><leader>\ :nohlsearch<CR>
noremap <silent><leader>CW :%s/\s\+$//<CR>

colorscheme delek

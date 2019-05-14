" Disable vi compatibility
set nocompatible

" Plugins
" --------------------------------------
call plug#begin('~/.vim/plugged')

" Editor
Plug 'dyng/ctrlsf.vim'
Plug 'henrik/vim-indexed-search'
Plug 'mkitt/pigment'
Plug 'mkitt/tabline.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'ton/vim-bufsurf'
Plug 'vim-scripts/YankRing.vim'
Plug 'yssl/QFEnter'

" Editing
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Filetypes
Plug 'sheerun/vim-polyglot'

" Utility
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

call plug#end()

runtime! macros/matchit.vim
filetype plugin indent on
syntax enable

" Preferences
" --------------------------------------
set autoindent
set autoread
set backspace=2
set clipboard=unnamed
set complete-=i
set completeopt=longest,menu,menuone,preview,noselect,noinsert
set display+=lastline
set expandtab
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,eol:¬,trail:·
set mouse=a
set nobackup
set nojoinspaces
set noshowcmd
set nostartofline
set noswapfile
set nowrap
set nrformats-=octal
set number
set ruler
set scrolloff=3
set sessionoptions-=options
set shiftround
set shiftwidth=2
set showmatch
set sidescrolloff=3
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitright splitbelow
set tabstop=2
set title
set ttimeout
set ttimeoutlen=50
set ttyfast
set undolevels=1000
set wildignore+=*.DS_Store
set wildmenu
set wildmode=longest:full,full

if has("balloon_eval") && has("unix")
  set ballooneval
endif

if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

if executable('rg')
  set grepprg=rg\
endif

let g:ctrlsf_auto_close=0

let g:netrw_liststyle=3
let g:NERDTreeWinSize=40
let g:NERDTreeMinimalUI=1
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeMapUpdir='-'

let g:qfenter_keymap={}
let g:qfenter_keymap.vopen=['<C-v>']
let g:qfenter_keymap.hopen=['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen=['<C-t>']

let g:javascript_plugin_flow=1

let g:yankring_window_height=10
let g:yankring_history_dir=$HOME.'/.vim/tmp/yankring/'

let g:indexed_search_colors=0

" Mappings
" --------------------------------------
" Move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" NERDTree in a buffer (like netrw)
nnoremap <silent>- :silent edit %:p:h<CR>
nnoremap <silent>_ :silent edit .<CR>

" Override jumplist commands
nnoremap <silent><C-i> :BufSurfBack<CR>
nnoremap <silent><C-o> :BufSurfForward<CR>

" Tab through popup menu items
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <silent><C-@> :CocList<CR>

" The `g` commands
nnoremap <silent>ga :CocList --normal diagnostics<CR>
nnoremap <silent>gb :CocList buffers<CR>
nnoremap <silent>gd :call CocAction('jumpTypeDefinition')<CR>
nnoremap <silent>gf :call CocAction('jumpDefinition')<CR>
nnoremap <silent>gF :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent>gh :call CocAction('doHover')<CR>
nnoremap <silent>gl :CocList files<CR>
nnoremap <silent>gL :CocListResume<CR>
nnoremap <silent>gr :call CocAction('jumpReferences')<CR>
nnoremap gs :CocList grep<CR>
xnoremap gs y :CocList grep <C-R>=escape(@",'$ ')<CR><CR>
nnoremap <silent>gx :call CocAction('showSignatureHelp')<CR>
nnoremap <silent>gy :NERDTreeToggle<CR>
nmap gz <Plug>CtrlSFPrompt
vmap gz <Plug>CtrlSFVwordExec

" Visually select the text that was last edited/pasted
nnoremap <silent>gV `[v`]

" Clear the search highlight
noremap <silent><leader>\ :nohlsearch<CR>

" Remove whitespace
noremap <silent><leader>CW :%s/\s\+$//<CR>

" Yank/paste contents using an unnamed register
xnoremap <silent><leader>y "xy
noremap <silent><leader>p "xp

" Filetypes
" --------------------------------------
func! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

if has("autocmd")
  augroup FTOptions
    autocmd!
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile *.ts set syntax=javascript
    autocmd BufRead,BufNewFile *.tsx set syntax=javascript.jsx
    autocmd BufRead,BufNewFile *.workflow set filetype=terraform
    autocmd BufRead,BufNewFile .env.* set filetype=sh
    autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal spell
    autocmd FileType markdown,text,txt setlocal tw=80 linebreak nolist wrap spell
    autocmd FileType qf setlocal wrap
    autocmd QuickFixCmdPost *grep* botright copen
    autocmd QuitPre * if empty(&buftype) | lclose | endif
    " Abbreviations
    autocmd FileType javascript,javascript.jsx,typescript,typescript.jsx iabbrev <buffer> bgc backgroundColor: '',<Left><Left><C-R>=Eatchar('\s')<CR>
    autocmd FileType javascript,javascript.jsx,typescript,typescript.jsx iabbrev <buffer> sdb outline: '1px dotted blue',<C-R>=Eatchar('\s')<CR>
    autocmd FileType javascript,javascript.jsx,typescript,typescript.jsx iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\s')<CR>
  augroup END
endif

" Theme
" --------------------------------------
colorscheme pigment

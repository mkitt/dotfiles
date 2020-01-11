set nocompatible
runtime! macros/matchit.vim
filetype plugin indent on
syntax enable

" Plugins
" --------------------------------------
call plug#begin('~/.vim/plugged')

" Editor
Plug 'mkitt/pigment'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/YankRing.vim'

" Filetypes
Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'

call plug#end()

" Preferences
" --------------------------------------
set autoindent
set autoread
set backspace=2
if has("balloon_eval") && has("unix") | set ballooneval | endif
set clipboard=unnamed
set complete-=i
set completeopt=longest,menu,menuone,preview,noselect,noinsert
set display+=lastline
set expandtab
set formatoptions+=j
if executable('rg') | set grepprg=rg\ | endif
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
set nowritebackup
set nrformats-=octal
set number
set ruler
set scrolloff=3
set sessionoptions-=options
set shiftround
set shiftwidth=2
set shortmess-=S
set showmatch
set sidescrolloff=3
set signcolumn=yes
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitright splitbelow
if &t_Co == 8 && $TERM !~# '^linux' | set t_Co=16 | endif
set tabstop=2
set title
set ttimeout
set ttimeoutlen=50
set ttyfast
set undolevels=1000
set updatetime=50
set wildignore+=*.DS_Store
set wildmenu
set wildmode=longest:full,full

let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeMapUpdir='-'
let g:NERDTreeMinimalUI=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=40
let g:javascript_plugin_flow=1
let g:markdown_fenced_languages=['css', 'html', 'javascript', 'json', 'graphql', 'sh', 'typescript=javascript', 'yaml']
let g:multi_cursor_exit_from_insert_mode=1
let g:multi_cursor_exit_from_visual_mode=1
let g:netrw_liststyle=3
let g:yankring_history_dir=$HOME.'/.vim/tmp/yankring/'
let g:yankring_window_height=10

" Key Mappings
" --------------------------------------
" Move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" NERDTree in a buffer (like netrw)
nnoremap <silent>- :silent edit %:p:h<CR>
nnoremap <silent>_ :silent edit .<CR>

" Tab through popup menu items and allow return to select
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <C-@> coc#refresh()

" The `g`oto and list commands
nnoremap <silent><C-@> :CocList<CR>
nnoremap <silent><C-c> :CocList commands<CR>
nnoremap <silent>ga :CocList --normal diagnostics<CR>
nnoremap <silent>gb :CocList buffers<CR>
nnoremap <silent>gd :call CocAction('jumpTypeDefinition')<CR>
nnoremap <silent>gf :call CocAction('jumpDefinition')<CR>
nnoremap <silent>gF :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent>gh :call CocAction('doHover')<CR>
nnoremap <silent>gl :CocList files<CR>
nnoremap <silent>gL :CocListResume<CR>
nnoremap <silent>gr :call CocAction('jumpReferences')<CR>
nnoremap <silent>gs :CocList grep<CR>
xnoremap <silent>gs y :CocList grep <C-R>=escape(@",'$ ')<CR><CR>
nnoremap <silent>gu :call CocAction('showSignatureHelp')<CR>
nnoremap <silent>gV `[v`]
nnoremap <silent>gy :NERDTreeToggle<CR>
nnoremap gz :CocSearch<space>
xnoremap gz y :CocSearch <C-R>=escape(@",'$ ')<CR><CR>
nmap <silent>g/ <Plug>(coc-refactor)
nmap <silent>g. <Plug>(coc-codeaction)
vmap <silent>g. <Plug>(coc-codeaction-selected)

" Custom unimpaireds
nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)

" Clear the search highlight
noremap <silent><leader>\ :nohlsearch<CR>

" Remove whitespace
noremap <silent><leader>CW :%s/\s\+$//<CR>

" Auto Commands
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
    autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
    autocmd BufRead,BufNewFile *.tsx set syntax=javascript.jsx
    autocmd BufRead,BufNewFile .env.* set filetype=sh
    autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal spell
    autocmd FileType markdown,text,txt setlocal textwidth=80 linebreak nolist wrap spell
    autocmd FileType qf setlocal wrap
    autocmd QuickFixCmdPost *grep* botright copen
    autocmd QuitPre * if empty(&buftype) | lclose | endif
    " Abbreviations
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx iabbrev <buffer> bgc backgroundColor: '',<Left><Left><C-R>=Eatchar('\s')<CR>
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx iabbrev <buffer> sdb outline: '1px dotted blue',<C-R>=Eatchar('\s')<CR>
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx iabbrev <buffer> cdl console.log()<Backspace><C-R>=Eatchar('\s')<CR>
  augroup END
endif

" Theme
" --------------------------------------
colorscheme pigment

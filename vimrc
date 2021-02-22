set nocompatible
runtime! macros/matchit.vim
filetype plugin indent on
syntax enable

" Plugins
" --------------------------------------
call plug#begin('~/.vim/plugged')

" Editor
Plug 'mg979/vim-visual-multi'
Plug 'mkitt/pigment'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
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
set shortmess+=c
set showmatch
set sidescrolloff=3
set signcolumn=number
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
let g:VM_maps = {}
let g:VM_maps['Find Under']='<C-m>'
let g:VM_maps['Find Subword Under']='<C-m>'
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
nnoremap <silent><nowait><C-@> :CocList<CR>
nnoremap <silent><nowait><C-c> :CocList commands<CR>
nnoremap <silent><nowait>ga :CocList --normal diagnostics<CR>
nnoremap <silent><nowait>gb :CocList buffers<CR>
nnoremap <silent><nowait>gd :call CocActionAsync('jumpTypeDefinition')<CR>
nnoremap <silent><nowait>gf :call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent><nowait>gF :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
nnoremap <silent><nowait>gh :call CocActionAsync('doHover')<CR>
nnoremap <silent><nowait>gl :CocList files<CR>
nnoremap <silent><nowait>gL :CocListResume<CR>
nnoremap <silent><nowait>gr :call CocActionAsync('jumpReferences')<CR>
nnoremap <silent><nowait>gs :CocList grep<CR>
xnoremap <silent><nowait>gs y :CocList grep <C-R>=escape(@",'$ ')<CR><CR>
nnoremap <silent><nowait>gu :call CocActionAsync('showSignatureHelp')<CR>
nnoremap <silent><nowait>gV `[v`]
nnoremap <silent><nowait>gy :NERDTreeToggle<CR>
nnoremap gz :CocSearch<space>
xnoremap gz y :CocSearch <C-R>=escape(@",'$ ')<CR><CR>
nmap <silent><nowait>g/ <Plug>(coc-refactor)
nmap <silent><nowait>g. <Plug>(coc-codeaction)
vmap <silent><nowait>g. <Plug>(coc-codeaction-selected)

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
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\s')<CR>
  augroup END
endif

" Patches
" --------------------------------------
" Fixes the broken `gx` command
" https://github.com/vim/vim/issues/4738
if has('macunix')
  function! OpenURLUnderCursor()
    let s:uri = expand('<cWORD>')
    let s:uri = substitute(s:uri, '?', '\\?', '')
    let s:uri = shellescape(s:uri, 1)
    if s:uri != ''
      silent exec "!open '".s:uri."'"
      :redraw!
    endif
  endfunction
  nnoremap gx :call OpenURLUnderCursor()<CR>
endif

" Theme
" --------------------------------------
colorscheme pigment

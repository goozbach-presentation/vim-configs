
" Required:
filetype plugin indent on

" tabstop
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" some more fun ones
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
"set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
set undofile

" set my localleader
let maplocalleader = ";"

" search
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
nnoremap <localleader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" list mode
set list
set listchars=tab:▸\ ,eol:¬

" disable help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" solarized
syntax enable
set background=dark
colorscheme solarized

" setup templates
autocmd BufNewFile *.md 0r ~/.vim/templates/template.md

" Add a todo
nmap <localleader>t <esc>:.!/bin/date '+\%G-\%m-\%d'<enter>A TODO --

" refresh diff
map <localleader>di :diffupdate<CR>

" Line numbers
map <localleader>ln :set<Space>nu!<CR>

" reveal codes
map <localleader>co :set<Space>list!<CR>

" ROT13 entire file stay on current line
map <localleader>rot <Esc>mrggVGg?<CR>'r

" Toggle long lines with <F12>
map <localleader>l :set<Space>wrap!<CR>

" bubble stuff
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" window stuffs
nmap <localleader>ww :wincmd w<cr>:wincmd _<cr>
nmap <localleader>we :wincmd w<cr>:wincmd =<cr>

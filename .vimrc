" Hello Vim, goodbye Vi
set nocompatible

if has('vim_starting') && isdirectory(expand("$HOME/.vim/bundle/neobundle.vim/"))
    set rtp+=~/.vim/bundle/neobundle.vim/

    call neobundle#begin(expand('~/.vim/bundle/'))
endif

" General Settings
syntax on
filetype on
colorscheme molokai

set antialias
set autoread
set background=dark
set backspace=indent,eol,start
set formatoptions=ql
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set iskeyword-=:
set iskeyword+={,}
set laststatus=2
set linebreak
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
set noerrorbells
set noruler
set nostartofline
set nowrap
set shellslash
set shortmess+=filmnrxoOtT
set showcmd
set showmatch
set nojoinspaces
set noshowmode
set smartcase
set switchbuf=usetab,newtab
set synmaxcol=150
set t_Co=256
"set ttybuiltin
"set ttyfast
"set ttyscroll=1
set verbose=0
set verbosefile=$HOME/.vim/verbose.log
set viewoptions=cursor,folds,slash,unix
set virtualedit=onemore
set visualbell

" Tab Settings
set tabpagemax=99
nnoremap tq <Esc>:q<CR>
nnoremap tp <Esc>:tabp<CR>
nnoremap tn <Esc>:tabn<CR>
nnoremap tm <Esc>:tabm
nnoremap te <Esc>:tabe |
map <D-PageUp> <Esc>:tabp<CR>
map <D-PageDown> <Esc>:tabn<CR>
map <PageUp> <C-U>
map <PageDown> <C-D>

" Folding
set nofoldenable
set foldmethod=manual
set foldminlines=1

" Backups
set nobackup
set nowritebackup
set noswapfile
function! MakeBackup()
    let pos    = line(".")
    let b:dir  = $HOME . "/.vim/backup/" . strftime("%m.%d.%Y") . "/" . substitute(expand("%:h"), "^\/", "", "") . "/"
    let b:file = b:dir . substitute(expand("%:t"), "^\\.", "", "") . strftime(".%H.%M.%S")
    echo b:dir
    echo b:file
    silent! exe mkdir(b:dir, "p")
    exe writefile(getline(1,'$'), b:file)
    exe pos
endfunction

" Wild Menu
set wildmenu
set wildmode=longest,list,full
set wildignore=CVS,*.swp,*.bak,*.pyc,*.class

" Auto-scroll
set scrolloff=5
set sidescrolloff=7
set sidescroll=1

" Auto-commands
au! BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI * silent checktime
au! BufReadPost * silent call MakeBackup()
au! BufWritePre * silent call MakeBackup()

if version >= 703
    " Pasting
    set clipboard=unnamedplus

    " Undo
    set undodir=$HOME/.vim/undo
    set undofile
    set undolevels=1000
    set undoreload=10000

    " Case-insensitive wildmenu
    if exists("&wildignorecase")
        set wildignorecase
    endif

endif

" GVim... or not?
if has("gui_running")
    set guifont=Inconsolata
    set guioptions-=r
else
    set term=$TERM
endif

" Bundles (NeoBundle)
if exists(':NeoBundle')
    NeoBundleFetch 'Shougo/neobundle.vim'

    if exists(':NeoBundleDepends')
        NeoBundleDepends 'Shougo/vimproc'
    endif

    " Color Schemes
    NeoBundle 'jiskiras/molokai'

    " My bundles
    NeoBundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
    NeoBundle 'Lokaltog/vim-powerline'
    NeoBundle 'Raimondi/delimitMate'
    NeoBundle 'godlygeek/tabular'
    NeoBundle 'inkarkat/vcscommand.vim'
    NeoBundle 'lukaszb/vim-web-indent'
    NeoBundle 'mattn/emmet-vim'
    NeoBundle 'mattn/gist-vim'
    NeoBundle 'mattn/webapi-vim'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'sjl/gundo.vim'
    NeoBundle 'vim-scripts/matchit.zip'
    NeoBundle 'elzr/vim-json'
    NeoBundle 'pangloss/vim-simplefold'
    NeoBundle 'vim-scripts/SearchFold'
    "NeoBundle 'marijnh/tern_for_vim'
    "NeoBundle 'Shougo/unite.vim'

    " Bundles for Vim 7.3+
    if version >= 703
        "NeoBundle 'Valloric/YouCompleteMe'
    endif

    " Bundles for specific filetypes
    " HTML
    NeoBundleLazy 'othree/html5.vim'
    au FileType html NeoBundleSource html5.vim

    " CSS
    NeoBundleLazy 'miripiruni/CSScomb-for-Vim'
    NeoBundleLazy 'vim-scripts/CSSMinister'
    au FileType css,html NeoBundleSource CSScomb-for-Vim

    " JavaScript
    NeoBundleLazy 'pangloss/vim-javascript'
    au FileType javascript NeoBundleSource vim-javascript

    " Perl
    NeoBundleLazy 'vim-scripts/perl-mauke.vim'
    au FileType perl NeoBundleSource perl-mauke.vim

    call neobundle#end()

    NeoBundleCheck
endif

" General Mappings
let mapleader=','

" Normal + Visual + Operator Mappings
"map K diwi<b></b><Esc>F<P
nnoremap Q <Esc>:q<CR>
nnoremap 0 ^
nnoremap <Space> /
nnoremap <silent> <CR> :nohls<CR>
" Spelling
nnoremap <Leader>sp :setlocal spell!<CR>
nnoremap <F2> :setlocal spell!<CR>
nnoremap <Leader>sn ]S
nnoremap <F5> [s
nnoremap <Leader>sp [S
nnoremap <F6> ]s
nnoremap <Leader>sa zg
nnoremap <Leader>si zG
nnoremap <Leader>sc z=
nnoremap <C-P> :setlocal paste!<CR>
nnoremap <Leader>p :setlocal paste!<CR>
nnoremap <Leader>/ :lnext<CR>
nnoremap <Leader>. :lprev<CR>
"map <C-O> <Esc>o
nnoremap :cc :VCSCommit<CR>
nnoremap ;cc :VCSCommit<CR>
nnoremap ;rev : VCSReview<CR>
nnoremap :rev : VCSReview<CR>
nnoremap :img /\v\<img.*>&(.*width)@!<CR>
nnoremap ;img /\v\<img.*>&(.*width)@!<CR>
nnoremap :lex1 <Esc>:%s:’:':eg<CR>:%s:\(<\/*[^>]\+>\)\zs\(\p\+\)\ze\(<\/*[^>]\+>\):[% lex("\2") %]:cgi<CR>
nnoremap ;lex1 <Esc>:%s:’:':eg<CR>:%s:\(<\/*[^>]\+>\)\zs\(\p\+\)\ze\(<\/*[^>]\+>\):[% lex("\2") %]:cgi<CR>
"map :lex2 <Esc>:%s:\(lex\([^)]\|\n\)\+)\\|none\)\@!\(lex\([^)]\|\n\)\+>\([^)]\|\n\)\+)\):\1\\|none:cgi<CR>
"map ;lex2 <Esc>:%s:\(lex\([^)]\|\n\)\+)\\|none\)\@!\(lex\([^)]\|\n\)\+>\([^)]\|\n\)\+)\):\1\\|none:cgi<CR>
nnoremap :lex2 <Esc>:%s:\(lex\([^)]\|\n\)\+)\|none\)\@!\(lex\([^)]\|\n\)\+\)\+\(>\|&\)\([^)]\)\+):\1\\|none:cgi<CR>
nnoremap ;lex2 <Esc>:%s:\(lex\([^)]\|\n\)\+)\|none\)\@!\(lex\([^)]\|\n\)\+\)\+\(>\|&\)\([^)]\)\+):\1\\|none:cgi<CR>
nnoremap :ws :%s/\s\+$//<CR>
nnoremap ;ws :%s/\s\+$//<CR>
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Arrow keys, I'll miss you
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
nnoremap K <NOP>

" Insert + Command-line Mappings

" Normal Mappings
"nmap ,b :%s:^d:,d:egi<CR>:Tabularize /,\zs/l0c1<CR>
nnoremap ,b :'<,'>Tabularize /,\zs/l0c1<CR>:'<,'>Tabularize /\zs]/l1c0<CR>:'<,'>s/\s\+,/,/egi<CR>:'<,'>s/\s\{2,}]/ ]/egi<CR>:'<,'>s/\(\[.*\)\s\{2,}\[/\1 [/egi<CR>:'<,'>s/\[ ]/[]/egi<CR>:'<,'>Tabularize /],*$/l1c0<CR>:'<,'>s/\(\s\+\) ]$/\1]/eg<CR>
nnoremap ,d :Vdiff HEAD<CR>
nnoremap ,,d :Vdiff
nnoremap ,g :%s/^$\n//cgi<CR>
nnoremap ,l :VCSLog<CR>
nnoremap <silent> ,q :<C-u>silent !nohup sudo apachectl -k graceful >/tmp/graceful.log 2>/tmp/graceful_err.log<CR>:redraw!<CR>
nnoremap ,r :!%<CR>
nnoremap ,,s :source ~/.vimrc<CR>
nnoremap ,t :s#<[^>]\+>##g<CR>:nohls<CR>
nnoremap ,u :GundoToggle<CR>
nnoremap ,v :tabe ~/.vimrc<CR>
nnoremap ,w :!nohup /var/www/bin/buildall &<CR>
nnoremap ,x :SyntasticCheck<CR>
nnoremap :fil :let @/='lex\(\_.*\\|\s*none\)\@!\(.\|\n\)\{-}\zs)\ze\>'
"nnoremap :app :tabe /usr/local/share/perl5/CGI/Ex/App.pm<CR>
nnoremap :app :tabe /usr/share/perl5/vendor_perl/CGI/Ex/App.pm<CR>
nnoremap :temp :tabe /usr/share/perl5/vendor_perl/Template/Alloy.pm<CR>
nnoremap ` '
nnoremap ' `
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Down> <c-w>j
nnoremap <silent> <C-Left> <c-w>h
"nnoremap <silent> <Leader>h ml:exe 'match Search /\%'.line('.').'l/'<CR>
nnoremap ; :

" Visual Mappings
vnoremap < <gv
vnoremap > >gv
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Command-line Mappings
cmap w!! w !sudo tee % >/dev/null
cmap w; w

" Insert Mappings
inoremap ∆ <C-R>=FunctionExec("join")<CR><Del>
inoremap <C-S> <C-X><C-F>
inoremap __media @media only screen and (min-width:1224px) {<CR>}<CR>@media only screen and (max-width:1223px) {<CR>}<CR>@media only screen and (max-width:1024px) {<CR>}<CR>@media only screen and (max-width:900px) {<CR>}<CR>@media only screen and (max-width:750px) {<CR>}<CR>@media only screen and (max-width:700px) {<CR>}

" Commands
command! DiffOrig vert bel new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -nargs=? Vdiff :VCSVimDiff <args>

" Command Aliases
:ca WQ wq
:ca Wq wq
:ca W w
:ca Q q

" Views
"au! BufWinLeave * silent! mkview
au! BufRead * silent! loadview

" Indents
set autoindent
set smartindent
set shiftround

" Tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set showtabline=2

" Functions
function! FunctionExec(cmd)
    let pos = line( "." )
    exec a:cmd
    exe pos
    return ""
endfunction

function! JavaScriptSyn()
    setl fen
    setl foldmethod=syntax
    setl fillchars=fold:\ 
    setl foldlevelstart=1
    let g:syntastic_check_on_open=1
    inoremap <C-c> <CR><Esc>O
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Make % not only match opening and closing brackets but also if/then/else etc
runtime macros/matchit.vim

" Filetype Plugins
filetype plugin indent on

" HTML
au! FileType html set tw=125

" CSS
au! BufNewFile,BufRead *.css  set indentkeys=<F13>|set noautoindent|set nosmartindent|set nocindent|set indentexpr=
au! BufRead,BufNewFile *.scss set filetype=css
au! BufRead,BufNewFile *.sass set filetype=css

" JavaScript
"au FileType javascript call JavaScriptSyn()

" Perl
au! BufWritePost *.pm silent !nohup sudo apachectl -k graceful >/tmp/graceful.log 2>/tmp/graceful_err.log
au! BufRead,BufNewFile *.pm set filetype=perl|set commentstring=#%s

" Plugin Settings
" Emmet (zencoding)
let g:user_emmet_leader_key='<C-J>'
let g:user_emmet_complete_tag=1
let g:user_emmet_next_key='<C-L>'
let g:user_emmet_prev_key='<C-K>'
let g:user_emmet_mode='a'
let g:user_emmet_settings={
\   'indentation' : '    ',
\   'perl' : {
\       'aliases' : {
\           'r' : 'require '
\       },
\       'snippets' : {
\           'ds' : "###----------------------------------------------------------------###\n\n",
\           'use' : "use strict;\nuse warnings;\n\n",
\           'pn' : "sub post_navigate { require Debug; Debug::debug(shift->dump_history); }\n"
\       }
\   },
\   'html' : {
\       'snippets' : {
\           'jq' : '<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>',
\           'hb' : '{{ | }}',
\           'sc:tt' : '<script type="text/html" id="|"></script>'
\       }
\   },
\   'javascript' : {
\       'aliases' : {
\       },
\       'snippets' : {
\           'u' : "'use strict';",
\           'c' : 'console.log(|);',
\           'jsi' : '// jshint ignore:line'
\       }
\   }
\}

" YouCompleteMe
"let g:ycm_add_preview_to_completeopt=0
"let g:ycm_confirm_extra_conf=0
"set completeopt-=preview

" Powerline
"let g:Powerline_symbols = 'fancy'
"set scroll=20

" Syntastic
"let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': ['perl']
\ }

" SimpleFold
let g:simplefold_expr = '\v^\s*[#%"0-9]{0,4}\s*\{(\{\{|!!)'
let g:simplefold_marker_start = '\v\{\{\{\{'
let g:simplefold_marker_end = '\v\}\}\}\}'

" JSON
let g:vim_json_syntax_conceal = 0

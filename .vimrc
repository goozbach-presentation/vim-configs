set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-perl/vim-perl'
Plugin 'flazz/vim-colorschemes'
Plugin 'elzr/vim-json'
Plugin 'vim-scripts/VimClojure'
Plugin 'plasticboy/vim-markdown'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" is this needed anymore?

filetype plugin indent on
set backspace=indent,eol,start
set showmatch
set smartindent
set background=dark
set nu
syntax on
set shiftround
set cursorline
set matchpairs+=<:>
"set matchpairs+=<:>,«:»
set showcmd

set ruler
"automatically set ambient, TODO: need to do this with the others
" nmap yw yaw
omap w iw

"iab pdbg  use Data::Dumper 'Dumper';\nwarn Dumper [];^[hi
let g:perl_fold = 1
let perl_fold=1
let perl_fold_blocks=1

let foldlevelstart=1

set pastetoggle=<F11>
nmap <leader>G   :ToggleGitMenu<CR>
" incremental search
set incsearch
set bg=dark

" show matching brackets
autocmd FileType perl set showmatch

" show line numbers
autocmd FileType perl set number

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite
autocmd FileType perl set keywordprg=perldoc

" dont use Q for Ex mode
map Q :q

" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F11>

" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>

" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>

set wrap

"au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove
autocmd BufNewFile,BufRead  *.t                     setfiletype perl

"=====[ Comments are important ]==================

highlight Comment term=bold ctermfg=white


" local subs can be completed ctrl-x ctrl-d
set define=^\\s*\(sub\|func\|method\)
"set define=^\\s*sub

set keywordprg=perldoc
set virtualedit=block
"vmap <expr> > ShiftAndKeepVisualSelection ....


"====[ Edit and auto-update this config file and plugins ]==========

augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

nmap <silent>  ;v   [Edit .vimrc]          :next $MYVIMRC<CR>
nmap           ;vv  [Edit .vim/plugin/...] :next $HOME/.vim/plugin/



"====[ Use persistent undo ]=================

if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)...
    set undodir=$HOME/tmp/.VIM_UNDO_FILES

    " Save a lot of back-history...
    set undolevels=5000

    " Actually switch on persistent undo
    set undofile

endif


"====[ Goto last location in non-empty files ]=======

autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif


"====[ I'm sick of typing :%s/.../.../g ]=======

nmap S                         :%s//g<LEFT><LEFT>
vmap S                         :s//g<LEFT><LEFT>

"====[ Toggle visibility of naughty characters ]============

" Make naughty characters visible...
" (uBB is right double angle, uB7 is middle dot)
exec "set lcs=tab:\uBB\uBB,trail:\uB7,nbsp:~"
" This is showing the bad tabs, but what broke to cause them?

augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter  *       set list
    autocmd BufEnter  *.txt   set nolist
    autocmd BufEnter  *.vp*   set nolist
    autocmd BufEnter  *       if !&modifiable
    autocmd BufEnter  *           set nolist
    autocmd BufEnter  *       endif
augroup END



"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
highlight clear Search
highlight       Search    ctermfg=White

"Delete in normal mode switches off highlighting till next search...
nmap <silent> <BS> :nohlsearch

"Delete in normal mode to switch off highlighting till next search and clear messages...
"Nmap <silent> <BS> [Cancel highlighting]  :call HLNextOff() <BAR> :nohlsearch <BAR> :call VG_Show_CursorColumn('off')<CR>



"Double-delete to remove trailing whitespace...
"Nmap <silent> <BS><BS>  [Remove trailing whitespace] mz:call TrimTrailingWS()<CR>`z

function! TrimTrailingWS ()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunction


"=======[ Fix smartindent stupidities ]============

set autoindent                              "Retain indentation on next line
set smartindent                             "Turn on autoindenting of blocks

inoremap # X<C-H>#|                         "And no magic outdent for comments
nnoremap <silent> >> :call ShiftLine()<CR>| "And no shift magic on comments

function! ShiftLine()
    set nosmartindent
    normal! >>
    set smartindent
endfunction

inoremap <silent> #  X<C-H>#<C-R>=SmartOctothorpe()<CR>|  "And no magic outdent for comments

function! SmartOctothorpe ()
    if &filetype =~ '^perl' && search('^.\{-}\S.\{-}\s#\%#$','bn')
        return "\<ESC>:call EQAS_Align('nmap',{'pattern':'\\%(\\S\\s*\\)\\@<=#'})\<CR>A"
    else
        return ""
    endif
endfunction

"====[ I hate modelines ]===================

set modelines=0

"=====[ Make Visual modes work better ]==================

"Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
vmap <BS> x

" Make vaa select the entire file...
vmap aa VGo1G


"=====[ Remap space key to something more useful ]========================

" Use space to jump down a page (like browsers do)...
nnoremap <Space> <PageDown>

"=====[ Make arrow keys move visual blocks around ]======================

runtime plugin/dragvisuals.vim

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()
vmap  <expr>  <C-D>    DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1



"=====[ Always syntax highlight .patch and ToDo files ]=======================

augroup PatchHighlight
    autocmd!
    autocmd BufEnter  *.patch,*.diff  let b:syntax_was_on = exists("syntax_on")
    autocmd BufEnter  *.patch,*.diff  syntax enable
    autocmd BufLeave  *.patch,*.diff  if !b:syntax_was_on
    autocmd BufLeave  *.patch,*.diff      syntax off
    autocmd BufLeave  *.patch,*.diff  endif
augroup END

augroup TODOHighlight
    autocmd!
    autocmd BufEnter  *.todo,todo,ToDo,TODO  let b:syntax_was_on = exists("syntax_on")
    autocmd BufEnter  *.todo,todo,ToDo,TODO  syntax enable
    autocmd BufLeave  *.todo,todo,ToDo,TODO  if !b:syntax_was_on
    autocmd BufLeave  *.todo,todo,ToDo,TODO      syntax off
    autocmd BufLeave  *.todo,todo,ToDo,TODO  endif
augroup END



"=====[ Search folding ]=====================

    " Toggle on and off...
    "nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})

    " Show only sub defns (and maybe comments)...
    "let perl_sub_pat = '^\s*\%(sub\|func\|method\)\s\+\k\+'
    "let vim_sub_pat  = '^\s*fu\%[nction!]\s\+\k\+'
    "augroup FoldSub
    "    autocmd!
    "    autocmd BufEnter * nmap <silent> <expr>  zp  FS_FoldAroundTarget(perl_sub_pat,{'context':1})
    "    autocmd BufEnter * nmap <silent> <expr>  za  FS_FoldAroundTarget(perl_sub_pat.'\\|^\s*#.*',{'context':0, 'folds':'invisible'})
    "    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  zp  FS_FoldAroundTarget(vim_sub_pat,{'context':1})
    "    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  za  FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
    "augroup END

    " Show only C #includes...
    " nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})

"=====[ Search folding ]=====================

" Toggle on and off...
" nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})

" Show only Perl sub defns...
" nmap <silent> <expr>  zp  FS_FoldAroundTarget('^\s*sub\s\+\w\+',{'context':1})

" Show only Perl sub defns and comments...
" nmap <silent> <expr>  za  FS_FoldAroundTarget('^\s*\%(sub\s.*\\|#.*\)',{'context':0, 'folds':'invisible'})

" Show only C #includes...
" nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})


"=====[ Show the column marker in visual insert mode ]====================

vnoremap <silent>  I  I<C-R>=TemporaryColumnMarkerOn()<CR>
vnoremap <silent>  A  A<C-R>=TemporaryColumnMarkerOn()<CR>

function! TemporaryColumnMarkerOn ()
    set cursorcolumn
    inoremap <silent>  <ESC>  <ESC>:call TemporaryColumnMarkerOff()<CR>
    return ""
endfunction

function! TemporaryColumnMarkerOff ()
    set nocursorcolumn
    iunmap <ESC>
endfunction

"======[ Magically build interim directories if necessary ]===================

    function! AskQuit (msg, options, quit_option)
        if confirm(a:msg, a:options) == a:quit_option
            exit
        endif
    endfunction

    function! EnsureDirExists ()
        let required_dir = expand("%:h")
        if !isdirectory(required_dir)
            call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
                \       "&Create it\nor &Quit?", 2)

            try
                call mkdir( required_dir, 'p' )
            catch
                call AskQuit("Can't create '" . required_dir . "'",
                \            "&Quit\nor &Continue anyway?", 1)
            endtry
        endif
    endfunction

    augroup AutoMkdir
        autocmd!
        autocmd  BufNewFile  *  :call EnsureDirExists()
    augroup END


"====[ Execute Perl file ]=====================

    nmap W :!clear;echo;echo;polyperl %;echo;echo;echo<CR>

"====[ Execute Perl file (output to pager) ]=====================

    nmap E :!polyperl -m %<CR>

"====[ Execute Perl file (in debugger) ]=====================

    nmap Q :!polyperl -d %<CR>

    " Debugging simplifcations...
    imap dbs  $DB::single = 1;
    nmap BB   Odbs<ESC><CR>


"====[ Mappings for eqalignsimple.vim (character-based alignments) ]===========

    " Align contiguous lines at the same indent...
    nmap <silent> =     :call CharAlign('nmap')<CR>
    nmap <silent> +     :call CharAlign('nmap', {'cursor':1} )<CR>

    " Align continuous lines in the same paragraph...
    nmap <silent> ==    :call CharAlign('nmap', {'paragraph':1} )<CR>
    nmap <silent> ++    :call CharAlign('nmap', {'cursor':1, 'paragraph':1} )<CR>

    " Align continuous lines in the current visual block
    vmap <silent> =     :call CharAlign('vmap')<CR>
    vmap <silent> +     :call CharAlign('vmap', {'cursor':1} )<CR>

"====[ Mapping for colalignsimple.vim (whitespace-based alignments) ]=======

    " Align next unaligned multi-whitespace-delimited column...
    nmap <silent> ]     :call WSColumnAlign()<CR>


"====[ Mapping for smartcom.vim ("duplicate the above spacing) ]===============

    " Search previous line for repeated punctuation and repeat it...
    "inoremap <silent> <S-TAB> <c-r><c-r>=CompletePadding()<CR>
    "New section handling this below.


"====[ Switch on temporary column marker during Visual inserts and appends ]===

    vnoremap <silent>  I  I<C-R>=TemporaryColumnMarkerOn()<CR>
    vnoremap <silent>  A  A<C-R>=TemporaryColumnMarkerOn()<CR>

    function! TemporaryColumnMarkerOn ()
        let g:prev_cursorcolumn_state = g:cursorcolumn_visible ? 'on' : 'off'
        set cursorcolumn
        inoremap <silent>  <ESC>  <ESC>:call TemporaryColumnMarkerOff(g:prev_cursorcolumn_state)<CR>
        return ""
    endfunction

    function! TemporaryColumnMarkerOff (newstate)
        call Toggle_CursorColumn(a:newstate)
        iunmap <ESC>
    endfunction


"====[ Make 't mapping find and run tests in surrounding dirs ]==========

    let g:PerlTests_program       = 'prove'       " ...What to call
    let g:PerlTests_search_height = 5             " ...How far up to search
    let g:PerlTests_test_dir      = '/t'          " ...Where to look for tests

    augroup Perl_Tests
        autocmd!
        autocmd BufEnter *.p[lm]  nmap <buffer> ;t  :call RunPerlTests()<CR>
        autocmd BufEnter *.t      nmap <buffer> ;t  :call RunPerlTests()<CR>
    augroup END

    function! RunPerlTests ()
        " Start in the current directory...
        let dir = expand('%:h')

        " Walk up through parent directories, looking for a test directory...
        for n in range(g:PerlTests_search_height)
            " When found...
            if isdirectory(dir . g:PerlTests_test_dir)
                " Go there...
                silent exec 'cd ' . dir

                " Run the tests...
                exec ':!' . g:PerlTests_program

                " Return to the previous directory...
                silent cd -
                return
            endif

            " Otherwise, keep looking up the directory tree...
            let dir = dir . '/..'
        endfor

        " If not found, report the failure...
        echohl WarningMsg
        echomsg "Couldn't find a suitable" g:PerlTests_test_dir '(tried' g:PerlTests_search_height 'levels up)'
        echohl None
    endfunction


"====[ Make ;m mapping check file validity before attempting tests ]==========

    nmap ;m :make<CR><CR><CR>:call PerlMake_Cleanup()<CR>

    function! PerlMake_Cleanup ()
        " If there are errors, show the first of them...
        if !empty(getqflist())
            cc

        " Otherwise, run the test suite as well...
        else
            call RunPerlTests()
        endif
    endfunction

    set makeprg=polyperl\ -vc\ %\ $*

    " Show error lines prettily...
    augroup PerlMake
        autocmd!
        autocmd BufReadPost quickfix  setlocal number
                                 \ |  setlocal nowrap
                                 \ |  setlocal modifiable
                                 \ |  silent! %s/^[^|]*\//.../
                                 \ |  setlocal nomodifiable
    augroup END


"====[ Make ;m mapping check file validity before attempting tests ]==========

    nmap ;m :make<CR><CR><CR>:call PerlMake_Cleanup()<CR>

    function! PerlMake_Cleanup ()
        " If there are errors, show the first of them...
        if !empty(getqflist())
            cc

        " Otherwise, run the test suite as well...
        else
            call RunPerlTests()
        endif
    endfunction

    set makeprg=polyperl\ -vc\ %\ $*

    " Show error lines prettily...
    augroup PerlMake
        autocmd!
        autocmd BufReadPost quickfix  setlocal number
                                 \ |  setlocal nowrap
                                 \ |  setlocal modifiable
                                 \ |  silent! %s/^[^|]*\//.../
                                 \ |  setlocal nomodifiable
    augroup END


"=====[ Cut and paste from MacOSX clipboard ]====================

" Paste carefully in Normal mode...
nmap <silent> <C-P> :set paste<CR>
                   \:let b:prevlen = len(getline(0,'$'))<CR>
                   \!!pbpaste<CR>
                   \:set nopaste<CR>
                   \:set fileformat=unix<CR>
                   \mv
                   \:exec 'normal ' . (len(getline(0,'$')) - b:prevlen) . 'j'<CR>
                   \V`v

" When in Visual mode, paste over the selected region...
vmap <silent> <C-P> x:call TransPaste(visualmode())<CR>

function! TransPaste(type)
    " Remember the last yanked text...
    let reg_save = @@

    " Grab the MacOSX clipboard contents via a shell command...
    let clipboard = system("pbpaste")

    " Put them in the yank buffer...
    call setreg('@', clipboard, a:type)

    " Paste them...
    silent exe "normal! P"

    " Restore the previous yanked text...
    let @@ = reg_save
endfunction


" In Normal mode, yank the entire buffer...
nmap <silent> <C-C> :w !pbcopy<CR><CR>

" In Visual mode, yank the selection...
vmap <silent> <C-C> :<C-U>call TransCopy(visualmode(), 1)<CR>

function! TransCopy(type, ...)
    " Yank inclusively (but remember the previous setup)...
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    " Invoked from Visual mode, use '< and '> marks.
    if a:0
        silent exe "normal! `<" . a:type . "`>y"

    " Or yank a line, if requested...
    elseif a:type == 'line'
        silent exe "normal! '[V']y"

    " Or yank a block, if requested...
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]y"

    " Or else, just yank the range...
    else
        silent exe "normal! `[v`]y"
    endif

    " Send it to the MacOSX clipboard...
    call system("pbcopy", @@)

    " Restore the previous setup...
    let &selection = sel_save
    let @@ = reg_save
endfunction

"====[ Ensure autodoc'd plugins are supported ]===========

runtime plugin/_autodoc.vim


"=====[ Always syntax highlight .patch and ToDo files ]=======================

augroup PatchHighlight
    autocmd!
    autocmd BufEnter  *.patch,*.diff  let b:syntax_was_on = exists("syntax_on")
    autocmd BufEnter  *.patch,*.diff  syntax enable
    autocmd BufLeave  *.patch,*.diff  if !b:syntax_was_on
    autocmd BufLeave  *.patch,*.diff      syntax off
    autocmd BufLeave  *.patch,*.diff  endif
augroup END

augroup TODOHighlight
    autocmd!
    autocmd BufEnter  *.todo,todo,ToDo,TODO  let b:syntax_was_on = exists("syntax_on")
    autocmd BufEnter  *.todo,todo,ToDo,TODO  syntax enable
    autocmd BufLeave  *.todo,todo,ToDo,TODO  if !b:syntax_was_on
    autocmd BufLeave  *.todo,todo,ToDo,TODO      syntax off
    autocmd BufLeave  *.todo,todo,ToDo,TODO  endif
augroup END

"=====[ Configure % key (via matchit plugin) ]==============================

" Match angle brackets...
"set matchpairs+=<:>,«:»

" Match double-angles, XML tags and Perl keywords...
let TO = ':'
let OR = ','
let b:match_words =
\
\                          '<<' .TO. '>>'
\
\.OR.     '<\@<=\(\w\+\)[^>]*>' .TO. '<\@<=/\1>'
\
\.OR. '\<if\>' .TO. '\<elsif\>' .TO. '\<else\>'

" Engage debugging mode to overcome bug in matchpairs matching...
let b:match_debug = 1


"=====[ Miscellaneous features (mainly options) ]=====================

set title           "Show filename in titlebar of window
set titleold=

set nomore          "Don't page long listings

set autowrite       "Save buffer automatically when changing files
set autoread        "Always reload buffer when external changes detected

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +--Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000

set fileformats=unix,mac,dos        "Handle Mac and DOS line-endings
                                    "but prefer Unix endings

set infercase                       "Adjust completions to match case

set noshowmode                      "Suppress mode change messages

set scrolloff=2                     "Scroll when 2 lines from top/bottom

" Insert cut marks...
nmap -- A<CR><CR><CR><ESC>k6i-----cut-----<ESC><CR>

" Indent/outdent current block...
nmap %% $>i}``
nmap $$ $<i}``

" =====[ Perl programming support ]===========================


"Adjust keyword characters to match Perlish identifiers...
set iskeyword+=$
set iskeyword+=%
set iskeyword+=@-@
set iskeyword+=:
set iskeyword-=,


"=====[ Emphasize typical mistakes in Vim and Perl files ]=========

" Add a new high-visibility highlight combination...
highlight WHITE_ON_RED    ctermfg=white  ctermbg=red

" Emphasize undereferenced references...
call matchadd('WHITE_ON_RED', '_ref[ ]*[[{(]\|_ref[ ]*-[^>]')

" Emphasize typical mistakes a Perl hacker makes in .vim files...
let g:VimMistakes
\   =     '\_^\s*\zs\%(my\s\+\)\?\%(\k:\)\?\k\+\%(\[.\{-}\]\)\?\s*[+-.]\?=[=>~]\@!'
\   . '\|'
\   .     '\_^\s*\zselsif'
\   . '\|'
\   .     ';\s*\_$'
\   . '\|'
\   .     '\_^\s*\zs#.*'
\   . '\|'
\   .     '\_^\s*\zs\k\+('

let g:VimMistakesID = 668
augroup VimMistakes
    autocmd!
    autocmd BufEnter  *.vim,*.vimrc   call VimMistakes_AddMatch()
    autocmd BufLeave  *.vim,*.vimrc   call VimMistakes_ClearMatch()
augroup END

function! VimMistakes_AddMatch ()
    try | call matchadd('WHITE_ON_RED',g:VimMistakes,10,g:VimMistakesID) | catch | endtry
endfunction

function! VimMistakes_ClearMatch ()
    try | call matchdelete(g:VimMistakesID) | catch | endtry
endfunction



" =====[ Smart completion via <TAB> and <S-TAB> ]=============

runtime plugin/smartcom.vim

" Add extra completions (mainly for Perl programming)...

let ANYTHING = ""
let NOTHING  = ""
let EOL      = '\s*$'

                " Left     Right      Insert                             Reset cursor
                " =====    =====      ===============================    ============
call SmartcomAdd( '<<',    ANYTHING,  '>>',                              {'restore':1} )
call SmartcomAdd( '<<',    '>>',      "\<CR>\<ESC>O\<TAB>"                             )
call SmartcomAdd( '«',     ANYTHING,  '»',                               {'restore':1} )
call SmartcomAdd( '«',     '»',       "\<CR>\<ESC>O\<TAB>"                             )
call SmartcomAdd( '{{',    ANYTHING,  '}}',                              {'restore':1} )
call SmartcomAdd( '{{',    '}}',      NOTHING,                                         )
call SmartcomAdd( 'qr{',   ANYTHING,  '}xms',                            {'restore':1} )
call SmartcomAdd( 'qr{',   '}xms',    "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>"                 )
call SmartcomAdd( 'm{',    ANYTHING,  '}xms',                            {'restore':1} )
call SmartcomAdd( 'm{',    '}xms',    "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>",                )
call SmartcomAdd( 's{',    ANYTHING,  '}{}xms',                          {'restore':1} )
call SmartcomAdd( 's{',    '}{}xms',  "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>",                )
call SmartcomAdd( '\*\*',  ANYTHING,  '**',                              {'restore':1} )
call SmartcomAdd( '\*\*',  '\*\*',    NOTHING,                                         )

" In the middle of a keyword: delete the rest of the keyword before completing...
                " Left     Right                    Insert
                " =====    =====                    =======================
"call SmartcomAdd( '\k',    '\k\+\%(\k\|\n\)\@!',    "\<C-O>cw\<C-X>\<C-N>",           )
"call SmartcomAdd( '\k',    '\k\+\_$',               "\<C-O>cw\<C-X>\<C-N>",           )

"After an alignable, align...
function! AlignOnPat (pat)
    return "\<ESC>:call EQAS_Align('nmap',{'pattern':'" . a:pat . "'})\<CR>/" . a:pat . "/e\<CR>:nohlsearch\<CR>a\<SPACE>"
endfunction
                " Left         Right        Insert
                " ==========   =====        =============================
call SmartcomAdd( '=',         ANYTHING,    "\<ESC>:call EQAS_Align('nmap')\<CR>/=/\<CR>:nohlsearch\<CR>a\<SPACE>")
call SmartcomAdd( '=>',        ANYTHING,    AlignOnPat('=>'))
call SmartcomAdd( '\s#',       ANYTHING,    AlignOnPat('\%(\S\s*\)\@<= #'))
call SmartcomAdd( '[''"]\s*:', ANYTHING,    AlignOnPat(':'),                   {'filetype':'vim'} )
call SmartcomAdd( ':',         ANYTHING,    "\<TAB>",                          {'filetype':'vim'} )


                " Left         Right   Insert                                  Where
                " ==========   =====   =============================           ===================
" Vim keywords...
call SmartcomAdd( '^\s*func\%[tion]',
\                              EOL,    "\<C-W>function!\<CR>endfunction\<UP> ",{'filetype':'vim'} )
call SmartcomAdd( '^\s*for',   EOL,    " ___ in ___\n___\n\<C-D>endfor\n___",  {'filetype':'vim'} )
call SmartcomAdd( '^\s*if',    EOL,    " ___ \n___\n\<C-D>endif\n___",         {'filetype':'vim'} )
call SmartcomAdd( '^\s*while', EOL,    " ___ \n___\n\<C-D>endwhile\n___",      {'filetype':'vim'} )
call SmartcomAdd( '^\s*try',   EOL,    "\n\t___\n\<C-D>catch\n\t___\n\<C-D>endtry\n___", {'filetype':'vim'} )

" Perl keywords...
call SmartcomAdd( '^\s*for',   EOL,    " my $___ (___) {\n___\n}\n___",        {'filetype':'perl'} )
call SmartcomAdd( '^\s*if',    EOL,    " (___) {\n___\n}\n___",                {'filetype':'perl'} )
call SmartcomAdd( '^\s*while', EOL,    " (___) {\n___\n}\n___",                {'filetype':'perl'} )
call SmartcomAdd( '^\s*given', EOL,    " (___) {\n___\n}\n___",                {'filetype':'perl'} )
call SmartcomAdd( '^\s*when',  EOL,    " (___) {\n___\n}\n___",                {'filetype':'perl'} )

" Complete Perl module loads with the names of Perl modules...
call SmartcomAddAction( '^\s*use\s\+\k\+', "",
\                       'set complete=k~/.vim/perlmodules|set iskeyword+=:'
\)



"=====[ Show help files in a new tab, plus add a shortcut for helpg ]==============

let g:help_in_tabs = 1

nmap <silent> H  :let g:help_in_tabs = !g:help_in_tabs<CR>

"Only apply to .txt files...
augroup HelpInTabs
    autocmd!
    autocmd BufEnter  *.txt   call HelpInNewTab()
augroup END

"Only apply to help files...
function! HelpInNewTab ()
    if &buftype == 'help' && g:help_in_tabs
        "Convert the help window to a tab...
        execute "normal \<C-W>T"
    endif
endfunction

"Simulate a regular cmap, but only if the expansion starts at column 1...
function! CommandExpandAtCol1 (from, to)
    if strlen(getcmdline()) || getcmdtype() != ':'
        return a:from
    else
        return a:to
    endif
endfunction

"Expand hh -> helpg...
cmap <expr> hh CommandExpandAtCol1('hh','helpg ')


"=====[ Correct common mistypings in-the-fly ]=======================

iab    retrun  return
iab     pritn  print
iab       teh  the
iab      liek  like
iab  liekwise  likewise
iab      Pelr  Perl
iab      pelr  perl
iab        ;t  't
iab      moer  more
iab  previosu  previous

" "=====[ Grammar checking ]========================================

highlight GRAMMARIAN_ERRORS_MSG   ctermfg=red   cterm=bold
highlight GRAMMARIAN_CAUTIONS_MSG ctermfg=white cterm=bold

"=====[ Add or subtract comments ]===============================

" Work out what the comment character is, by filetype...
autocmd FileType             *sh,awk,python,perl,perl6,ruby    let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd FileType             vim                               let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd BufNewFile,BufRead   *.vim,.vimrc                      let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd BufNewFile,BufRead   *                                 let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd BufNewFile,BufRead   *.p[lm],.t                        let b:cmt = exists('b:cmt') ? b:cmt : '#'

" Work out whether the line has a comment then reverse that condition...
function! ToggleComment ()
    " What's the comment character???
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Grab the line and work out whether it's commented...
    let currline = getline(".")

    " If so, remove it and rewrite the line...
    if currline =~ '^' . comment_char
        let repline = substitute(currline, '^' . comment_char, "", "")
        call setline(".", repline)

    " Otherwise, insert it...
    else
        let repline = substitute(currline, '^', comment_char, "")
        call setline(".", repline)
    endif
endfunction

" Toggle comments down an entire visual selection of lines...
function! ToggleBlock () range
    " What's the comment character???
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Start at the first line...
    let linenum = a:firstline

    " Get all the lines, and decide their comment state by examining the first...
    let currline = getline(a:firstline, a:lastline)
    if currline[0] =~ '^' . comment_char
        " If the first line is commented, decomment all...
        for line in currline
            let repline = substitute(line, '^' . comment_char, "", "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    else
        " Otherwise, encomment all...
        for line in currline
            let repline = substitute(line, '^\('. comment_char . '\)\?', comment_char, "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    endif
endfunction

" Set up the relevant mappings
nmap <silent> # :call ToggleComment()<CR>j0
vmap <silent> # :call ToggleBlock()<CR>


"=====[ Highlight spelling errors on request ]===================

set spelllang=en_us
"Nmap <silent> ;s  [Toggle spell-checking]               :set invspell spelllang=en<CR>
"Nmap <silent> ;ss [Toggle Basic English spell-checking] :set    spell spelllang=en-basic<CR>

"======[ Create a toggle for the XML completion plugin ]=======

"Nmap ;x [Toggle XML completion] <Plug>XMLMatchToggle

"=====[ Make * respect smartcase and also set @/ (to enable 'n' and 'N') ]======

nmap *  :let @/ = '\<'.expand('<cword>').'\>' ==? @/ ? @/ : '\<'.expand('<cword>').'\>'<CR>n


"=====[ Autocomplete arrows ]===========================

inoremap <silent> =>  =><C-R>=SmartArrow()<CR>

function! SmartArrow ()
    if &filetype =~ '^perl' && search('^.\{-}\S.\{-}\s=>\%#$','bn')
        return "\<ESC>:call EQAS_Align('nmap',{'pattern':'\\%(\\S\\s*\\)\\@<==>'})\<CR>A"
    else
        return ""
    endif
endfunction


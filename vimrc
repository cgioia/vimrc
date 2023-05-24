" Hi! I'm Chad, and this is my vimrc.
" The latest version can be found at https://raw.github.com/cgioia/vimrc/master/vimrc

" Preamble ---------------------------------------------------------------- {{{
" We live in the futuar, turn off forced Vi-compatibility
set nocompatible

" Get the first runtime path for storing/reading some stuff later
let rtdirs = split( &runtimepath, ',' )
let vfdir = rtdirs[0]
let tmpdir = vfdir . "/.tmp"

" Set the map leader for future mappings
let mapleader=","
" }}}
" Editing Behavior -------------------------------------------------------- {{{
" File encoding and format
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" Tabs
set tabstop=8
set smarttab
set softtabstop=3
set shiftwidth=3
set shiftround
set expandtab

" General editing
set backspace=indent,eol,start
set autoindent
set smartindent
" set pastetoggle=<F12>
nnoremap <F12> :set paste!<CR>
" }}}
" Vim Behavior ------------------------------------------------------------ {{{
" Files and directories
set autoread
set autowrite
" set tags=tags;
set wildignore=*.swp,.git,.svn,.DS_Store,*.jpg,*.bmp,*.png,*.gif,*.tar*

" Visual indications
set showcmd
set showmode
set list
" Based on glyphs available in Consolas
" set listchars=tab:»\ ,eol:¬,extends:›,precedes:‹,trail:·
" Based on glyphs available in Hack
set listchars=tab:»\ ,eol:↵,extends:›,precedes:‹,trail:⋅
set showbreak=↪
" set showbreak=…
" set showbreak=→
set scrolloff=3
set sidescroll=1
set sidescrolloff=10
set completeopt=menuone,longest
" set title
if &term =~ '^screen'
   set t_ts=k
   set t_fs=\
endif
set mouse=a
set ttymouse=sgr

set numberwidth=4
set nonumber
set relativenumber

" Statusline {{{
set laststatus=2
" Statusline highlight groups {{{
" hi default link User1 Identifier
" hi default link User2 Statement
" hi default link User3 Error
" hi default link User4 Special
" }}}
" set statusline=[%2n]%<                " buffer number (do not truncate)

" set statusline+=%1*[%t]%*             " file name
" set statusline+=%2*%h%w%m%r%*         " flags

" set statusline+=%y                    " filetype
" set statusline+=[%{&ff}/%{strlen(&fenc)?&fenc:&enc}] " file encoding

" set statusline+=%=                    " right-align

" set statusline+=%-14(\ L%l/%L:C%c\ %) " current line and column
" set statusline+=%P                    " scroll percentage

" set statusline+=\ %3*${SyntasticStatuslineFlag()}%* " Syntastic
" }}}

" Cursorline {{{
if has ("autocmd")
   augroup cline
      au!
      au WinLeave,BufLeave * set nocursorline
      au WinEnter,BufEnter * set cursorline
      au InsertEnter * set nocursorline
      au InsertLeave * set cursorline
   augroup END
else
   set cursorline
endif
" }}}

" Backup files
set noswapfile
let &directory=tmpdir
set nobackup
let &backupdir=tmpdir
set undofile
let &undodir=tmpdir . "/undo"

" Buffers
set hidden
set switchbuf=useopen,usetab
set history=1000
set undolevels=1000

" Searching
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase
set gdefault

" Splits
set splitbelow
set splitright
if has ("autocmd")
   au VimResized * :wincmd =
endif

" Quickfix
if has("cscope")
   set cscopequickfix=s0,g0,d0,c0,t-,e-,f0,i-
endif

" tmux hacking from http://snk.tuxfamily.org/log/vim-256color-bce.html
" Make Vim recognize xterm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"

  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
" }}}
" gVim Settings ----------------------------------------------------------- {{{
if has( "gui_running" )
   if has( "gui_win32" )
      " Consolas is a pretty sweet monospace font (from Microsoft, no less!)
      " set guifont=Consolas:h9
      set guifont=Hack\ Regular:h8
      " Somewhat centered on my screen
      winpos 200 100
   elseif has( "gui_macvim" )
      " Fonts seem much smaller with MacVim, so go big here
      set guifont=Hack\ Regular:h12
      set guioptions-=r
      set guioptions+=R
   endif

   " Remove the toolbar, it's just wasting space
   set guioptions-=T

   " GUI is 50x120
   set lines=52
   set columns=124
endif
" }}}
" Highlighting ------------------------------------------------------------ {{{
" Syntax highlighting for fun and profit
syntax on

" Torte is super high-contrast, but has some annoying choices
" colorscheme torte
" highlight Pmenu guibg=brown gui=bold

" Molokai is a port of the popular TextMate color scheme
" colorscheme molokai

" Zenburn & associated configuration
" let g:zenburn_high_Contrast = 1
" let g:zenburn_alternate_Visual = 1
" colorscheme zenburn

" Solarized has both light and dark configurations
" if has("gui_running")
"    set background=light
" else
"    set background=dark
" endif
set background=light
colorscheme solarized
call togglebg#map("<leader>sbg")

" Use a very noticible highlight when going over length for the FileType
highlight link OverLength WarningMsg
" }}}
" Folding Settings -------------------------------------------------------- {{{
set foldenable
set foldmethod=manual
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Expression-based folding {{{
au BufRead,BufNewFile * let b:foldlevel = 0
au InsertLeave,WinLeave * let b:foldlevel = 0
au BufRead,BufNewFile * let b:incomment = 0

" This automatic toggle between manual and expr often caused folds to get
" reset after leaving insert mode, which caused many fits of rage
" au InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
" au InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" Functions to handle foldlevels
function! StartFold()
   let b:foldlevel = b:foldlevel + 1
   return ">".b:foldlevel
endfunction
function! EndFold()
   let thislevel = b:foldlevel
   let b:foldlevel = b:foldlevel - 1
   return "<".thislevel
endfunction
function! ContinueFold()
   return b:foldlevel
endfunction
" }}}

function! MyFoldText() "{{{
   let line = getline(v:foldstart)

   " let nucolwidth = &fdc + &number * &numberwidth
   let nucolwidth = &fdc + &relativenumber * &numberwidth
   let windowwidth = winwidth(0) - nucolwidth
   let foldedlinecount = v:foldend - v:foldstart

   let onetab = strpart('        ', 0, &tabstop)
   let line = substitute(line, '\t', onetab, 'g')

   let extrachars = 2
   let line = strpart(line, 0, windowwidth - extrachars - len(foldedlinecount))
   let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - extrachars
   return line . '…' . repeat(" ", fillcharcount) . foldedlinecount . ' '
endfunction "}}}
set foldtext=MyFoldText()
" }}}
" Plugin Settings --------------------------------------------------------- {{{
" Command-T {{{
let g:CommandTPreferredImplementation='ruby'
" }}}
" NERDTree {{{
let NERDTreeShowBookmarks = 1
let NERDTreeBookmarksFile=tmpdir . "/NERDTreeBookmarks"
let NERDTreeQuitOnOpen = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeMouseMode = 2
let NERDTreeDirArrows = 0

nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <F7> :NERDTreeFind<CR>
" }}}
" Tagbar {{{
let g:tagbar_left = 1
let g:tagbar_width = 38
let g:tagbar_iconchars = ['+', '-']

nnoremap <S-F8> :TagbarToggle<CR>
nnoremap <F8> :TagbarOpenAutoClose<CR>
" }}}
" Supertab {{{
" <C-X><C-O> is awkward and uncomfortable! I'd rather use tab.
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" }}}
" Ack {{{
" Do an <strike>grep</strike> Ack search
nmap <leader>a :Ack --smart-case ""<LEFT>
nmap <leader>s :Ack --literal <cword><CR>
" }}}
" YankRing {{{
" Toggle the yankring window
nnoremap <F2> :YRShow<CR>
let g:yankring_history_dir=tmpdir
" }}}
" Gundo {{{
nnoremap <F1> :GundoToggle<CR>
" }}}
" Syntastic {{{
let g:syntastic_stl_format='[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=2
" }}}
" Airline {{{
let g:airline_theme = "solarized"

let g:airline_section_y = '%{printf("%s%s%s", &fenc, strlen(&fenc) > 0 ? "  " : "", &ff)}'
let g:airline_section_error = ''
let g:airline_section_warning = ''

" manually configure airline for powerline symbols with unicode colnr until
" bug https://github.com/vim-airline/vim-airline/issues/2381 is fixed
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
" let g:airline_symbols.colnr = ' :'
let g:airline_symbols.colnr = ' ㏇:'
" let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' :'
let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty='⚡'

let g:airline#extensions#tmuxline#enabled = 1
" }}}
" Fugitive {{{
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gdiff<CR>
" }}}
" Linediff {{{
nnoremap <leader>ld :Linediff<CR>
nnoremap <leader>lr :LinediffReset<CR>
vnoremap <leader>ld :Linediff<CR>
vnoremap <leader>lr :LinediffReset<CR>
" }}}
" }}}
" Shortcut Mappings ------------------------------------------------------- {{{
" For ease of updating this file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" No shift to type Ex commands
nnoremap ; :

if has("cscope") "{{{
   " command! LoadCscope call LoadCscopeDb()
   " function! LoadCscopeDb()
   "    " Search up recursively for the cscope database file
   "    let cscope_db=findfile("cscope.out", ".;")
   "    if filereadable(cscope_db)
   "       silent! execute "cscope add" cscope_db
   "       " strip the file name out of the path, then cd to it
   "       let cscdb_path=join(split(cscope_db, '[\\/]')[0:-2], '/')
   "       silent! execute "cd" strlen(cscdb_path) > 0 ? "/" . cscdb_path : ""
   "    endif
   " endfunction

   " Load/Kill the cscope database
   " nnoremap <leader>lc :LoadCscope<CR>
   nnoremap <leader>lc :cscope add cscope.out<CR>
   nnoremap <leader>kc :cscope kill -1<CR>

   " Shortcut to do cscope file searches
   nmap gf <C-\>f

   " Shortcut to do a cscope search
   nmap <F4> <C-\>s
endif "}}}

" Make regexs more Perl-like
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Quickly get out of insert mode without your fingers having to leave the
" home row
inoremap jj <Esc>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" No, seriously, write it. I mean it.
cnoremap w!! w !sudo tee % >/dev/null

" Un-highlight search queries
nnoremap <silent> <leader><space> :noh<CR>:call clearmatches()<CR>

" Toggle Quickfix window
nnoremap <silent> <leader>q :QFix<CR> "{{{
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
   if exists("g:qfix_win") && a:forced == 0
      cclose
      unlet g:qfix_win
   else
      copen 10
      let g:qfix_win = bufnr("$")
   endif
endfunction "}}}

" If my usual method of jumping to a tag (<C-LeftMouse>) doesn't work...
nnoremap <F5> g<C-]>

" Copy to the system clipboard
nnoremap <F6> "*y
vnoremap <F6> "*y

" Sometimes expression folding is just too damn high^H^H^H^Hslow
nnoremap <F3> :FoldMethodToggle<CR> "{{{
command! FoldMethodToggle call ToggleFoldMethod()
function! ToggleFoldMethod()
   if ( &foldmethod == "expr" )
      setlocal foldmethod=manual
      execute "normal! zE"
   else
      let b:foldlevel=0
      setlocal foldmethod=expr
   endif
endfunction "}}}

" Open folds when searching
nnoremap <silent> n nzv
nnoremap <silent> N Nzv

" Swap the mark/mark-bol keys
nnoremap ' `
nnoremap ` '

" Toggle list characters
nnoremap <leader>i :set list!<CR>

" Movement whilst insert
inoremap <C-a> <ESC>I
inoremap <C-e> <ESC>A
" }}}
" FileType-specific Handling ---------------------------------------------- {{{
if has ("autocmd")
   augroup cpp_files "{{{
      au!
      function! CPP_foldexpr(lnum) "{{{
         let l1 = getline(a:lnum)

         " Skip the line if it's blank, commented, or a preprocessor command
         if l1 =~ '^\s*\%(\%(//.*\)\|\%(/\*.*\*/\s*\)\|\%(#.\+\)\)\?$'
            return ContinueFold()
         endif

         " Folding comments
         if b:incomment
            " We're inside a C-style comment, either end it or ignore it
            if l1 =~ '\*/'
               let b:incomment = 0
               return EndFold()
            else
               return ContinueFold()
            endif
         elseif l1 =~ '^\s*/\*[^/]*$'
            " Fold the current line if it begins with a C-style comment, and
            " doesn't end on the same line
            let b:incomment = 1
            return StartFold()
         endif

         " Folding Brackets
         if l1 =~ '^[^{]*}'
            " End a fold at close brace that's not opened on the same line
            return EndFold()
         elseif l1 =~ '^[^{]*$' && getline(a:lnum+1) =~ '^\s*{[^}]*$'
            " Fold the current line if it doesn't have an open brace and the
            " next line starts with one
            return StartFold()
         elseif l1 =~ '{[^}]*$' && getline(a:lnum-1) =~ '\%([{},;]\s*$\)\|\%(^\s*\%([#/\*].\+\)\?$\)'
            " Fold current line if it has an open brace and the previous line
            " ends with a comma, open brace, closed brace, semicolon, or is otherwise ignored
            return StartFold()
         endif

         " Don't fold anything else
         return ContinueFold()
      endfunction "}}}
      au FileType cpp,c setlocal foldexpr=CPP_foldexpr(v:lnum)
      " au FileType cpp,c setlocal foldmethod=expr
      au FileType cpp,c setlocal foldnestmax=3
      au FileType cpp,c match OverLength /\%121v.\+/
      au FileType cpp setlocal commentstring=//\ %s
   augroup end "}}}
   augroup snippets "{{{
      au!
      au FileType snippet setlocal nofoldenable
      au FileType snippet setlocal noexpandtab
      au FileType snippet setlocal nosmarttab
   augroup end "}}}
   augroup vim_files "{{{
      au!
      au FileType vim setlocal foldmethod=marker
   augroup end "}}}
   augroup perl_files "{{{
      au!
      au FileType perl setlocal foldmethod=syntax
   augroup end "}}}
   augroup python "{{{
      au!
      au FileType python setlocal noexpandtab
      au FileType python setlocal nosmarttab
      au FileType python setlocal tabstop=3
   augroup end "}}}
endif
" }}}

" Hi! I'm Chad, and this is my vimrc.

" Preamble {{{
" We live in the futuar, turn off forced Vi-compatibility
set nocompatible

" Since pathogen lives as its own bundle, so source it first.
runtime bundle/vim-pathogen/autoload/pathogen.vim

" Calling 'filetype off' when it's already off causes vim to exit with a
" non-zero status. So I make sure it's on first.
filetype on
filetype off

" Set-up pathogen to include all plugins under bundle directory.
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on

" Use ',' as the leader, it's way easier than '\'.
let mapleader=","
"}}}

" Editing Behavior {{{
set encoding=utf-8
set tabstop=8
set smarttab
set softtabstop=3
set shiftwidth=3
set backspace=indent,eol,start
set expandtab
set autoindent
set smartindent
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase
set gdefault
set completeopt=menuone,longest
"}}}

" Vim Behavior {{{
set showcmd
set autochdir
set showmode
set nobackup
set noswapfile
set hidden
set laststatus=2
set switchbuf=useopen,usetab
set history=1000
set undolevels=1000
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)
set tags=tags;
set list
set listchars=tab:»\ ,eol:¬,extends:#,precedes:«,trail:·
set showbreak=›
set cursorline
set scrolloff=4
"}}}

" gVim Settings {{{
if has("gui_running")
   if has("gui_win32")
      " Consolas is a pretty sweet monospace font (from Microsoft, no less!)
      set guifont=Consolas:h9
      " Somewhat centered on my screen
      winpos 200 100
   elseif has("gui_mac")
      " Fonts seem much smaller with MacVim, so go big here
      set guifont=Inconsolata:h14
   endif

   " Remove the toolbar, it's just wasting space
   set guioptions-=T

   " GUI is 50x120
   set lines=52
   set columns=124

   " Those extra 5 columns are for 5 digits of line numbers
   " Except it's 4 now, for relative number
   set nonumber
   set numberwidth=4
   set relativenumber
endif
"}}}

" Highlighting {{{
" Syntax highlighting for fun and profit
syntax on

" I like pretty colors! But I'm too lazy to define my own.
" Torte is super high-contrast, but has some annoying choices
"colorscheme torte
"highlight Pmenu guibg=brown gui=bold

"colorscheme molokai

" Zenburn & associated configuration
"let g:zenburn_high_Contrast = 1
"let g:zenburn_alternate_Visual = 1
"colorscheme zenburn

" Solarized has both light and dark configurations
if has("gui_running")
   set background=light
else
   set background=dark
endif
let g:solarized_termcolors=256
colorscheme solarized
call togglebg#map("<S-F2>")

" Use a very noticible highlight when going over length for the FileType
highlight link OverLength WarningMsg
"}}}

" Folding Settings {{{
set foldenable
set foldmethod=manual
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Expression-based folding {{{
au BufRead,BufNewFile * let b:foldlevel = 0
au InsertLeave,WinLeave * let b:foldlevel = 0
au BufRead,BufNewFile * let b:incomment = 0

" This automatic toggle between manual and expr often caused folds to get
" reset after leaving insert mode, which caused many fits of rage.
"au InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
"au InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

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
"}}}

function! MyFoldText() "{{{
   let line = getline(v:foldstart)

   "let nucolwidth = &fdc + &number * &numberwidth
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
"}}}

" Plugin Settings {{{
" NERDTree {{{
let NERDTreeShowBookmarks = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeMouseMode = 2
let NERDTreeWinSize = 38

nmap <F7> :NERDTreeToggle<CR>
"}}}

" Tagbar {{{
let g:tagbar_left = 1
let g:tagbar_width = 38

map <F8> :TagbarOpenAutoClose<CR>
map <S-F8> :TagbarToggle<CR>
"}}}

" Supertab {{{
" <C-X><C-O> is awkward and uncomfortable! I'd rather use tab.
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"}}}

" ClearCase {{{
" Check-out un-reserved
map <F9> :ctcou<CR>
" Check-out reserved
map <S-F9> :ctco<CR>
" Check-in
map <F10> :ctci<CR>
" Un-check-out
map <S-F10> :ctunco<CR>
" Diff
map <F11> :ctdiff<CR>
"}}}

" Ack {{{
" Do an <strike>grep</strike> Ack search.
nmap <leader>a :Ack<space>
"}}}

" YankRing {{{
" Toggle the yankring window
nmap <F2> :YRShow<CR>
"}}}
"}}}

" Shortcut Mappings {{{
" For ease of updating this file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" No shift to enter ex-mode
nnoremap ; :

" Cscope stuffs
if has("cscope")
   command! LoadCscope call LoadCscopeDb()
   function! LoadCscopeDb()
      " Search up recursively for the cscope database files
      let cscope_db=findfile("cscope.out", ".;")
      if filereadable(cscope_db)
         silent! execute "cscope add" cscope_db
      endif
   endfunction

   " Load/Kill the cscope database
   nmap <leader>lc :LoadCscope<CR>
   nmap <leader>kc :cscope kill 0<CR>
   "
   " Shortcut to do cscope file searches
   nmap <F3> :cs find f<space>
   nmap <C-F3> :tab cs find f<space>
   nmap gf <C-\>f

   " Shortcut to do a cscope search
   nmap <F4> <C-\>s
   nmap <S-F4> :cs find s<space>
endif

" Make regexs more Perl-like
nnoremap / /\v
vnoremap / /\v

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
nnoremap <S-Space> zA
vnoremap <S-Space> zA

" No, seriously, write it. I mean it.
cmap w!! w !sudo tee % >/dev/null

" Un-highlight search queries
nnoremap <silent> <leader><space> :noh<CR>

" Toggle Quickfix window
nmap <silent> <leader>q :QFix<CR> "{{{
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
   if exists("g:qfix_win") && a:forced == 0
      cclose
      unlet g:qfix_win
   else
      copen 10
      let g:qfix_win = bufnr("$")
   endif
endfunction
"}}}

" If my usual method of jumping to a tag (<C-LeftMouse>) doesn't work...
nmap <F5> g<C-]>

" Copy to the Windows clipboard
map <F6> "*y

" Sometimes expression folding is just too damn high^H^H^H^Hslow.
map <C-F3> :FoldMethodToggle<CR> "{{{
command! FoldMethodToggle call ToggleFoldMethod()
function! ToggleFoldMethod()
   if ( &foldmethod == "expr" )
      setlocal foldmethod=manual
   else
      let b:foldlevel=0
      setlocal foldmethod=expr
   endif
endfunction "}}}

" Rarely, after doing undo-type things, folds need to be reset.
map <C-F2> :FoldMethodReset<CR> "{{{
command! FoldMethodReset call ResetFoldMethod()
function! ResetFoldMethod()
   if ( &foldmethod == "expr" )
      let b:foldlevel=0
      setlocal foldmethod=expr
   endif
endfunction "}}}
"}}}

" FileType-specific handling {{{
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
         elseif l1 =~ '{[^}]*$' && getline(a:lnum-1) =~ '\%([{,;]\s*$\)\|\%(^\s*\%([#/\*].\+\)\?$\)'
            " Fold current line if it has an open brace and the previous line
            " ends with a comma, open brace, semicolon, or is otherwise ignored
            return StartFold()
         endif

         " Don't fold anything else
         return ContinueFold()
      endfunction "}}}
      au FileType cpp,c setlocal foldexpr=CPP_foldexpr(v:lnum)
      au FileType cpp,c setlocal foldmethod=expr
      au FileType cpp,c setlocal foldnestmax=3
      au FileType cpp,c match OverLength /\%121v.\+/
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
endif
"}}}

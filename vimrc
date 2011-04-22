" Hi, I'm Chad, and this is my _vimrc.

" Preamble {{{
" We live in the futuar, turn off forced Vi-compatibility
set nocompatible

" Functions {{{
" QFix/QFixToggle {{{
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
" }}}

" LoadCscopeDb {{{
command! LoadCscope call LoadCscopeDb()
function! LoadCscopeDb()
   " Search up recursively for the cscope database files
   let cscope_db=findfile("cscope.out", ".;")
   if filereadable(cscope_db)
      silent! execute "cscope add" cscope_db
   endif
endfunction
" }}}
" }}}

" Stupid kludge to keep these things from running when
" running the outdated copy of Vim from Cygwin
if v:version >= 703
   " Set-up pathogen to include all plugins under vimfiles/bundle directory.
   filetype off
   call pathogen#runtime_append_all_bundles()
   call pathogen#helptags()
   filetype plugin indent on

   " Find and load the cscope database
   call LoadCscopeDb()
endif

" Use ',' as the leader, it's way easier than '\'.
let mapleader=","
"}}}

" Editing Behavior {{{
set showmode
set tabstop=8
set smarttab
set softtabstop=3
set shiftwidth=3
set backspace=indent,eol,start
set ruler
set expandtab
set autoindent
set smartindent
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase
set gdefault
" }}}

" Vim Behavior {{{
set showcmd
set autochdir
set nobackup
set noswapfile
set hidden
set laststatus=2
set switchbuf=useopen
set history=1000
set undolevels=1000
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)
" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk
" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '
" Quickly get out of insert mode without your fingers having to leave the
" home row
inoremap jj <Esc>
" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %
" }}}

" gVim Settings {{{
if has("gui_running")
   " Consolas is a pretty sweet monospace font (from Microsoft, no less!)
   set guifont=Consolas:h9:cANSI

   " Remove the toolbar, it's just wasting space
   set guioptions-=T
   set guioptions-=m

   " GUI is 50x85
   set lines=52
   set columns=85

   " Those extra 5 columns are for 5 digits of line numbers
   set numberwidth=5
   set nu
endif
" }}}

" Highlighting {{{
" Syntax highlighting for fun and profit
syntax on

" I like pretty colors! But I'm too lazy to define my own.
colorscheme torte

" Okay, I lied, I'll define a FEW of my own.
highlight ColorColumn guibg=darkgray
highlight OverLength guibg=darkmagenta
" }}}

" Folding Settings {{{
set foldenable
set foldmethod=marker
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
let Tlist_File_Fold_Auto_Close = 1
nnoremap <Space> za
vnoremap <Space> za
" }}}

" Tag Settings {{{
set tags=tags;
" Show the autocomplete menu even if there's only one entry
set completeopt=menuone,longest
" <C-X><C-O> is awkward and uncomfortable! I'd rather use tab.
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" Also, not a big fan of pink.
highlight Pmenu guibg=brown gui=bold
" }}}

" Plugin Settings {{{
" NERDTree stuffs
let NERDTreeShowBookmarks=1
let NERDTreeQuitOnOpen = 1
let NERDTreeHighlightCursorline=1
let NERDTreeMouseMode=2
" }}}

" Shortcut Mappings {{{
" For ease of updating this file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Load/Kill the cscope database
nmap <silent> <leader>lc :LoadCscope<CR>
nmap <silent> <leader>kc :cscope kill 0<CR>

" Make regexs more Perl-like
nnoremap / /\v
vnoremap / /\v

" Un-highlight search queries
nnoremap <silent> <leader><space> :noh<CR>

" Toggle Quickfix window
nmap <silent> <leader>q :QFix<CR>

" Move between tabs
nmap <silent> <M-]> :tabn<CR>
nmap <silent> <M-[> :tabp<CR>

" No shift to enter ex-mode
nnoremap ; :

" Do an <strike>grep</strike> Ack search.
nmap <leader>a :Ack<space>

" Toggle the yankring window
nmap <F2> :YRShow<CR>

" Shortcut to do cscope file searches
nmap <F3> :cs find f<space>
nmap <C-F3> :tab cs find f<space>
nmap gf <C-\>f

" Shortcut to do a cscope search
nmap <F4> <C-\>s
nmap <S-F4> :cs find s<space>

" If my usual method of jumping to a tag (<C-LeftMouse>) doesn't work...
nmap <F5> g<C-]>

" Copy to the Windows clipboard
map <F6> "*y

" Toggle the file hierarchy view
nmap <F7> :NERDTreeToggle<CR>

" For viewing the exuberant ctags list
map <F8> :TlistToggle<CR>

" ClearCase mappings
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
" }}}

" FileType-specific handling {{{
if has ("autocmd")
   augroup cpp_files " {{{
      au!
      " Standards actually dictate 120 columns, but I strive for 80.
      au FileType cpp,c set colorcolumn=81
      au FileType cpp,c match OverLength /\%121v.\+/
   augroup end " }}}
   augroup snippets " {{{
      au!
      au FileType snippet set nofoldenable
      au FileType snippet set noexpandtab
      au FileType snippet set nosmarttab
   augroup end " }}}
endif
" }}}

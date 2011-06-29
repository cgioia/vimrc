" Hi, I'm Chad, and this is my vimrc.

" Preamble {{{
" We live in the futuar, turn off forced Vi-compatibility
set nocompatible

" Set-up pathogen to include all plugins under vimfiles/bundle directory.
filetype off
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
" }}}

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
set listchars=tab:»\ ,eol:¬,extends:¶,precedes:«,trail:·
set showbreak=›
set cursorline
set scrolloff=4
" }}}

" gVim Settings {{{
if has("gui_running")
   " Somewhat centered on my screen
   winpos 200 100

   " Consolas is a pretty sweet monospace font (from Microsoft, no less!)
   set guifont=Consolas:h9

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
" }}}

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
   "set background=light
   set background=dark
else
   set background=dark
endif
colorscheme solarized
call togglebg#map("<S-F2>")

" Use a very noticible highlight when going over length for the FileType
highlight link OverLength WarningMsg
" }}}

" Folding Settings {{{
set foldenable
set foldmethod=manual
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Expression-based folding {{{
au BufRead,BufNewFile * let b:foldlevel = 0
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
" }}}

" Plugin Settings {{{
" NERDTree {{{
let NERDTreeShowBookmarks = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeMouseMode = 2
let NERDTreeWinSize = 38

nmap <F7> :NERDTreeToggle<CR>
" }}}

" Taglist {{{
let Tlist_File_Fold_Auto_Close = 1

map <C-F8> :TlistToggle<CR>
" }}}

" Tagbar {{{
let g:tagbar_left = 1
let g:tagbar_width = 38

map <F8> :TagbarOpenAutoClose<CR>
map <S-F8> :TagbarToggle<CR>
" }}}

" Supertab {{{
" <C-X><C-O> is awkward and uncomfortable! I'd rather use tab.
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" }}}

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
" }}}

" Ack {{{
" Do an <strike>grep</strike> Ack search.
nmap <leader>a :Ack<space>
" }}}

" YankRing {{{
" Toggle the yankring window
nmap <F2> :YRShow<CR>
" }}}
" }}}

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

" Space to toggle folds
nnoremap <Space> za
vnoremap <Space> za
nnoremap <S-Space> zA
vnoremap <S-Space> zA

" Un-highlight search queries
nnoremap <silent> <leader><space> :noh<CR>

" Toggle Quickfix window
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
nmap <silent> <leader>q :QFix<CR>

" If my usual method of jumping to a tag (<C-LeftMouse>) doesn't work...
nmap <F5> g<C-]>

" Copy to the Windows clipboard
map <F6> "*y

" }}}

" FileType-specific handling {{{
if has ("autocmd")
   augroup cpp_files " {{{
      au!
      function! CPP_foldexpr(lnum) "{{{
         let l1 = getline(a:lnum)

         " Skip the line if it's blank
         if l1 =~ '^\s*$'
            return ContinueFold()
         endif

         let l2 = getline(a:lnum+1)
         let l0 = getline(a:lnum-1)

         " Folding Brackets
         if l1 =~ '{.*}'
            " Don't fold brackets that begin and end on the same line
            return ContinueFold()
         elseif l1 =~ '[^\%(\%(//\)\|\%(/\*\)\)]\?\s*}'
            " End a fold at un-commented closed brace
            return EndFold()
         elseif l1 =~ '^\s*{\s*$' && l0 =~ '[{,]\s*$'
            " Fold current line if is just an open brace and is preceded by
            " another open brace or a comma
            return StartFold()
         elseif l1 =~ '\S\+.*{\s*\%(\%(//\)\|\%(/\*\)\)\?'
            " Fold current line if it contains non-whitespace and ends with an
            " open brace
            return StartFold()
         elseif l2 =~ '^\s*{\s*\%(\%(//\)\|\%(/\*\)\)\?' && l1 !~ '{'
            " Fold current line if it doesn't have an open brace and the
            " following line does
            return StartFold()
         endif

         " Fold file headers
         if l1 =~ 'FILE_HEADER_BEGIN'
            return StartFold()
         elseif l1 =~ 'FILE_HEADER_END'
            return EndFold()
         endif

         " Folding C-style Comments
         if l1 =~ '/\*.*\*/'
            " Don't fold C-style comments that begin and end on the same line
            return ContinueFold()
         elseif l1 =~ '\*/'
            " End fold
            return EndFold()
         elseif l1 =~ '^\s*/\*'
            " Fold current line if it begins with a C-style comment
            return StartFold()
         endif

         " Don't fold anything else
         return ContinueFold()
      endfunction "}}}
      au FileType cpp,c setlocal foldexpr=CPP_foldexpr(v:lnum)
      au FileType cpp,c setlocal foldmethod=expr
      au FileType cpp,c setlocal foldnestmax=3
      au FileType cpp,c match OverLength /\%121v.\+/
   augroup end " }}}
   augroup snippets " {{{
      au!
      au FileType snippet setlocal nofoldenable
      au FileType snippet setlocal noexpandtab
      au FileType snippet setlocal nosmarttab
   augroup end " }}}
   augroup vim_files " {{{
      au!
      au FileType vim setlocal foldmethod=marker
   augroup end " }}}
   augroup perl_files " {{{
      au!
      au FileType perl setlocal foldmethod=syntax
   augroup end " }}}
endif
" }}}

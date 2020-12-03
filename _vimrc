" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" -----------------------------------------------------------------
" the bellow is cui_pref

color molokai
set noundofile
set nobackup
set nu
set rnu
set cursorline
set tabstop=4
set shiftwidth=4
set smartindent
set encoding=UTF-8
set helplang=cn

if has("gui")
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  au GUIEnter * simalt ~x
  " source $VIMRUNTIME/delmenu.vim
  " source $VIMRUNTIME/menu.vim
  set guifont=Cascadia_Code_PL:h14:cANSI:qDRAFT
  " set guifontwide=新宋体:h14:cANSI:qDRAFT
  " if pwd == C:/Users/cui
  "   map <F2> :NERDTree D:/<CR>
  " else
  "   map <F2> :NERDTree<CR>
  " endif
  map <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
  set clipboard+=unnamed
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme="badwolf"
" let g:airline_extensions = []

map <C-s> :w<CR>
map <C-q> :q<CR>
map <C-n> :tabnew<CR>
map bn :bn<CR>

let NERDTreeShowHidden=1
au VimEnter * :NERDTree
wincmd w
au VimEnter * wincmd w
map <F2> :NERDTree<CR>

let mapleader = "\<space>"
map <leader>er :vs $MYVIMRC<CR>
map <leader>sf :source $MYVIMRC<CR>
map <leader>1 :1b<CR>
map <leader>2 :2b<CR>
map <leader>3 :3b<CR>
map <leader>4 :4b<CR>
map <leader>5 :5b<CR>
map <leader>6 :6b<CR>
map <leader>7 :7b<CR>
map <leader>8 :8b<CR>
map <leader>9 :9b<CR>

map <leader>w :w<CR>
map <leader>q :q<CR>
map <leader>wq :wq<CR>
map <leader>fq :q!<CR>
map <leader>aq :q<CR><leader>aq
map <leader>awq :wq<CR><leader>awq
map <leader>af :NERDTreeToggle<CR>
map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tomasr/molokai'
Plugin 'ryanoasis/vim-devicons'
Plugin 'jiangmiao/auto-pairs'
Plugin 'severin-lemaignan/vim-minimap'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" --------vundle---------

color molokai
" let g:molokai_original = 1
let g:rehash256 = 1
syntax on
set nu
set rnu
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent
" set noundofile
" set nobackup
set cursorline
set mouse=a
set wildmenu
set encoding=utf-8
" set t_u7=
" set termencoding=utf-8

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme="dark"
let g:airline_theme="badwolf"
" let g:airline_extensions = []

let mapleader = "\<space>"

map <leader>af :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" au VimEnter * :NERDTree
" wincmd w
" au VimEnter * wincmd w

" let g:minimap_highlight='Visual'
let g:minimap_show='<leader>ms'
let g:minimap_update='<leader>mr'
let g:minimap_close='<leader>mc'
let g:minimap_toggle='<leader>mm'

map <C-n> :tabnew<CR>
" map <C-s> :w<CR>
" map <C-q> :q<CR>
map bn :bn<CR>

map <leader>er :vs $MYVIMRC<CR>
map <leader>sf :source $MYVIMRC<CR>

map <leader>w :w<CR>
map <leader>q :q<CR>
map <leader>wq :wq<CR>
map <leader>fq :q!<CR>
map <leader>aq :q<CR><leader>aq
map <leader>ewq :wq<CR><leader>ewq
map <leader>r :diffupdate<CR>

map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l
map <leader>s <C-w>s
map <leader>v <C-w>v

map <leader>b :tabp<CR>
map <leader>n :tabn<CR>

" map <leader>fj :w<CR>:!echo -e "\n--------Debugging--------\n" && g++ % && $PWD/a.out && echo -e "\n-----------End-----------"<CR>
" map <leader>cp :!clip.exe < %<CR>

map <leader>cp "*y

" au BufRead,BufNewFile *vifmrc,*.vifm  set filetype=vifm
" au BufRead,BufNewFile *vifminfo set filetype=vifminfo

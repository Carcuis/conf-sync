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
Plugin 'jiangmiao/auto-pairs'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'vimcn/vimcdoc'
Plugin 'ryanoasis/vim-devicons'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'tpope/vim-commentary'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
" Plugin 'vim-rhubarb'
Plugin 'kien/ctrlp.vim'
Plugin 'nathanaelkane/vim-indent-guides'

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
set expandtab
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
" set list lcs=tab:\|\ 

" gui_options
set guifont=UbuntuMonoNerdFontCompleteM-Regular:h22
set guioptions-=L

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme="dark"
let g:airline_theme="badwolf"
" let g:airline_extensions = []

let mapleader = "\<space>"

" nerdtree
map <leader>af :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks = 1

" au VimEnter * :NERDTree
" wincmd w
" au VimEnter * wincmd w

" vim-nerdtree-syntax-highlight
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

" nerdtree-git-plugin
" let g:NERDTreeGitStatusShowClean = 1

" vim-minimap
" let g:minimap_highlight='Visual'
let g:minimap_show='<leader>ms'
let g:minimap_update='<leader>mr'
let g:minimap_close='<leader>mc'
let g:minimap_toggle='<leader>mm'

" vim-devicons
" let g:webdevicons_enable = 1
" let g:webdevicons_enable_nerdtree = 1
" let g:webdevicons_enable_airline_statusline = 1
" let g:webdevicons_conceal_nerdtree_brackets = 0
" let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"
" let g:syntastic_cpp_compiler = 'g++'
" let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++'
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

" CtrlP
let g:ctrlp_map = '<leader>ff'

" indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=grey20 ctermbg=236
hi IndentGuidesEven guibg=grey25 ctermbg=237

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

" auto change cursor shape in gnome-terminal
if has("autocmd")
  au InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasr/molokai'
Plug 'doums/darcula'
" Plug 'blueshirts/darcula'
Plug 'joshdick/onedark.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'severin-lemaignan/vim-minimap'
Plug 'vimcn/vimcdoc'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-commentary'
Plug 'ycm-core/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
" Plug 'vim-rhubarb'
" Plug 'kien/ctrlp.vim'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'Yggdroot/indentLine'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
Plug 'pprovost/vim-ps1'
Plug 'romainl/vim-cool'
Plug 'luochen1990/rainbow'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/tagbar'

" Initialize plugin system
call plug#end()
" --------vim-plug---------

color darcula
" let g:molokai_original = 1
let g:rehash256 = 1
let mapleader = "\<space>"
syntax on
set nu
set rnu
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set noundofile
set nobackup
set cursorline
set mouse=a
set wildmenu
set encoding=utf-8
set incsearch
set hlsearch
set scrolloff=5

if has("gui_running")
  color onedark
  " set guioptions-=m  "remove menu bar
  " set guioptions-=T  "remove toolbar
  " set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  if has('win32')
    au GUIEnter * simalt ~x
    source $VIMRUNTIME/delmenu.vim
    set guifont=UbuntuMono_NF:h16:cANSI:qDRAFT
    map <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
  else
    set guifont=UbuntuMonoNerdFontCompleteM-Regular:h22
  endif
else
  if has('win32')
    set termguicolors
    set nocursorline
  endif
endif

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme="dark"
" let g:airline_theme="badwolf"
let g:airline_theme="powerlineish"
" let g:airline_extensions = []

" nerdtree
map <leader>af :NERDTreeToggle<CR>
map <F2> :NERDTree<CR>
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks = 1
if (winwidth(0) > 140 || has("gui_running")) && argc() < 2
    au VimEnter * :NERDTree
    au VimEnter * wincmd w
endif

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
" let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"
" let g:syntastic_cpp_compiler = 'g++'
" let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++'
" let g:ycm_min_num_of_chars_for_completion = 1
" let g:ycm_semantic_triggers =  {
" 			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
" 			\ 'cs,lua,javascript': ['re!\w{2}'],
" 			\ }

" CtrlP
" let g:ctrlp_map = '<leader>ff'

" LeaderF
let g:Lf_WindowPosition = 'popup'
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }
map <leader>fr :LeaderfMru<CR>

" vim-commentary
autocmd FileType java,c,cpp set commentstring=//\ %s
autocmd FileType ps1 set commentstring=#\ %s

" indent-guides
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
" let g:indent_guides_auto_colors = 0
" hi IndentGuidesOdd  guibg=grey20 ctermbg=236
" hi IndentGuidesEven guibg=grey25 ctermbg=237

" indentline
let g:indentLine_char = '│'

" rainbow bracket
let g:rainbow_active = 0

" tagbar
map <leader>tb :TagbarToggle<CR>
let g:tagbar_width = max([25, winwidth(0) / 5])
if (winwidth(0) > 100 || has("gui_running")) && argc() < 2
  autocmd VimEnter * nested :TagbarOpen
endif

map <C-n> :tabnew<CR>
" map <C-s> :w<CR>
map bn :bn<CR>

map <leader>er :vs $MYVIMRC<CR>
map <leader>ef :e $MYVIMRC<CR>
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
map <leader>ewq :wq<CR><leader>ewq
map <leader>r :diffupdate<CR>

map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l
map <leader>s <C-w>s
map <leader>v <C-w>v

map <leader>n :tabp<CR>
map <leader>m :tabn<CR>

if has('win32')
  au FileType cpp map <buffer> <leader>fj :w<CR>:!echo --------Debugging--------
              \ && g++ % -o %:h\tmp.exe && %:h\tmp.exe<CR>
else
  au FileType cpp map <buffer> <leader>fj :w<CR>:!echo -e "\n--------Debugging--------"
              \ && g++ % -o %:h/tmp.out && %:h/tmp.out &&<CR>
endif

map <leader>cp "+y
map <leader>p "+p

if has("autocmd")

  " auto change cursor shape
  if ! has("gui_running")
    let &t_SI.="\e[5 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[1 q"
  endif

  " let Vim jump to the last position when reopening a file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasr/molokai'
Plug 'doums/darcula'
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
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
Plug 'pprovost/vim-ps1'

" Initialize plugin system
call plug#end()
" --------vim-plug---------

color darcula
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
set incsearch
" set t_u7=
" set termencoding=utf-8
" set list lcs=tab:\|\ 

" gui_options
set guifont=UbuntuMonoNerdFontCompleteM-Regular:h22
" set guioptions-=L

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme="dark"
" let g:airline_theme="badwolf"
let g:airline_theme="powerlineish"
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
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=grey20 ctermbg=236
hi IndentGuidesEven guibg=grey25 ctermbg=237

map <C-n> :tabnew<CR>
" map <C-s> :w<CR>
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

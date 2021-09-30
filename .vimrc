" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'vim-airline/vim-airline-themes'
Plug 'tomasr/molokai'
Plug 'carcuis/darcula'
" Plug 'blueshirts/darcula'
Plug 'joshdick/onedark.vim'
Plug 'jiangmiao/auto-pairs'
" Plug 'severin-lemaignan/vim-minimap'
Plug 'vimcn/vimcdoc'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
" Plug 'ycm-core/YouCompleteMe'
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
Plug 'airblade/vim-gitgutter'
Plug 'vim/killersheep'
Plug 'mhinz/vim-startify'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'vifm/vifm.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

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
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
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
set updatetime=100
set hidden
set ignorecase
set smartcase
set guicursor+=n:blinkon1
set termguicolors
set signcolumn=yes
set timeoutlen=500
hi NonText guifg=bg

if has("win32")
  set backspace=indent,eol,start
endif

if has("nvim")
  hi cursorline guifg=NONE
  if !has("mac")
    set guifont=UbuntuMono\ NF:h16
  else
    set guifont=UbuntuMono\ Nerd\ Font\ Mono:h20
  endif
elseif has("gui_running") "gvim
  hi Cursor guifg=black guibg=white
  " color onedark
  " set guioptions-=m  "remove menu bar
  " set guioptions-=T  "remove toolbar
  " set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  if has("win32")
    au GUIEnter * simalt ~x
    source $VIMRUNTIME/delmenu.vim
    set guifont=UbuntuMono_NF:h16:cANSI:qDRAFT
    map <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
  elseif (system('uname -a') =~ "Microsoft") "wsl
    set lines=45
    set columns=162
    set linespace=0
    set guifont=UbuntuMono\ Nerd\ Font\ Mono\ 16
  elseif has("linux")
    set lines=45
    set columns=200
    set linespace=-3
    set guifont=UbuntuMono\ Nerd\ Font\ Mono\ 12
  elseif has("mac")
    set lines=45
    set columns=162
    set guifont=UbuntuMonoNerdFontCompleteM-Regular:h20
  endif
else "vim in tui
  if has("win32")
    set nocursorline
  elseif has("linux")
    " let &t_TI=""
    " let &t_TE=""
  endif
endif

" darcula
" hi! link GitGutterAdd GitAddStripe
" hi! link GitGutterChange GitChangeStripe
hi! link GitGutterDelete GitDeleteStripe
hi! link CocErrorSign ErrorSign
hi! link CocWarningSign WarningSign
hi! link CocInfoSign InfoSign
hi! link CocHintSign HintSign
hi! link CocErrorFloat Pmenu
hi! link CocWarningFloat Pmenu
hi! link CocInfoFloat Pmenu
hi! link CocHintFloat Pmenu
hi! link CocHighlightText IdentifierUnderCaret
hi! link CocHighlightRead IdentifierUnderCaret
hi! link CocHighlightWrite IdentifierUnderCaretWrite
hi! link CocErrorHighlight CodeError
hi! link CocWarningHighlight CodeWarning
hi! link CocInfoHighlight CodeInfo
hi! link CocHintHighlight CodeHint
call darcula#Hi('Comment', [ '#629755', 255 ], darcula#palette.null, 'italic')

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme="dark"
" let g:airline_theme="badwolf"
let g:airline_theme="darcula"
" let g:airline_extensions = []
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '│'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '│'

" nerdtree
map <leader>tt :NERDTreeToggle<CR>
map <F2> :NERDTree<CR>
let NERDTreeShowHidden = 1
" let NERDTreeShowBookmarks = 1
let NERDTreeWinSize = min([max([25, winwidth(0) / 5]), 30])
if (winwidth(0) > 140 || has("gui_running")) && argc() < 2
    au VimEnter * :NERDTree | set signcolumn=auto | wincmd p
endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

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
" let g:minimap_show='<leader>ms'
" let g:minimap_update='<leader>mr'
" let g:minimap_close='<leader>mc'
" let g:minimap_toggle='<leader>mm'

" vim-devicons
" let g:webdevicons_enable = 1
" let g:webdevicons_enable_nerdtree = 1
" let g:webdevicons_enable_airline_statusline = 1
" let g:webdevicons_conceal_nerdtree_brackets = 0
" let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" YouCompleteMe
" let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
" let g:ycm_collect_identifiers_from_tag_files = 1
" let g:syntastic_cpp_compiler = 'g++'
" let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++'
" let g:ycm_min_num_of_chars_for_completion = 1
" let g:ycm_semantic_triggers =  {
"             \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
"             \ 'cs,lua,javascript': ['re!\w{2}'],
"             \ }
" set completeopt-=preview
" set completeopt=longest,menu

" CtrlP
" let g:ctrlp_map = '<leader>ff'

" LeaderF
let g:Lf_WindowPosition = 'popup'
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>bf'
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
au FileType startify,which_key :IndentLinesDisable
if has("nvim")
  au TermOpen * IndentLinesDisable
endif

" rainbow bracket
let g:rainbow_active = 0

" tagbar
map <leader>tb :TagbarToggle<CR>
let g:tagbar_width = min([max([25, winwidth(0) / 5]), 30])
if (winwidth(0) > 100 || has("gui_running")) && argc() < 2
  " autocmd VimEnter * nested :TagbarOpen
  " autocmd BufEnter * nested :call tagbar#autoopen(0)
  autocmd FileType * nested :call tagbar#autoopen(0)
endif
let g:tagbar_iconchars = ['', '']

" vim-startify
let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]
let g:startify_commands = [
    \ {'h': ['help startify', 'h startify']},
    \ {'c': ['edit vimrc', 'call EditVimrc("normal")']},
    \ {'t': ['telescope', 'Telescope find_files']}
    \ ]
let g:startify_fortune_use_unicode = 1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" coc.nvim
let g:coc_global_extensions = [
            \ 'coc-json', 'coc-vimlsp', 'coc-marketplace', 'coc-markdownlint',
            \ 'coc-pyright', 'coc-python', 'coc-powershell', 'coc-sh',
            \ 'coc-cmake', 'coc-actions', 'coc-translator', 'coc-snippets',
            \ 'coc-clangd']
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-e> coc#refresh()
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)w
nmap <M-f>  <Plug>(coc-fix-current)
map <silent> <M-e> :call CocActionAsync('doHover')<CR>
nmap <Leader>tr <Plug>(coc-translator-p)
vmap <Leader>tr <Plug>(coc-translator-pv)

" vim-which-key
let g:which_key_fallback_to_native_key=1
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> g :WhichKey 'g'<CR>
let g:which_key_sep = '➜'

" vim-gitgutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▶'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_removed_above_and_below = '_▔'
let g:gitgutter_sign_modified_removed = '▶'

" telescope.nvim
if has("nvim")
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif

" vim-trailing-whitespace
let g:extra_whitespace_ignored_filetypes = ['TelescopePrompt']

map <C-n> :tabnew<CR>
map <M-s> :w<CR>
map <M-w> :q<CR>
map <M-q> :q!<CR>
map <leader>bn :bn<CR>

function EditVimrc(way)
  if has("win32")
    if a:way == "normal"
      execute ":e ~/_vimrc"
    elseif a:way == "vs"
      execute ":vs ~/_vimrc"
    endif
  else
    if a:way == "normal"
      execute ":e ~/.vimrc"
    elseif a:way == "vs"
      execute ":vs ~/.vimrc"
    endif
  endif
endfunction

map <leader>sf :w<CR>:source $MYVIMRC<CR>
if has("nvim")
  map <leader>ev :e $MYVIMRC<CR>
endif
map <leader>ef :call EditVimrc("normal")<CR>
map <leader>er :call EditVimrc("vs")<CR>

" map <leader>1 :1b<CR>
" map <leader>2 :2b<CR>
" map <leader>3 :3b<CR>
" map <leader>4 :4b<CR>
" map <leader>5 :5b<CR>
" map <leader>6 :6b<CR>
" map <leader>7 :7b<CR>
" map <leader>8 :8b<CR>
" map <leader>9 :9b<CR>

map <leader>ww :w<CR>
map <leader>q :q<CR>
map <leader>wq :wq<CR>
map <leader>fq :q!<CR>
map <leader>ewq :wq<CR><leader>ewq
map <leader>du :diffupdate<CR>
map <leader><leader>r :redraw!<CR>

" map <leader>h <C-w>h
" map <leader>j <C-w>j
" map <leader>k <C-w>k
" map <leader>l <C-w>l
map <M-h> <C-w>h
map <M-j> <C-w>j
map <M-k> <C-w>k
map <M-l> <C-w>l
map <leader>sp <C-w>s
map <leader>vs <C-w>v

map <leader>tp :tabp<CR>
map <leader>tn :tabn<CR>
map H :bp<CR>
map L :bn<CR>

map <leader>cp "+y
map <leader>p "+p

map <C-J> ]c
map <C-K> [c

" recurse do or dp in vimdiff
map <leader>do do]c<leader>do
map <leader>dp dp]c<leader>dp

inoremap jj <esc>
cnoremap jj <esc>
if has("unix") && (system('uname -a') =~ "Android")
  inoremap `` <esc>
  cnoremap `` <esc>
  vnoremap `` <esc>
endif

map <C-H> 10zh
map <C-L> 10zl

let g:load_doxygen_syntax=1

if has("win32")
  au FileType cpp map <buffer> <leader>fj :w<CR>:!echo --------Debugging--------
              \ && g++ % -o %:h\tmp_%:t:r.exe && %:h\tmp_%:t:r.exe<CR>
else
  au FileType cpp map <buffer> <leader>fj :w<CR>:!echo -e "\n--------Debugging--------"
              \ && g++ % -o %:h/tmp_%:t:r.out && %:h/tmp_%:t:r.out &&<CR>
endif

" auto change cursor shape
if !(has("gui_running") || has("nvim"))
  let &t_SI.="\e[5 q"
  let &t_SR.="\e[4 q"
  let &t_EI.="\e[1 q"
endif

" let Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

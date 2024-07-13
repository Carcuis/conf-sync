" ======================================================
"   _____                  _             _
"  / ___/__ ___________ __(_)__    _  __(_)_ _  ________
" / /__/ _ `/ __/ __/ // / (_-<  _| |/ / /  ' \/ __/ __/
" \___/\_,_/_/  \__/\_,_/_/___/ (_)___/_/_/_/_/_/  \__/
"
" ======================================================
"
" =================
" ===  plugins  ===
" =================
"
let data_dir = has('nvim') ? stdpath('data') . '/site' : has("win32") ? $HOME . '/vimfiles' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|     PlugInstall --sync | source $MYVIMRC | q
    \| endif

call plug#begin()

Plug 'vimcn/vimcdoc'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ryanoasis/vim-devicons' " required by vim-startify
Plug 'mhinz/vim-startify'
Plug 'vifm/vifm.vim'
Plug 'dstein64/vim-startuptime'
Plug 'lambdalisue/suda.vim' " save file by sudo
Plug 'fladson/vim-kitty' " syntax highlight for kitty.conf
Plug 'a5ob7r/shellcheckrc.vim' " syntax highlight for shellcheckrc
Plug 'machakann/vim-highlightedyank' " highlight on yank

if has("nvim")
    Plug 'Carcuis/darcula.nvim'
    Plug 'rafamadriz/neon'
    Plug 'Mofiqul/vscode.nvim'
    Plug 'folke/tokyonight.nvim'
    Plug 'shaunsingh/moonlight.nvim'
    Plug 'kylechui/nvim-surround'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope-symbols.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'akinsho/bufferline.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'akinsho/toggleterm.nvim'
    Plug 'ahmedkhalf/project.nvim'
    Plug 'norcalli/nvim-terminal.lua'
    Plug 'alec-gibson/nvim-tetris'
    Plug 'nvim-lua/popup.nvim'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/playground'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'folke/which-key.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'petertriho/nvim-scrollbar'
    Plug 'romgrk/fzy-lua-native'    " required by wilder.nvim
    function! UpdateRemotePlugins(...)
        let &rtp=&rtp
        UpdateRemotePlugins
    endfunction
    Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
    Plug 'famiu/bufdelete.nvim'
    Plug 'rcarriga/nvim-notify'
    Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    Plug 'nvim-treesitter/nvim-treesitter-context'
    Plug 'ZhiyuanLck/smart-pairs'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'sindrets/diffview.nvim'
    Plug 'github/copilot.vim'
    Plug 'ofseed/copilot-status.nvim'
    Plug 'kevinhwang91/nvim-hlslens'
    Plug 'NMAC427/guess-indent.nvim'    " indentation-detection
    Plug 'lukas-reineke/virt-column.nvim'
    Plug 'ggandor/leap.nvim'
    Plug 'fannheyward/telescope-coc.nvim'
    Plug 'NeogitOrg/neogit'
    Plug 'Bekaboo/dropbar.nvim'
    Plug 'tiagovla/scope.nvim'
    Plug 'sustech-data/wildfire.nvim'
    Plug 'stevearc/dressing.nvim'
    Plug 'stevearc/resession.nvim'
    Plug 'stevearc/overseer.nvim'
    Plug 'Zeioth/compiler.nvim'
    Plug 'CopilotC-Nvim/CopilotChat.nvim'
    Plug 'mfussenegger/nvim-dap'
    Plug 'mfussenegger/nvim-dap-python'
    Plug 'nvim-neotest/nvim-nio'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'nvim-telescope/telescope-dap.nvim'
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'williamboman/mason.nvim'
    Plug 'jay-babu/mason-nvim-dap.nvim'
else
    Plug 'Carcuis/darcula'
    Plug 'joshdick/onedark.vim'
    Plug 'romainl/vim-cool'
    Plug 'pprovost/vim-ps1'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline'
    Plug 'easymotion/vim-easymotion'
    Plug 'Yggdroot/indentLine'
    Plug 'liuchengxu/vim-which-key'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
    Plug 'vim/killersheep'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-sleuth'     " indentation-detection
    Plug 'preservim/tagbar'
    Plug 'liuchengxu/vista.vim'
    Plug 'tpope/vim-markdown'   " highlight for code blocks in markdown
    Plug 'luochen1990/rainbow'
    Plug 'gcmt/wildfire.vim'    " <cr> select in brackets
endif

call plug#end()

" ===============

" ========================
" ===  basic settings  ===
" ========================
"

let g:transparent_background = 0
let g:color = "darcula"
if g:color == "darcula"
    let g:darcula_transparent = g:transparent_background
    color darcula
elseif g:color == "neon"
    let g:neon_style = "doom"
    let g:neon_transparent = g:transparent_background
    color neon
elseif g:color == "vscode"
    let g:vscode_style = "dark"
    let g:vscode_transparent = g:transparent_background
    color vscode
elseif g:color == "tokyonight"
    lua << EOF
    require("tokyonight").setup({
        style = "night",
        transparent = vim.g.transparent_background == 1,
    })
EOF
    color tokyonight
else
    execute 'colorscheme ' .. g:color
endif

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
set sidescrolloff=10
set updatetime=100
set hidden
set ignorecase
set smartcase
set guicursor+=n:blinkon1
set termguicolors
set signcolumn=yes
set timeoutlen=500
set conceallevel=2
set colorcolumn=120
set jumpoptions=stack

if has("nvim")
    if has("win32")
        let g:python3_host_prog = stdpath('data') . '/pynvim/venv/Scripts/python.exe'
    else
        let g:python3_host_prog = stdpath('data') . '/pynvim/venv/bin/python3'
    endif
    set fillchars=eob:\ ,diff:\ 
    if has("win32") || has("wsl")
        set guifont=CaskaydiaCove\ NFM:h13
    elseif has("linux")
        set guifont=UbuntuMono\ NF:h16
    elseif has("mac")
        set guifont=UbuntuMono\ Nerd\ Font\ Mono:h20
    endif
    set mousemoveevent
    set winblend=10
elseif has("gui_running") "gvim
    " set guioptions-=m  "remove menu bar
    " set guioptions-=T  "remove toolbar
    " set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    if has("win32")
        set backspace=indent,eol,start
        au GUIEnter * simalt ~x
        source $VIMRUNTIME/delmenu.vim
        set guifont=CaskaydiaCove_NF:h12:cANSI:qDRAFT
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
    " auto change cursor shape
    let &t_SI.="\e[5 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[1 q"

    if has("win32")
        set backspace=indent,eol,start
        set nocursorline
    elseif has("linux")
        " let &t_TI=""
        " let &t_TE=""
    endif
endif

if exists("g:neovide")
    let g:neovide_cursor_vfx_mode = "wireframe"
    " let g:neovide_cursor_trail_size = 0.5
    " let g:neovide_profiler = v:true
endif

" ===============

" =========================
" ===  plugin settings  ===
" =========================
"

" === vim-airline ===
if ! has("nvim")
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1
    let g:airline_theme="darcula"
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.colnr = ' ㏇'
    let g:airline_symbols.linenr = ' ¶'
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    let g:airline_left_alt_sep = '│'
    let g:airline_right_alt_sep = '│'
    let g:airline_mode_map = {
                \ '__'     : '-',
                \ 'c'      : 'C',
                \ 'i'      : 'I',
                \ 'ic'     : 'I-C',
                \ 'ix'     : 'I-X',
                \ 'n'      : 'N',
                \ 'multi'  : 'M',
                \ 'ni'     : 'N',
                \ 'no'     : 'N',
                \ 'R'      : 'R',
                \ 'Rv'     : 'R',
                \ 's'      : 'S',
                \ 'S'      : 'S',
                \ ''     : 'S',
                \ 't'      : 'T',
                \ 'v'      : 'V',
                \ 'V'      : 'V-L',
                \ ''     : 'V-B',
                \ }
    let airline#extensions#coc#error_symbol = ':'
    let airline#extensions#coc#warning_symbol = ':'
endif

" === nerdtree ===
if ! has("nvim")
    nnoremap <leader>tt :NERDTreeToggle<CR>
    map <F2> :NERDTree<CR>
    let NERDTreeShowHidden = 1
    " let NERDTreeShowBookmarks = 1
    let NERDTreeWinSize = min([max([25, winwidth(0) / 5]), 30])
    if (winwidth(0) > 140 || has("gui_running")) && argc() < 2
        au VimEnter * :NERDTree | set signcolumn=auto | wincmd p
    endif
    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
                \quit | endif
    let g:NERDTreeDirArrowExpandable = ''
    let g:NERDTreeDirArrowCollapsible = ''

    " vim-nerdtree-syntax-highlight
    let g:NERDTreeFileExtensionHighlightFullName = 1
    let g:NERDTreeExactMatchHighlightFullName = 1
    let g:NERDTreePatternMatchHighlightFullName = 1

    let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
    let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
endif

" === nerdtree-git-plugin ===
" if ! has("nvim")
    " let g:NERDTreeGitStatusShowClean = 1
" endif

" === vim-devicons ===
" let g:webdevicons_enable = 1
" let g:webdevicons_enable_nerdtree = 1
" let g:webdevicons_enable_airline_statusline = 1
" let g:webdevicons_conceal_nerdtree_brackets = 0
" let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" === LeaderF ===
if ! has("nvim")
    let g:Lf_WindowPosition = 'popup'
    let g:Lf_ShortcutF = '<leader>ff'
    let g:Lf_ShortcutB = '<leader>bf'
    let g:Lf_StlSeparator = { 'left': "", 'right': "" }
    nnoremap <leader>fr :LeaderfMru<CR>
endif

" === vim-commentary ===
autocmd FileType java,c,cpp set commentstring=//\ %s
autocmd FileType ps1 set commentstring=#\ %s

" === indentline ===
if ! has("nvim")
    let g:indentLine_char = '│'
    au FileType startify,which_key :IndentLinesDisable
    if has("nvim")
        au TermOpen * IndentLinesDisable
    endif
endif

" === rainbow bracket ===
if ! has("nvim")
    let g:rainbow_active = 0
endif

" === tagbar ===
if ! has("nvim")
    nnoremap <leader>tb :TagbarToggle<CR>
    let g:tagbar_width = min([max([25, winwidth(0) / 5]), 30])
    " if (winwidth(0) > 100 || has("gui_running")) && argc() < 2
    "   " autocmd VimEnter * nested :TagbarOpen
    "   " autocmd BufEnter * nested :call tagbar#autoopen(0)
    "   autocmd FileType * nested :call tagbar#autoopen(0)
    " endif
    let g:tagbar_iconchars = ['', '']
endif

" === vim-startify ===
if argc() == 0
    au VimEnter * :Startify
endif
nnoremap <silent> <leader>; :Startify<CR>
let g:startify_enable_special = 0
let g:startify_lists = [
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ ]
let g:startify_commands = [
    \ {'c': ['  Configuration', 'call EditVimrc("normal")']},
    \ {'P': ['  Plugin Install', 'PlugInstall']},
    \ {'U': ['  Plugin Update', 'PlugUpdate']},
    \ ]
if ! has("nvim")
    let g:startify_commands += [
    \ {'l': ['󰈢  Load Session', 'call LoadSession("")']},
    \ {'f': ['󰈞  Find File', 'Leaderf file']},
    \ {'r': ['󰄉  Recently Used Files', 'Leaderf mru']},
    \ {'w': ['󰉿  Find Word', 'Leaderf rg']},
    \ {'e': ['󰉋  Nerd Tree', 'NERDTree']},
    \ ]
else
    let g:startify_commands += [
    \ {'l': ['󰈢  Load Session', 'lua require("resession").load()']},
    \ {'L': ['󰬲  Load Current Session', 'call LoadSessionInCurrentCwd()']},
    \ {'f': ['󰈞  Find File', 'Telescope find_files']},
    \ {'p': ['  Recent Projects', 'Telescope projects']},
    \ {'r': ['󰄉  Recently Used Files', 'Telescope oldfiles']},
    \ {'w': ['󰉿  Find Word', 'Telescope live_grep']},
    \ {'e': ['󰉋  Nvim Tree', 'NvimTreeOpen']},
    \ {'C': ['  Configure CoC', 'CocConfig']},
    \ ]
endif
let g:startify_fortune_use_unicode = 1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
" save session
function PreSaveSession()
    if has("nvim")
        NvimTreeClose
        TSContextDisable
    else
        NERDTreeClose
    endif
endfunction
function PostSaveSession()
    if has("nvim")
        if (winwidth(0) >= 130) && argc() < 2
            call OpenUnfocusedNvimTreeInNewWindow()
        endif
        TSContextEnable
    else
        if (winwidth(0) > 140 || has("gui_running")) && argc() < 2
            NERDTree | set signcolumn=auto | wincmd p
        endif
    endif
endfunction
function SaveSession(session_name)
    call PreSaveSession()
    if a:session_name == ""
        execute "SSave!"
    else
        execute "SSave!" a:session_name
    endif
    call PostSaveSession()
endfunction
function LoadSession(session_name)
    call PreSaveSession()
    if a:session_name == ""
        execute "SLoad"
    else
        execute "SLoad" a:session_name
    endif
    call PostSaveSession()
endfunction
if ! has("nvim")
    nnoremap <silent> <leader>ss :call SaveSession("")<CR>
    nnoremap <silent> <leader>sl :call LoadSession("")<CR>
endif

" === vim-highlightedyank ===
let g:highlightedyank_highlight_duration = 200

" === coc.nvim ===
if has("nvim")
    let g:coc_global_extensions = [
                \ 'coc-json', 'coc-vimlsp', 'coc-marketplace', 'coc-markdownlint',
                \ 'coc-pyright', 'coc-powershell', 'coc-sh', 'coc-clangd',
                \ 'coc-cmake', 'coc-actions', 'coc-translator', 'coc-snippets',
                \ 'coc-sumneko-lua', 'coc-tsserver', 'coc-eslint', 'https://github.com/Carcuis/coc-nav',
                \ 'coc-xml', 'coc-yaml', 'coc-toml']
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : "\<TAB>"
    inoremap <expr><S-TAB> "\<C-h>"
    inoremap <silent><expr> <c-e> coc#refresh()
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " nmap <silent> gd <Plug>(coc-definition)
    " nmap <silent> gh <Plug>(coc-declaration)
    " nmap <silent> gt <Plug>(coc-type-definition)
    " nmap <silent> ge <Plug>(coc-implementation)
    " nmap <silent> gr <Plug>(coc-references)

    " See fannheyward/telescope-coc.nvim
    nmap <silent> gd :Telescope coc definitions<CR>
    nmap <silent> gh :Telescope coc declarations<CR>
    nmap <silent> gt :Telescope coc type-definitions<CR>
    nmap <silent> ge :Telescope coc implementations<CR>
    nmap <silent> gr :Telescope coc references<CR>

    nmap <silent> gp :call CocActionAsync('jumpDefinition', v:false)<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    nmap <silent> <leader>rn <Plug>(coc-rename)
    nmap <silent> <leader>RN :CocCommand document.renameCurrentWord<CR>
    nmap <silent> <S-F5> <Plug>(coc-rename)
    nmap <silent> <leader>rf <Plug>(coc-refactor)
    nmap <silent> <leader>lo <Plug>(coc-openlink)
    xmap <silent> <leader>a  <Plug>(coc-codeaction-selected)
    nmap <silent> <leader>a  <Plug>(coc-codeaction-selected)w
    nmap <silent> <M-f>  <Plug>(coc-fix-current)
    nmap <silent> <M-e> :call CocActionAsync('doHover')<CR>
    nmap <silent> <M-d> :CocCommand semanticTokens.inspect<CR>
    nmap <silent> <leader>tr <Plug>(coc-translator-p)
    vmap <silent> <leader>tr <Plug>(coc-translator-pv)
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

    command! -nargs=0 Format :call CocActionAsync('format')
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
    command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

    let g:coc_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
    let g:coc_notify_error_icon = ''
    let g:coc_notify_warning_icon = ''
    let g:coc_notify_info_icon = ''

    " Visual mode quick select in function/class
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Disable error bracket highlight in coc-sumneko-lua hover message
    highlight link LuaParenError Normal
    highlight link LuaError Normal

    " Auto close coc-tree
    autocmd BufEnter CocTree* ++nested
        \ let layout = winlayout() |
        \ if len(layout) == 2 && layout[0] == 'leaf' && getbufvar(winbufnr(layout[1]), '&filetype') == 'coctree' ||
        \     len(layout[1]) == 2 && layout[0] == 'row' && layout[1][0][0] == 'leaf' && layout[1][1][0] == 'leaf' &&
        \     getbufvar(winbufnr(layout[1][0][1]), '&filetype') == 'NvimTree' &&
        \     getbufvar(winbufnr(layout[1][1][1]), '&filetype') == 'coctree' |
        \ quit | endif
endif

" === vim-which-key ===
if ! has("nvim")
    let g:which_key_fallback_to_native_key=1
    nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
    nnoremap <silent> g :WhichKey 'g'<CR>
    nnoremap <silent> [ :WhichKey '['<CR>
    nnoremap <silent> ] :WhichKey ']'<CR>
    let g:which_key_sep = '➜'
endif

" === vim-gitgutter ===
if ! has("nvim")
    let g:gitgutter_sign_added = '█'
    let g:gitgutter_sign_modified = '█'
    let g:gitgutter_sign_removed = '▶'
    let g:gitgutter_sign_removed_first_line = '▶'
    let g:gitgutter_sign_removed_above_and_below = '▶'
    let g:gitgutter_sign_modified_removed = '█'
endif

" === telescope.nvim ===
if has("nvim")
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fF <cmd>Telescope find_files hidden=true<cr>
    nnoremap <leader>fw <cmd>Telescope live_grep<cr>
    nnoremap <leader>f/ <cmd>Telescope current_buffer_fuzzy_find<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fH <cmd>Telescope highlights<cr>
    nnoremap <leader>fp <cmd>Telescope projects<cr>
    nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
    nnoremap <leader>fR <cmd>Telescope registers<cr>
    nnoremap <leader>fc <cmd>Telescope command_history<cr>
    nnoremap <leader>fn <cmd>Telescope notify<cr>
    nnoremap <leader>fgC <cmd>Telescope git_bcommits<cr>
    nnoremap <leader>fgb <cmd>Telescope git_branches<cr>
    nnoremap <leader>fgc <cmd>Telescope git_commits<cr>
    nnoremap <leader>fgf <cmd>Telescope git_files<cr>
    nnoremap <leader>fgs <cmd>Telescope git_status<cr>
    nnoremap <leader>fs <cmd>lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji', 'math', 'latex'} }<CR>
    nnoremap <leader>fd <cmd>Telescope coc diagnostics<CR>
    nnoremap <leader>fD <cmd>Telescope coc workspace_diagnostics<CR>
    lua << EOF
    require('telescope').setup{
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            winblend = 10,
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                 -- the default case_mode is "smart_case"
            },
            coc = {
                theme = 'ivy',
                prefer_locations = false, -- always use Telescope locations to preview definitions/declarations/implementations etc
            }
        },
    }
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('coc')
EOF
endif

" === vim-trailing-whitespace ===
let g:extra_whitespace_ignored_filetypes = [
            \'TelescopePrompt',
            \'vim-plug',
            \'checkhealth',
            \'NvimTree',
            \'help',
            \'toggleterm',
            \'mason',
            \]

" === bufferline.nvim ===
if has("nvim")
    nnoremap <silent> gb <cmd>BufferLinePick<CR>
    nnoremap <silent> H <cmd>BufferLineCyclePrev<CR>
    nnoremap <silent> L <cmd>BufferLineCycleNext<CR>
    nnoremap <silent> <M-S-H> <cmd>BufferLineMovePrev<CR>
    nnoremap <silent> <M-S-L> <cmd>BufferLineMoveNext<CR>
    lua << EOF
    require("bufferline").setup{
        options = {
            middle_mouse_command = function(bufnum)
                require('bufdelete').bufdelete(bufnum)
            end,
            close_command = function(bufnum)
                require('bufdelete').bufdelete(bufnum)
            end,
            show_buffer_close_icons = false,
            separator_style = (vim.g.transparent_background == 1 and {"thin"} or {"slant"})[1],
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "Nvim Tree",
                },
                {
                    filetype = "DiffviewFiles",
                    text = "Source Control",
                },
                {
                    filetype = "dapui_watches",
                    text = "Debug",
                },
            },
            hover = {
                enabled = false,
            },
            diagnostics = "coc",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local s = ""
                for e, n in pairs(diagnostics_dict) do
                    local icon = e == "error" and " " or (
                        e == "warning" and " " or (
                        e == "info" and " " or "󰌶 " ))
                    s = s .. " " .. icon .. n
                end
                return s
            end,
        }
    }
EOF
endif

" === nvim-tree.lua ===
if has("nvim")
    nnoremap <silent> <leader>ee :NvimTreeToggle<CR>
    nnoremap <silent> <leader>E :NvimTreeFindFile!<CR>

    func OpenUnfocusedNvimTreeInNewWindow()
        lua << EOF
            local data = {
                file = vim.fn.expand('%:p'),
                buf = vim.api.nvim_get_current_buf(),
            }
            -- buffer is a real file on the disk
            local real_file = vim.fn.filereadable(data.file) == 1

            -- buffer is a [No Name]
            local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

            local excluded_filetypes = {}

            if ( real_file or no_name ) and not vim.tbl_contains(excluded_filetypes, vim.bo[data.buf].filetype) then
                require("nvim-tree.api").tree.toggle({ focus = false })
            end
EOF
    endfunction

    " Auto open un-focused NvimTree in new window if the window width is enough
    if (winwidth(0) >= 130) && argc() < 2
        autocmd VimEnter,TabNewEntered * call OpenUnfocusedNvimTreeInNewWindow()
    endif

    " Auto close NvimTree when it is the last buffer in the session or tab
    autocmd BufEnter NvimTree_* ++nested
            \ let layout = winlayout() |
            \ if len(layout) == 2 && layout[0] == 'leaf' && getbufvar(winbufnr(layout[1]), '&filetype') == 'NvimTree' |
            \ quit | endif

    " Close NvimTree after :DiffviewOpen
    autocmd BufEnter diffview:///*
            \ lua if require("nvim-tree.api").tree.is_visible() then vim.cmd("NvimTreeClose") end

    lua << EOF
    local function on_attach(bufnr)
        -- @see: https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
        local api = require('nvim-tree.api')
        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
    end
    require('nvim-tree').setup {
        on_attach = on_attach,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable      = true,
            update_root  = false,
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
            icons = {
                hint = "󰌶",
                info = "",
                warning = "",
                error = "",
            },
        },
        git = {
            timeout = 1000,
        },
        actions = {
            open_file = {
                quit_on_open = vim.fn.winwidth(0) < 130,
            },
        },
        renderer = {
            group_empty = false,
            full_name = true,
            root_folder_label = ":t",
            highlight_git = "name",
            icons = {
                git_placement = "after",
                glyphs = {
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "󰉋",
                        open = "",
                        empty = "󰉖",
                        empty_open = "󰷏",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "󰤌",
                        staged = "",
                        untracked = "",
                    },
                },
            },
        },
        modified = {
            enable = vim.fn.has("linux") == 1,
            show_on_dirs = vim.fn.has("linux") == 1,
            show_on_open_dirs = false,
        },
        filters = {
            git_ignored = false,
        },
    }
EOF
endif

" === FixCursorHold.nvim ===
if has("nvim")
    let g:cursorhold_updatetime = 0
endif

" === nvim-terminal.lua ===
if has("nvim")
    lua require'terminal'.setup()
endif

" === toggleterm.nvim ===
if has("nvim")
    lua << EOF
    require("toggleterm").setup {
        shell = (vim.fn.has("win32") == 1 and { 'pwsh' } or { vim.o.shell })[1],
        open_mapping = [[<c-t>]],
        direction = 'float',
        shade_terminals = true,
        shading_factor = -20,
        float_opts = {
            border = 'curved',
            winblend = 10,
        },
        highlights = {
            -- Normal = {
            --     link = "ToggleTermNormal",
            -- },
            NormalFloat = {
                link = "ToggleTermNormalFloat",
            },
            FloatBorder = {
                link = "ToggleTermFloatBorder",
            }
        },
    }

    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = false })

    function _lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
EOF
endif

" === project.nvim ===
if has("nvim")
    lua << EOF
    require("project_nvim").setup {
        exclude_dirs = {
            "c:", "d:", "e:", "~", "/", "*//*", "build", ".deps"
        },
    }
    require('telescope').load_extension('projects')
EOF
endif

" === nvim-colorizer.lua ===
if has("nvim")
    lua require'colorizer'.setup()
endif

" === nvim-treesitter ===
if has("nvim")
    lua << EOF
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "python", "c", "cpp", "lua", "bash", "vim", "vimdoc", "go", "javascript", "typescript", "make",
            "markdown", "markdown_inline", "toml", "yaml", "xml", "git_config", "json", "json5", "jsonc"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
        },
    }
EOF
    nnoremap <silent> <M-c> :TSHighlightCapturesUnderCursor<CR>
endif

" === nvim-treesitter-context ===
if has("nvim")
    lua << EOF
    require('treesitter-context').setup{
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
EOF
endif

" === lualine.nvim ===
if has("nvim")
    lua << EOF
    require('lualine').setup {
        extensions = {
            {
                sections = {
                    lualine_a = {{
                        function()
                            return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
                        end,
                        padding = { left = 0, right = 0 },
                        separator = { left = '', right = '' },
                    }},
                },
                filetypes = {'NvimTree'},
            },
            {
                sections = { lualine_b = {{
                    'filetype',
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'DiffviewFiles'},
            },
            {
                sections = { lualine_y = {{
                    'filetype',
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'coctree'},
            },
            {
                sections = { lualine_b = {{
                    function() return 'Tasks' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'OverseerList'},
            },
            {
                sections = { lualine_a = {{
                    function() return 'Scope' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'dapui_scopes'},
            },
            {
                sections = { lualine_a = {{
                    function() return 'Console' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'dapui_console'},
            },
            {
                sections = { lualine_a = {{
                    function() return 'Repl' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'dap-repl'},
            },
            {
                sections = { lualine_b = {{
                    function() return 'Terminal' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'toggleterm'},
            }
        },
        options = {
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            disabled_filetypes = {
                "dapui_watches", "dapui_stacks", "dapui_breakpoints",
            },
            ignore_focus = {
                "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes", "dapui_console",
                "NvimTree", "coctree",
            },
        },
        sections = {
            lualine_a = {
                {
                    'mode',
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                },
            },
            lualine_b = {
                {
                    "b:gitsigns_head",
                    icon = "",
                    color = { gui = "bold" },
                    padding = { left = 1, right = 0 },
                },
            },
            lualine_c = {
                {
                    'filename',
                    file_status = false,
                    path = 4,
                    symbols = {
                        unnamed = ' ', -- Text to show for unnamed buffers.
                    },
                },
                {
                    function()
                        if vim.bo.modified then
                            return ''
                        end
                        return ''
                    end,
                    color = { fg = "Green" },
                    padding = { left = 0, right = 1 },
                },
                {
                    function()
                        if vim.bo.readonly then
                            return ''
                        end
                        return ''
                    end,
                    color = { fg = "Brown" },
                    padding = { left = 0, right = 1 },
                },
                {
                    'diff',
                    diff_color = {
                        added = 'LualineGitAdd',
                        modified = 'LualineGitChange',
                        removed = 'LualineGitDelete',
                    },
                    symbols = { added = ' ', modified = '󰤌 ', removed = ' ' },
                    padding = { left = 0, right = 1 },
                },
                {
                    function()
                        local items = vim.b.coc_nav
                        local t = {''}
                        for k,v in ipairs(items) do
                            local highlight = v.highlight or "Normal"
                            local name = v.name or ''
                            local has_label = type(v.label) ~= 'nil'
                            if has_label then
                                t[#t+1] = '%#' .. highlight .. '# ' .. v.label .. ' %#Normal#'.. name
                            else
                                t[#t+1] = '%#' .. highlight .. '#  %#Normal#' .. name
                            end
                            if next(items,k) ~= nil then
                                t[#t+1] = '%#Comment# '
                            end
                        end
                        return table.concat(t)
                    end,
                    padding = { left = 0, right = 1 },
                },
            },
            lualine_x = {
                { 'g:coc_status', padding = { left = 1, right = 0 } },
                {
                    'diagnostics',
                    diagnostics_color = {
                        error = 'CocErrorLualine',
                        warn  = 'CocWarningLualine',
                        info  = 'CocInfoLualine',
                        hint  = 'CocHintLualine',
                    },
                    symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
                    padding = { left = 1, right = 0 },
                },
                {
                    'copilot',
                    show_running = true,
                    symbols = {
                        status = {
                            enabled = "",
                            disabled = "",
                        },
                        spinners = require("copilot-status.spinners").dots,
                    },
                    padding = { left = 1, right = 0 },
                },
                {
                    function()
                        local b = vim.api.nvim_get_current_buf()
                        if next(vim.treesitter.highlighter.active[b]) then
                            return ""
                        end
                        return ""
                    end,
                    color = { fg = "Green" },
                    padding = { left = 1, right = 0 },
                },
                {
                    function()
                        local shift_width = vim.api.nvim_buf_get_option(0, "shiftwidth")
                        local tab_stop = vim.api.nvim_buf_get_option(0, "tabstop")
                        local expand_tab = ""
                        if vim.api.nvim_buf_get_option(0, "expandtab") then
                            expand_tab = "E"
                        else
                            expand_tab = "T"
                        end
                        return shift_width .. ":" .. tab_stop .. ":" .. expand_tab
                    end,
                    padding = { left = 1, right = 0 },
                },
                { 'encoding', padding = { left = 1, right = 0 }, },
                'fileformat',
            },
            lualine_y = {
                { 'filetype', padding = { left = 0, right = 1 }, color = { gui = "bold" }, },
            },
            lualine_z = {
                {
                    'location',
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                },
                {
                    function()
                        local current_line = vim.fn.line "."
                        local total_lines = vim.fn.line "$"
                        local chars = { " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
                        local line_ratio = current_line / total_lines
                        local index = math.ceil(line_ratio * #chars)
                        return chars[index]
                    end,
                    padding = { left = 0, right = 0 },
                    color = "Keyword",
                },
            },
        },
    }
EOF
endif

" === which-key.nvim ===
if has("nvim")
    lua << EOF
    require("which-key").setup {
        plugins = {
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 40,
            }
        },
        window = {
            winblend = 10,
        },
        layout = {
            align = 'center',
        },
        triggers_blacklist = {
            c = { "j", "k" },
        },
        icons = {
            group = "",
        },
    }
EOF
endif

" === indent-blankline.nvim ===
if has("nvim")
    lua << EOF
    require("ibl").setup {
        scope = {
            enabled = true,
            show_start = true,
            show_end = false,
        },
        exclude = {
            filetypes = {
                'startify',
            },
        },
    }
    local hooks = require "ibl.hooks"
    hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
    )
EOF
endif

" === nvim-hlslens ===
if has("nvim")
    lua << EOF
    require("scrollbar.handlers.search").setup({
        calm_down = true,
        override_lens = function(render, posList, nearest, idx, relIdx)
            local sfw = vim.v.searchforward == 1
            local indicator, text, chunks
            local absRelIdx = math.abs(relIdx)
            if absRelIdx > 1 then
                indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
            elseif absRelIdx == 1 then
                indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
            else
                indicator = ''
            end

            local lnum, col = unpack(posList[idx])
            if nearest then
                local cnt = #posList
                if indicator ~= '' then
                    text = ('[%s %d/%d]'):format(indicator, idx, cnt)
                else
                    text = ('[%d/%d]'):format(idx, cnt)
                end
                chunks = {{' '}, {text, 'HlSearchLensNear'}}
            else
                text = ('[%s %d]'):format(indicator, idx)
                chunks = {{' '}, {text, 'HlSearchLens'}}
            end
            render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
    })

    local kopts = {noremap = true, silent = true}
    vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
    vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
EOF
endif

" === nvim-scrollbar ===
if has("nvim")
    lua << EOF
    require("scrollbar").setup {
        hide_if_all_visible = true,
        excluded_buftypes = {
            "nofile",
        },
        excluded_filetypes = {
            "dropbar_menu",
            "NvimTree",
            "TelescopePrompt",
        },
        marks = {
            Cursor = {
                text = "",
            },
        },
        handlers = {
            cursor = true,
            diagnostic = true,
            gitsigns = true,
            handle = true,
            search = true,
        }
    }
EOF
endif

" === wilder.nvim ===
if has("nvim")
    lua << EOF
    local wilder = require('wilder')
    wilder.setup({
        modes = {':', '/', '?'},
        next_key = '<C-p>',
        previous_key = '<C-n>',
    })
    wilder.set_option('pipeline', {
        wilder.branch(
            wilder.cmdline_pipeline({
                fuzzy = 1,
                fuzzy_filter = wilder.lua_fzy_filter(),
            }),
            wilder.vim_search_pipeline()
        ),
    })
    local gradient = {
        '#f4468f', '#fd4a85', '#ff507a', '#ff566f', '#ff5e63',
        '#ff6658', '#ff704e', '#ff7a45', '#ff843d', '#ff9036',
        '#f89b31', '#efa72f', '#e6b32e', '#dcbe30', '#d2c934',
        '#c8d43a', '#bfde43', '#b6e84e', '#aff05b'
    }
    for i, fg in ipairs(gradient) do
        gradient[i] = wilder.make_hl('WilderGradient' .. i, 'NormalFloat', {{a = 1}, {a = 1}, {foreground = fg}})
    end
    wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_palette_theme({
            highlights = {
                gradient = gradient,
                border = 'FloatBorder',
                default = 'NormalFloat'
            },
            highlighter = wilder.highlighter_with_gradient({
                wilder.basic_highlighter(),
            }),
            left = {' ', wilder.popupmenu_devicons()},
            right = {' ', wilder.popupmenu_scrollbar()},
            border = 'rounded',
            max_height = '75%',
            min_height = 0,
            prompt_position = 'bottom',
            reverse = 1,
            pumblend = 20,
        })
    ))
EOF
endif

" === bufdelete.nvim ===
if has("nvim")
    nnoremap <silent> <leader>c :lua require('bufdelete').bufdelete(0)<CR>
endif

" === nvim-notify ===
if has("nvim")
    lua << EOF
    require('telescope').load_extension('notify')
    vim.notify = require("notify")
    require("notify").setup()
EOF
endif

" === smart-pairs ===
if has("nvim")
    lua << EOF
    require('pairs'):setup {
        indent = {
            python = 1,
        },
        mapping = {
            jump_left_in_any   = '<m-h>',
            jump_right_out_any = '<m-l>',
            jump_left_out_any  = '<m-[>',
            jump_right_in_any  = '<m-]>',
        },
    }
EOF
endif

" === gitsigns.nvim ===
if has("nvim")
    lua << EOF
    require('gitsigns').setup {
        signs = {
            add          = { text = '█' },
            change       = { text = '█' },
            delete       = { text = '▶' },
            topdelete    = { text = '▶' },
            changedelete = { text = '█' },
            untracked    = { text = '┆' },
        },
        current_line_blame_opts = {
            virt_text_pos = 'right_align',
            delay = 10,
            ignore_whitespace = true,
        },
        preview_config = {
            border = 'rounded',
        },
        on_attach = function(bufnr)
            local function map(mode, lhs, rhs, opts)
                opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
            end

            -- Navigation
            map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
            map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

            -- Actions
            map('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>')
            map('v', '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>')
            map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
            map('v', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
            map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>')
            map('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
            map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
            map('n', '<leader>gb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
            map('n', '<leader>gD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
            map('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
            map('n', '<leader>gtd', '<cmd>Gitsigns toggle_deleted<CR>')
            map('n', '<leader>gtl', '<cmd>Gitsigns toggle_linehl<CR>')
            map('n', '<leader>gtn', '<cmd>Gitsigns toggle_numhl<CR>')
            map('n', '<leader>gtw', '<cmd>Gitsigns toggle_word_diff<CR>')
            map('n', '<leader>gts', '<cmd>Gitsigns toggle_signs<CR>')

            -- Text object
            map('o', 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
            map('x', 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
        end
    }
EOF
endif

" === diffview.nvim ===
if has("nvim")
    nnoremap <silent> <leader>gd :DiffviewOpen<CR>
    nnoremap <silent> <leader>gh :DiffviewFileHistory<CR>
    nnoremap <silent> <leader>gf :DiffviewFileHistory %<CR>
    lua << EOF
    -- local cb = require'diffview.config'.diffview_callback
    require('diffview').setup {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        file_panel = {
            win_config = {
                width = 30,
            },
        },
        keymaps = {
            view = {
                { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Quit diffview" } },
            },
            file_panel = {
                { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Quit diffview" } },
            },
            file_history_panel = {
                { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Quit diffview" } },
            },
        },
    }
EOF
endif

" === vim-markdown ===
if ! has("nvim")
    let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'vim', 'zsh', 'lua', 'cpp', 'c']
endif

" === copilot.vim ===
if has("nvim")
    imap <silent><script><expr> <M-a> copilot#Accept("\<CR>")
    imap <M-Right> <Plug>(copilot-accept-word)
    imap <M-C-Right> <Plug>(copilot-accept-line)
    imap <M-p> <Plug>(copilot-previous)
    imap <M-n> <Plug>(copilot-next)
    let g:copilot_no_tab_map = v:true
endif

" === guess-indent.nvim ===
if has("nvim")
    lua << EOF
    require('guess-indent').setup {}
EOF
endif

" === virt-column.nvim ===
if has("nvim")
    lua << EOF
    require("virt-column").setup {
        char = "│",
        highlight = "VirtColumn",
    }
EOF
endif

" === leap.nvim ===
if has("nvim")
    lua << EOF
    vim.keymap.set({'n', 'x', 'o'}, 'f', '<Plug>(leap-forward-to)')
    vim.keymap.set({'n', 'x', 'o'}, 'F', '<Plug>(leap-backward-to)')
EOF
endif

" === neogit ===
if has("nvim")
    nnoremap <silent> <leader>gn :Neogit<CR>
    lua << EOF
    require("neogit").setup()
EOF
endif

" === dropbar.nvim ===
if has("nvim")
    nnoremap <silent> <leader>ds :lua require('dropbar.api').pick()<CR>
endif

" === nvim-surround ===
if has("nvim")
    lua << EOF
    require("nvim-surround").setup {}
EOF
endif

" === scope.nvim ===
if has("nvim")
    lua << EOF
    require("scope").setup({
    })
    require("telescope").load_extension("scope")
EOF
endif

" === wildfire.nvim ===
if has("nvim")
    lua << EOF
    require("wildfire").setup()
EOF
endif

" === dressing.nvim ===
if has("nvim")
    lua << EOF
    require("dressing").setup()
EOF
endif

" === resession.nvim ===
if has("nvim")
    lua << EOF
    local resession = require("resession")
    resession.setup({
        load_order = "filename",
        options = {
            "binary",
            "bufhidden",
            "buflisted",
            "buftype",
            "cmdheight",
            "diff",
            "filetype",
            "modifiable",
            "previewwindow",
            "readonly",
            "scrollbind",
            "winfixheight",
            "winfixwidth",
        },
    })
    vim.keymap.set("n", "<leader>ss", resession.save)
    vim.keymap.set("n", "<leader>sl", resession.load)
    resession.add_hook("post_load", function()
        if vim.fn.winwidth(0) >= 130 then
            vim.fn.OpenUnfocusedNvimTreeInNewWindow()
        end
    end)
EOF
    function LoadSessionInCurrentCwd()
        lua << EOF
        local cwd = vim.fn.getcwd()
        local session_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/session/")
        local session_files = vim.fn.globpath(session_dir, "*.json", 0, 1)

        for _, session_file in ipairs(session_files) do
            local session = vim.fn.json_decode(vim.fn.readfile(session_file))
            if session.global and session.global.cwd == cwd then
                require("resession").load(vim.fn.fnamemodify(session_file, ":t:r"))
                return
            end
        end

        print("No session file found for current working directory.")
EOF
    endfunction
endif

" === Overseer.nvim ===
if has("nvim")
    lua << EOF
    overseer = require("overseer")
    overseer.register_template({
        name = "run project",
        strategy = "toggleterm",
        builder = function(params)
            return {
                cmd = { "python", "main.py" },
            }
        end,
        condition = {
            callback = function()
                return vim.fn.filereadable("main.py") == 1
            end,
        },
    })
    overseer.register_template({
        name = "run this file",
        builder = function(params)
            local cmds = {
                go = "go run",
                python = "python",
                sh = "bash",
                zsh = "zsh",
                ps1 = "pwsh -NoProfile -File",
            }
            local cmd = cmds[vim.bo.filetype] .. " " .. vim.api.nvim_buf_get_name(0)
            return {
                cmd = vim.split(cmd, " "),
            }
        end,
        condition = {
            filetype = { "python", "sh", "zsh", "go", "ps1" },
        },
    })
    overseer.setup({
        strategy = "terminal",
        task_list = {
            default_detail = 1,
            min_height = 10,
        },
        component_aliases = {
            default = {
                "open_output",
                { "display_duration", detail_level = 2 },
                "on_output_summarize",
                "on_exit_set_status",
                { "on_complete_notify", statuses = { "FAILURE" } },
                { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
                "unique",
            },
        },
        bundles = {
            autostart_on_load = false,
        },
    })
    require("compiler").setup()
    vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, {})
EOF
    nnoremap <silent> <C-c> <cmd>OverseerToggle!<CR>
    nnoremap <silent> <leader>rc <cmd>CompilerOpen<CR>
    nnoremap <silent> <leader>ro <cmd>OverseerRun<CR>
    nnoremap <silent> <leader>rr <cmd>OverseerRestartLast<CR>
    nnoremap <silent> <leader>rp <cmd>lua require("overseer").run_template({name = "run project"})<CR>
    nnoremap <silent> <leader>ru <cmd>lua require("overseer").run_template({name = "run this file"})<CR>
endif

" === CopilotChat.nvim ===
if has("nvim")
    lua << EOF
    require("CopilotChat").setup {}
EOF
endif

" === mason.nvim ===
if has("nvim")
    lua << EOF
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "󰏗",
                package_pending = "󱧕",
                package_uninstalled = "󰏗",
            },
        },
    })
EOF
endif

" === nvim-dap ===
if has("nvim")
    lua << EOF
    require("telescope").load_extension("dap")
    require("nvim-dap-virtual-text").setup()
    require("mason-nvim-dap").setup({
        ensure_installed = {'bash', 'cppdbg', 'codelldb', 'python'},
    })
    require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    local python_debug_project_configuration = {
        type = "python",
        request = "launch",
        name = "Launch project",
        program = "main.py",
        console = "integratedTerminal",
    }
    if vim.fn.filereadable("main.py") == 1 then
        table.insert(require("dap").configurations.python, 1, python_debug_project_configuration)
        vim.keymap.set("n", "<leader>dp", function() require("dap").run(python_debug_project_configuration) end)
    end
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup({
        mappings = {
            expand = { "o", "<2-LeftMouse>" },
            open = "<CR>",
        },
    })
    dap.listeners.before.launch.dapui_config = function()
        if require("nvim-tree.api").tree.is_visible() then
            require("nvim-tree.api").tree.close()
        end
        dapui.open()
    end
    dap.adapters.codelldb = {
        -- see: https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            args = {
                "--settings", "{ \"showDisassembly\": \"never\" }",
                "--port", "${port}"
            },
            -- On windows you may have to uncomment this:
            -- detached = false,
        }
    }
    local adapter_cppdbg = {
        -- see: https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }
    if vim.fn.has("win32") == 1 then
        adapter_cppdbg = vim.tbl_extend("force", adapter_cppdbg, {
            command = vim.fn.stdpath("data") .. "\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
            options = {
                detached = false
            }
        })
    end
    dap.adapters.cppdbg = adapter_cppdbg
    dap.adapters.gdb = {
        -- see: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-gdb
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" }
    }
    dap.adapters.bashdb = {
        -- see: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#bash
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
    }
    dap.configurations.cpp = {
        {
            name = "Launch using cppdbg (gcc)",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
        },
        {
            name = "Launch using codelldb (clang)",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
        },
        {
            name = "Launch using native gdb (gcc)",
            type = "gdb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
        },
        {
            name = "Attach to gdbserver :1234 (gcc)",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = "localhost:1234",
            -- miDebuggerPath = "/usr/bin/gdb",
            cwd = "${workspaceFolder}",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
        }
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.sh = {
        {
            name = "Launch file",
            type = "bashdb",
            request = "launch",
            showDebugOutput = true,
            pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
            pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
            trace = false,
            file = "${file}",
            program = "${file}",
            cwd = "${workspaceFolder}",
            pathCat = "cat",
            pathBash = "bash",
            pathMkfifo = "mkfifo",
            pathPkill = "pkill",
            args = {},
            argsString = "",
            env = {},
            terminalKind = "integrated",
            stopOnEntry = false,
        }
    }
    vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='DapBreakpointLine', numhl=''})
    vim.fn.sign_define('DapBreakpointCondition', {text='󰻂', texthl='DapBreakpoint', linehl='DapBreakpointLine', numhl=''})
    vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='DapBreakpointLine', numhl=''})
    vim.fn.sign_define('DapLogPoint', {text='', texthl='DapLogPoint', linehl='DapLogPointLine', numhl=''})
    vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='DapStoppedLine', numhl=''})
EOF

    function ToggleDapUI()
        lua << EOF
        local dapui_exists = vim.fn.bufwinnr('DAP Breakpoints') > 0
        local nvim_tree_exists = require("nvim-tree.api").tree.is_visible()

        require("dapui").toggle()

        if dapui_exists then
            if not nvim_tree_exists and vim.fn.winwidth(0) >= 130 then
                require("nvim-tree.api").tree.toggle({ focus = false })
            end
        elseif nvim_tree_exists then
            require("nvim-tree.api").tree.close()
        end
EOF
    endfunction

    nnoremap <silent> <C-a> <cmd>call ToggleDapUI()<CR>
    nnoremap <silent> <F3> <cmd>lua require'dap'.pause()<CR>
    nnoremap <silent> <F4> <cmd>lua require'dap'.continue()<CR>
    nnoremap <silent> <F5> <cmd>lua require'dap'.step_into()<CR>
    nnoremap <silent> <F6> <cmd>lua require'dap'.step_over()<CR>
    nnoremap <silent> <F7> <cmd>lua require'dap'.step_out()<CR>
    nnoremap <silent> <F8> <cmd>lua require'dap'.terminate()<CR>
    nnoremap <silent> <leader>do <cmd>lua require'dap'.continue()<CR>
    nnoremap <silent> <leader>dl <cmd>lua require'dap'.run_last()<CR>
    nnoremap <silent> <leader>b <cmd>lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <leader>B <cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
endif


" ===============

" ==================
" ===  mappings  ===
" ==================
"
nmap <C-n> g*
vmap <C-n> *
nmap <C-p> g#
vmap <C-p> #

nnoremap <silent> <M-s> :w<CR>
nnoremap <silent> <M-S-s> :wall<CR>
nnoremap <silent> <M-w> :q<CR>
nnoremap <silent> <M-q> :q!<CR>

function EditVimrc(way)
    if has("win32")
        if a:way == "normal"
            execute ":e ~\\_vimrc"
        elseif a:way == "vs"
            execute ":vs ~\\_vimrc"
        endif
    else
        if a:way == "normal"
            execute ":e ~/.vimrc"
        elseif a:way == "vs"
            execute ":vs ~/.vimrc"
        endif
    endif
endfunction

nnoremap <silent> <leader>sf :w<CR>:source $MYVIMRC<CR>
if has("nvim")
    nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
endif
nnoremap <silent> <leader>ef :call EditVimrc("normal")<CR>
nnoremap <silent> <leader>er :call EditVimrc("vs")<CR>

nnoremap <silent> <leader>ww :w<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>wq :wq<CR>
nnoremap <silent> <leader>fq :q!<CR>
nnoremap <silent> <leader>rq :qa<CR>
nnoremap <silent> <leader>ewq :wqa<CR>
nnoremap <silent> <leader>gq :call SaveSession("")<CR>:qa<CR>
nnoremap <silent> <leader><leader>r :redraw!<CR>
nnoremap <silent> <leader>i :Inspect<CR>

nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M--> <C-w>_
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
nnoremap <leader>sp <C-w>s
nnoremap <leader>vs <C-w>v

nnoremap <silent> <M-[> :tabp<CR>
nnoremap <silent> <M-]> :tabn<CR>
nnoremap <silent> <M-n> :tabnew<CR>
nnoremap <silent> <M-S-c> :tabc<CR>
if ! has("nvim")
    nnoremap <leader>c :bd<CR>
endif

noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>P "+P

nmap <C-J> ]c
nmap <C-K> [c
nnoremap <C-H> 10zh
nnoremap <C-L> 10zl
inoremap <C-J> <esc>o
inoremap <C-K> <esc>O
inoremap <C-H> <esc>I
inoremap <C-L> <esc>A

nnoremap <silent> DO :%diffget<CR>
nnoremap <silent> DP :%diffput<CR>
nnoremap <silent> DU :diffupdate<CR>

for mapping in ['jj', 'jk', 'kj', 'kk', 'jl', 'jh']
    execute 'inoremap '.mapping.' <esc>'
    execute 'cnoremap '.mapping.' <C-c>'
endfor
if has("unix") && (system('uname -a') =~ "Android")
    inoremap `` <esc>
    cnoremap `` <C-c>
    vnoremap `` <esc>
endif

nnoremap <silent> <C-Up> :resize -2<CR>
nnoremap <silent> <C-Down> :resize +2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

let g:load_doxygen_syntax=1

" comment before duplicate a line
nmap DC gccyypgcc
nmap DR ddkgcc

" ===============

" ==============
" ===  misc  ===
" ==============
"

" let Vim jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

" disable auto insert comment leader
autocmd FileType * set formatoptions-=cro

" clear jump list when open editor
autocmd VimEnter * :clearjumps

" auto switch mode for terminal
autocmd TermOpen term://* let g:terminal_running = v:true
autocmd WinEnter term://* if g:terminal_running | startinsert
autocmd TermClose term://* let g:terminal_running = v:false | stopinsert


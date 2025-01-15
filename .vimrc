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
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
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
    Plug 'RubixDev/mason-update-all'
    Plug 'jay-babu/mason-nvim-dap.nvim'
    Plug 'LiadOz/nvim-dap-repl-highlights'
    Plug 'Weissle/persistent-breakpoints.nvim'
    Plug 'Carcuis/dap-breakpoints.nvim'
    Plug 'MeanderingProgrammer/render-markdown.nvim'
    Plug 'chrisgrieser/nvim-rip-substitute'
    Plug 'OXY2DEV/helpview.nvim'
    Plug 'stevearc/quicker.nvim'
    Plug 'SCJangra/table-nvim'
    Plug 'linux-cultist/venv-selector.nvim', { 'branch': 'regexp' }
    Plug 'mikavilpas/yazi.nvim'
    Plug 'kawre/leetcode.nvim'
    Plug 'MunifTanjim/nui.nvim'
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
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
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
set guicursor+=n:blinkwait200-blinkon600-blinkoff500
set termguicolors
set signcolumn=yes
set timeoutlen=500
set conceallevel=2
set colorcolumn=120
if exists("+jumpoptions")
    set jumpoptions=stack
endif
set pumheight=15
set confirm

if has("nvim")
    if has("win32")
        let g:python3_host_prog = stdpath('data') . '/pynvim/venv/Scripts/python.exe'
    else
        let g:python3_host_prog = stdpath('data') . '/pynvim/venv/bin/python3'
    endif
    set fillchars=eob:\ ,diff:\ ,fold:\ ,foldsep:\ ,foldopen:,foldclose:
    if has("win32") || has("wsl")
        set guifont=CaskaydiaCove\ NFM,Microsoft\ YaHei\ UI:h13:#e-subpixelantialias
    elseif has("linux")
        set guifont=UbuntuMono\ NF:h16
    elseif has("mac")
        set guifont=CaskaydiaCove\ Nerd\ Font\ Mono:h18
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

    set belloff=all
endif

if exists("g:neovide")
    let g:neovide_cursor_vfx_mode = "wireframe"
    let g:neovide_cursor_trail_size = 0.5
    let g:neovide_profiler = v:false
    let g:neovide_floating_shadow = v:false
    let g:neovide_scroll_animation_length = 0.15
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_underline_stroke_scale = 2.0
    let g:neovide_cursor_animate_command_line = v:false
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
    nnoremap <leader>tt <cmd>NERDTreeToggle<CR>
    map <F2> <cmd>NERDTree<CR>
    let NERDTreeShowHidden = 1
    " let NERDTreeShowBookmarks = 1
    let NERDTreeWinSize = min([max([25, winwidth(0) / 5]), 30])
    if (winwidth(0) > 140 || has("gui_running")) && argc() < 2
        au VimEnter * NERDTree | set signcolumn=auto | wincmd p
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
    nnoremap <leader>fr <cmd>LeaderfMru<CR>
endif

" === vim-commentary ===
autocmd FileType java,c,cpp,json set commentstring=//\ %s
autocmd FileType ps1,sshdconfig set commentstring=#\ %s

" === indentline ===
if ! has("nvim")
    let g:indentLine_char = '│'
    au FileType startify,which_key IndentLinesDisable
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
    nnoremap <leader>tb <cmd>TagbarToggle<CR>
    let g:tagbar_width = min([max([25, winwidth(0) / 5]), 30])
    " if (winwidth(0) > 100 || has("gui_running")) && argc() < 2
    "   " autocmd VimEnter * nested :TagbarOpen
    "   " autocmd BufEnter * nested :call tagbar#autoopen(0)
    "   autocmd FileType * nested :call tagbar#autoopen(0)
    " endif
    let g:tagbar_iconchars = ['', '']
endif

" === vim-startify ===
nnoremap <leader>; <cmd>Startify<CR>
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
    \ {'C': ['  Configure CoC', 'e '.expand(stdpath("config")."/coc-settings.json")]},
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
    nnoremap <leader>ss <cmd>call SaveSession("")<CR>
    nnoremap <leader>sl <cmd>call LoadSession("")<CR>
    nnoremap <leader>gq <cmd>call SaveSession("")<CR><cmd>qa<CR>
endif

" === vim-highlightedyank ===
let g:highlightedyank_highlight_duration = 200

" === coc.nvim ===
if has("nvim")
    let g:coc_global_extensions = [
                \ 'coc-json', 'coc-vimlsp', 'coc-marketplace', 'coc-markdownlint', 'coc-markdown-preview-enhanced',
                \ 'coc-basedpyright', 'coc-powershell', 'coc-sh', 'coc-clangd', 'coc-webview',
                \ 'coc-cmake', 'coc-actions', 'coc-translator', 'coc-snippets', 'coc-gitignore',
                \ 'coc-sumneko-lua', 'coc-tsserver', 'coc-eslint', 'https://github.com/Carcuis/coc-nav',
                \ 'coc-xml', 'coc-yaml', 'coc-toml', 'coc-java-dev', 'coc-css', 'coc-sql']
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : "\<TAB>"
    inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(0) : "\<C-n>"
    inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(0) : "\<C-p>"
    inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(1) : "\<down>"
    inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(1) : "\<up>"
    inoremap <silent><expr> <c-e> coc#pum#visible() ? coc#pum#cancel() : coc#refresh()
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " nmap <silent> gd <Plug>(coc-definition)
    " nmap <silent> gh <Plug>(coc-declaration)
    " nmap <silent> gt <Plug>(coc-type-definition)
    " nmap <silent> ge <Plug>(coc-implementation)
    " nmap <silent> gr <Plug>(coc-references)

    " See fannheyward/telescope-coc.nvim
    nmap gd <cmd>Telescope coc definitions<CR>
    nmap gh <cmd>Telescope coc declarations<CR>
    nmap gt <cmd>Telescope coc type-definitions<CR>
    nmap ge <cmd>Telescope coc implementations<CR>
    nmap gr <cmd>Telescope coc references<CR>

    nmap gp <cmd>call CocActionAsync('jumpDefinition', v:false)<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    nmap <silent> <leader>rn <Plug>(coc-rename)
    nmap <leader>RN <cmd>CocCommand document.renameCurrentWord<CR>
    nmap <silent> <S-F5> <Plug>(coc-rename)
    nmap <silent> <leader>rf <Plug>(coc-refactor)
    nmap <silent> <leader>lO <Plug>(coc-openlink)
    xmap <silent> <leader>a  <Plug>(coc-codeaction-selected)
    nmap <silent> <leader>a  <Plug>(coc-codeaction-selected)w
    nmap <M-f> <cmd>call CocActionAsync('format')<CR>
    nmap <M-e> <cmd>call CocActionAsync('doHover')<CR>
    nmap <M-d> <cmd>CocCommand semanticTokens.inspect<CR>
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
    command! -nargs=0 MarkdownPreviewEnhanced :CocCommand markdown-preview-enhanced.openPreview

    let g:coc_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
    let g:coc_notify_error_icon = ''
    let g:coc_notify_warning_icon = ''
    let g:coc_notify_info_icon = ''
    let g:coc_snippet_next = '<tab>'
    let g:coc_snippet_prev = '<s-tab>'

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
    nnoremap <leader> <cmd>WhichKey '<Space>'<CR>
    nnoremap g <cmd>WhichKey 'g'<CR>
    nnoremap [ <cmd>WhichKey '['<CR>
    nnoremap ] <cmd>WhichKey ']'<CR>
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
    nnoremap <leader>fe <cmd>Telescope grep_string<cr>
    nnoremap <leader>f/ <cmd>Telescope current_buffer_fuzzy_find<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fH <cmd>Telescope highlights<cr>
    nnoremap <leader>fp <cmd>Telescope projects<cr>
    nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
    nnoremap <leader>fR <cmd>Telescope registers<cr>
    nnoremap <leader>fc <cmd>Telescope command_history<cr>
    nnoremap <leader>fn <cmd>Telescope notify<cr>
    nnoremap <leader>fu <cmd>Telescope resume<cr>
    nnoremap <leader>fgC <cmd>Telescope git_bcommits<cr>
    nnoremap <leader>fgb <cmd>Telescope git_branches<cr>
    nnoremap <leader>fgc <cmd>Telescope git_commits<cr>
    nnoremap <leader>fgf <cmd>Telescope git_files<cr>
    nnoremap <leader>fgs <cmd>Telescope git_status<cr>
    nnoremap <leader>fs <cmd>lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji', 'math', 'latex'} }<CR>
    nnoremap <leader>fdg <cmd>Telescope coc diagnostics<CR>
    nnoremap <leader>fdG <cmd>Telescope coc workspace_diagnostics<CR>
    nnoremap <leader>fdc <cmd>Telescope dap commands<CR>
    nnoremap <leader>fdC <cmd>Telescope dap configurations<CR>
    nnoremap <leader>fdb <cmd>Telescope dap list_breakpoints<CR>
    nnoremap <leader>fdv <cmd>Telescope dap variables<CR>
    nnoremap <leader>fdf <cmd>Telescope dap frames<CR>

    lua << EOF
    require('telescope').setup{
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            winblend = 10,
            vimgrep_arguments = {
                "rg",
                "--pcre2",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            },
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
            \'leetcode.nvim',
            \]

" === bufferline.nvim ===
if has("nvim")
    nnoremap gb <cmd>BufferLinePick<CR>
    nnoremap H <cmd>BufferLineCyclePrev<CR>
    nnoremap L <cmd>BufferLineCycleNext<CR>
    nnoremap <M-H> <cmd>BufferLineMovePrev<CR>
    nnoremap <M-L> <cmd>BufferLineMoveNext<CR>
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
            separator_style = vim.g.transparent_background == 1 and "thin" or "slant",
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
    nnoremap <leader>ee <cmd>NvimTreeToggle<CR>
    nnoremap <leader>E <cmd>NvimTreeFindFile!<CR>

    func OpenUnfocusedNvimTreeInNewWindow()
        lua << EOF
            local function autogroup_exists(group_name)
                local status, autocmds = pcall(vim.api.nvim_get_autocmds, { group = group_name })
                if not status then
                    return false
                end
                return #autocmds > 0
            end

            local data = {
                file = vim.fn.expand('%:p'),
                buf = vim.api.nvim_get_current_buf(),
            }
            -- buffer is a real file on the disk
            local real_file = vim.fn.filereadable(data.file) == 1

            -- buffer is a [No Name]
            local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

            local excluded_filetypes = {}

            local has_excluded_filetypes = vim.tbl_contains(excluded_filetypes, vim.bo[data.buf].filetype)
            local has_leetcode = autogroup_exists("leetcode_menu")

            if ( real_file or no_name ) and not has_excluded_filetypes and not has_leetcode then
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
                symlink_arrow = "  ",
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
        view = {
            width = math.floor(math.max(20, math.min(30, vim.o.columns / 5.5))),
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
    require('nvim-dap-repl-highlights').setup()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "python", "c", "cpp", "lua", "bash", "vim", "vimdoc", "go", "css", "javascript", "typescript", "make",
            "markdown", "markdown_inline", "toml", "yaml", "xml", "git_config", "json", "json5", "jsonc", "sql",
            "dap_repl", "latex", "regex", "powershell", "java", "gitattributes", "gitignore", "cmake", "html"
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
    nnoremap <M-c> <cmd>TSHighlightCapturesUnderCursor<CR>
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
            'quickfix',
            {
                sections = { lualine_a = {{
                        function()
                            return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
                        end,
                        padding = { left = 0, right = 0 },
                        separator = { left = '', right = '' },
                }}, },
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
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'toggleterm'},
            },
            {
                sections = {
                    lualine_b = {{
                        function()
                            return 'Terminal'
                        end,
                        icon = "",
                        padding = { left = 0, right = 0 },
                        separator = { left = '', right = '' },
                    }},
                    lualine_c = {
                        {
                            function()
                                if vim.g.terminal_running then
                                    return ""
                                end
                                return ""
                            end,
                            color = { fg = "Green" },
                            padding = { left = 1, right = 0 },
                        },
                        {
                            function()
                                local bufname = vim.api.nvim_buf_get_name(0)
                                local match = bufname:match("//%d+:(.*)")
                                return match or bufname
                            end,
                        }
                    },
                },
                filetypes = {'terminal'},
            },
            {
                sections = { lualine_b = {{
                    function() return 'LeetCode' end,
                    icon = "",
                    padding = { left = 0, right = 0 },
                    separator = { left = '', right = '' },
                }}, },
                filetypes = {'leetcode.nvim'},
            },
        },
        options = {
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            disabled_filetypes = {
                "dapui_watches", "dapui_stacks", "dapui_breakpoints",
            },
            ignore_focus = {
                "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes", "dapui_console",
                "NvimTree", "coctree", "OverseerList", "terminal"
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
                    function()
                        local conda_prefix = os.getenv("CONDA_PREFIX")
                        local virtual_env = os.getenv("VIRTUAL_ENV")
                        local venv = conda_prefix or virtual_env
                        local venv_name = venv:match("envs[/\\]([^/\\]+)$")
                        if venv_name then
                            return ":"..venv_name
                        elseif conda_prefix ~= nil then
                            venv_name = require("venv-selector").python():match("envs\\([^\\]+)\\python.exe$")
                            if venv_name then
                                return ":"..venv_name
                            end
                            return ":base"
                        end
                        venv_name = venv:match("([^/\\]+)[/\\]venv$")
                        if venv_name then
                            return ":"..venv_name
                        end
                        return ""
                    end,
                    on_click = function() vim.cmd.VenvSelect() end,
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
        preset = "classic",
        plugins = {
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 40,
            }
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
    if vim.g.transparent_background == 0 then
        local hooks = require "ibl.hooks"
        hooks.register(
            hooks.type.WHITESPACE,
            hooks.builtin.hide_first_space_indent_level
        )
    end
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
    nnoremap <leader>c <cmd>lua require('bufdelete').bufdelete(0)<CR>
endif

" === nvim-notify ===
if has("nvim")
    lua << EOF
    require('telescope').load_extension('notify')
    vim.notify = require("notify")
    require("notify").setup({
        stages = "fade",
        timeout = 10,
    })
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
            -- jump_left_in_any   = '<m-h>',
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
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '▶' },
            topdelete    = { text = '▶' },
            changedelete = { text = '┃' },
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
    nnoremap <leader>gd <cmd>DiffviewOpen<CR>
    nnoremap <leader>gh <cmd>DiffviewFileHistory<CR>
    nnoremap <leader>gf <cmd>DiffviewFileHistory %<CR>
    lua << EOF
    -- local cb = require'diffview.config'.diffview_callback
    require('diffview').setup {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        file_panel = {
            win_config = {
                width = 30,
            },
        },
        icons = {                 -- Only applies when use_icons is true.
            folder_closed = "󰉋",
            folder_open = "",
        },
        signs = {
            fold_closed = "",
            fold_open = "",
            done = "",
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

    vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewViewEnter",
        callback = function()
            vim.cmd.NvimTreeClose()
            vim.cmd.wincmd("l")
        end
    })
    vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewDiffBufWinEnter",
        callback = function()
            vim.api.nvim_input('gg')
            vim.api.nvim_input(']c')
        end
    })
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "diffview://null",
        callback = function()
            vim.keymap.set("n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Quit Diffview", buffer = true })
        end
    })
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
    let g:copilot_filetypes = {
                \ 'rip-substitute' : v:false,
                \ }
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
    nnoremap <leader>gn <cmd>Neogit<CR>
    lua << EOF
    require("neogit").setup()
EOF
endif

" === dropbar.nvim ===
if has("nvim")
    nnoremap <leader>ds <cmd>lua require('dropbar.api').pick()<CR>
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
    vim.keymap.set("n", "<leader>ss", resession.save, { desc = "Save Session" })
    vim.keymap.set("n", "<leader>sl", resession.load, { desc = "Load Session" })
    vim.keymap.set("n", "<leader>sd", resession.delete, { desc = "Delete Session" })
    vim.keymap.set("n", "<leader>gq", function()
        resession.save()
        vim.cmd.quit()
    end, { desc = "Save Session and Quit" })
    resession.add_hook("post_load", function()
        if vim.fn.winwidth(0) >= 130 then
            vim.fn.OpenUnfocusedNvimTreeInNewWindow()
        end
        vim.cmd.VenvSelectCached()
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
                c = function()
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
                    local output = filename:gsub("%.c$", "")
                    local run_prefix = ""
                    if vim.fn.has("win32") == 1 then
                        if not output:find("\\") then run_prefix = ".\\" end
                        output = output .. ".exe"
                    else
                        if not output:find("/") then run_prefix = "./" end
                        output = output .. ".out"
                    end
                    return "gcc " .. filename .. " -o " .. output .. " && " .. run_prefix .. output
                end,
                cpp = function()
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
                    local output = filename:gsub("%.cpp$", "")
                    local run_prefix = ""
                    if vim.fn.has("win32") == 1 then
                        if not output:find("\\") then run_prefix = ".\\" end
                        output = output .. ".exe"
                    else
                        if not output:find("/") then run_prefix = "./" end
                        output = output .. ".out"
                    end
                    return "g++ " .. filename .. " -o " .. output .. " && " .. run_prefix .. output
                end,
                java = function()
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
                    local output = filename:gsub("%.java$", "")
                    return "javac -d class " .. filename .. " && java -cp class " .. output
                end,
            }
            local cmd = cmds[vim.bo.filetype]
            if type(cmd) == "function" then
                return {
                    cmd = cmd(),
                }
            else
                cmd = cmd .. " " .. vim.api.nvim_buf_get_name(0)
                return {
                    cmd = vim.split(cmd, " "),
                }
            end
        end,
        condition = {
            filetype = { "python", "sh", "zsh", "go", "ps1", "c", "cpp", "java" },
        },
    })

    local function pre_overseer_run()
        vim.cmd.wall()
        vim.cmd.CloseDapUI()
    end
    overseer.add_template_hook(nil, pre_overseer_run)

    overseer.setup({
        strategy = "terminal",
        task_list = {
            default_detail = 2,
            min_height = 10,
        },
        component_aliases = {
            default = {
                "open_output",
                { "display_duration", detail_level = 3 },
                { "on_output_summarize", max_lines = 2 },
                "on_exit_set_status",
                { "on_complete_notify", statuses = { "FAILURE" } },
                "unique",
            },
        },
        bundles = {
            autostart_on_load = false,
        },
    })
    require("compiler").setup()

    local keymaps = {
        {
            mode = "n", key = "<C-c>", desc = "Toggle Overseer", func = function()
                vim.cmd.CloseDapUI()
                overseer.toggle({ enter = false })
            end,
        },
        {
            mode = "n", key = "<leader>rr", desc = "Restart Last Task", func = function()
                pre_overseer_run()
                local tasks = overseer.list_tasks({ recent_first = true })
                if vim.tbl_isempty(tasks) then
                    vim.notify("No tasks found", vim.log.levels.WARN, { title = "Overseer Restart Last" })
                else
                    overseer.run_action(tasks[1], "restart")
                end
            end
        },
        {
            mode = "n", key = "<leader>rp", desc = "Run Project", func = function()
                require('overseer').run_template({name = 'run project'})
            end
        },
        {
            mode = "n", key = "<leader>ru", desc = "Run This File", func = function()
                require('overseer').run_template({name = 'run this file'})
            end
        },
        { mode = "n", key = "<leader>ro", func = vim.cmd.OverseerRun, desc = "Run Task" },
        { mode = "n", key = "<leader>rc", func = vim.cmd.CompilerOpen, desc = "Open Compiler" },
    }
    for _, keymap in ipairs(keymaps) do
        vim.keymap.set(keymap.mode, keymap.key, keymap.func, { desc = keymap.desc })
    end
EOF
endif

" === CopilotChat.nvim ===
if has("nvim")
    lua << EOF
    require("CopilotChat").setup({
        model = 'gpt-4o-2024-08-06',
        show_folds = false,
        context = 'buffers',
        window = {
            layout = 'float',
            width = 0.7,
            height = 0.8,
            border = 'rounded',
        },
    })
    vim.keymap.set({ "i", "n", "v" }, "<M-i>", require('CopilotChat').toggle, { desc = "Toggle Copilot Chat" })
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
    require("mason-update-all").setup()
EOF
endif

" === nvim-dap ===
if has("nvim")
    lua << EOF
    require("telescope").load_extension("dap")
    require("nvim-dap-virtual-text").setup()

    local mason_dap_ensure_installed = { "bash", "codelldb", "cppdbg", "python" }
    local packages_to_remove = {}
    local machine = vim.uv.os_uname().machine
    if string.find(machine, "aarch64") then
        packages_to_remove = { "codelldb" }
    elseif string.find(machine, "armv7") then
        packages_to_remove = { "codelldb", "cppdbg" }
    end
    if #packages_to_remove > 0 then
        for i = #mason_dap_ensure_installed, 1, -1 do
            if vim.tbl_contains(packages_to_remove, mason_dap_ensure_installed[i]) then
                table.remove(mason_dap_ensure_installed, i)
            end
        end
    end
    require("mason-nvim-dap").setup({ ensure_installed = mason_dap_ensure_installed })

    local dap_python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
    if vim.fn.has("win32") == 1 then
        dap_python_path = vim.fn.stdpath("data") .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
    end
    require("dap-python").setup(dap_python_path)

    local dap, dapui = require("dap"), require("dapui")

    dapui.setup({
        mappings = {
            expand = { "o", "<2-LeftMouse>" },
            open = "<CR>",
        },
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.25
            }, {
                id = "breakpoints",
                size = 0.25
            }, {
                id = "stacks",
                size = 0.25
            }, {
                id = "watches",
                size = 0.25
            } },
            position = "left",
            size = math.floor(math.max(20, math.min(40, vim.o.columns / 5)))
        }, {
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
            position = "bottom",
            size = math.floor(math.max(5, math.min(10, vim.o.lines / 5)))
        } },
    })
    dap.listeners.before.launch.dapui_config = function()
        vim.cmd.NvimTreeClose()
        vim.cmd.OverseerClose()
        dapui.open()
    end

    local python_debug_project = {
        type = "python",
        request = "launch",
        name = "Launch project",
        program = "main.py",
        console = "integratedTerminal",
    }
    local python_debug_file = {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        console = "integratedTerminal",
    }
    table.insert(dap.configurations.python, 1, python_debug_project)
    table.insert(dap.configurations.python, 1, python_debug_file)

    vim.keymap.set("n", "<leader>dp", function()
        if vim.fn.filereadable("main.py") == 1 then
            dap.run(python_debug_project)
        else
            vim.notify("Launch project failed, main.py not found", vim.log.levels.WARN, { title = "Debug project" })
        end
    end, { desc = "Debug project" })
    vim.keymap.set("n", "<leader>df", function()
        if vim.fn.expand("%:e") == "py" then
            dap.run(python_debug_file)
        else
            vim.notify("Launch file failed, only support py files", vim.log.levels.WARN, { title = "Debug file" })
        end
    end, { desc = "Debug file" })

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
    vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='DapBreakpointRejectedLine', numhl=''})
    vim.fn.sign_define('DapLogPoint', {text='', texthl='DapLogPoint', linehl='DapLogPointLine', numhl=''})
    vim.fn.sign_define('DapStopped', {text='➜', texthl='DapStopped', linehl='DapStoppedLine', numhl=''})

    vim.api.nvim_create_user_command("CloseDapUI", function()
        local layouts = require("dapui.windows").layouts
        if layouts[1]:is_open() then
            vim.cmd.ToggleDapUI(1)
        end
        if layouts[2]:is_open() then
            vim.cmd.ToggleDapUI(2)
        end
    end, {})

    vim.api.nvim_create_user_command("ToggleDapUI", function(layout_num)
        local nvim_tree = require("nvim-tree.api").tree
        local dapui_windows = require("dapui.windows")

        vim.cmd.OverseerClose()
        dapui.toggle({ layout = tonumber(layout_num.fargs[1]), reset = true })

        local dapui_side_layout = dapui_windows.layouts[1]
        local dapui_bottom_layout = dapui_windows.layouts[2]
        local nvim_tree_exists = nvim_tree.is_visible()

        if dapui_side_layout:is_open() then
            if nvim_tree_exists then
                nvim_tree.close()
            end
        elseif not nvim_tree_exists and vim.fn.winwidth(0) >= 130 then
            nvim_tree.toggle({ focus = false })
            if dapui_bottom_layout:is_open() then
                dapui_bottom_layout:resize()
            end
        end
    end, { nargs = '?' })

    local keymaps = {
        { mode = "n", key = "<C-M-d>", func = vim.cmd.ToggleDapUI, desc = "Toggle DAP UI" },
        { mode = "n", key = "<F3>", func = dap.pause, desc = "DAP Pause" },
        { mode = "n", key = "<F4>", func = dap.continue, desc = "DAP Continue" },
        { mode = "n", key = "<F5>", func = dap.step_into, desc = "DAP Step Into" },
        { mode = "n", key = "<F6>", func = dap.step_over, desc = "DAP Step Over" },
        { mode = "n", key = "<F7>", func = dap.step_out, desc = "DAP Step Out" },
        { mode = "n", key = "<F8>", func = dap.terminate, desc = "DAP Terminate" },
        { mode = "n", key = "<leader>do", func = dap.continue, desc = "DAP Start" },
        { mode = "n", key = "<leader>dl", func = dap.run_last, desc = "DAP Run Last" },
        { mode = "v", key = "<M-k>", func = dapui.eval, desc = "DAP Eval" },
    }
    for _, keymap in ipairs(keymaps) do
        vim.keymap.set(keymap.mode, keymap.key, keymap.func, { desc = keymap.desc })
    end

    require("persistent-breakpoints").setup()
    require("dap-breakpoints").setup({
        breakpoint = {
            auto_load = true,
            auto_save = true,
        },
    })

    local dapbp_api = require("dap-breakpoints.api")
    local dapbp_keymaps = {
        { key = "<leader>b", api = dapbp_api.toggle_breakpoint, desc = "Toggle Breakpoint" },
        { key = "<leader>dtc", api = dapbp_api.set_conditional_breakpoint, desc = "Set Conditional Breakpoint" },
        { key = "<leader>dth", api = dapbp_api.set_hit_condition_breakpoint, desc = "Set Hit Condition Breakpoint" },
        { key = "<leader>dtl", api = dapbp_api.set_log_point, desc = "Set Log Point" },
        { key = "<leader>dtL", api = function() dapbp_api.load_breakpoints({ notify = true }) end, desc = "Load Breakpoints" },
        { key = "<leader>dts", api = function() dapbp_api.save_breakpoints({ notify = true }) end, desc = "Save Breakpoints" },
        { key = "<leader>dte", api = dapbp_api.edit_property, desc = "Edit Breakpoint Property" },
        { key = "<leader>dtv", api = dapbp_api.toggle_virtual_text, desc = "Toggle Breakpoint Virtual Text" },
        { key = "<leader>dtC", api = dapbp_api.clear_all_breakpoints, desc = "Clear All Breakpoints" },
        { key = "[b", api = dapbp_api.go_to_previous, desc = "Go to Previous Breakpoint" },
        { key = "]b", api = dapbp_api.go_to_next, desc = "Go to Next Breakpoint" },
        { key = "<F9>", api = dapbp_api.go_to_previous, desc = "Go to Previous Breakpoint" },
        { key = "<F10>", api = dapbp_api.go_to_next, desc = "Go to Next Breakpoint" },
        { key = "<M-b>", api = dapbp_api.popup_reveal, desc = "Reveal Breakpoint" },
    }
    for _, keymap in ipairs(dapbp_keymaps) do
        vim.keymap.set("n", keymap.key, keymap.api, { desc = keymap.desc })
    end
EOF
endif

" === markdown.nvim ===
if has("nvim")
    lua << EOF
    require("render-markdown").setup({
        code = {
            position = "right",
            width = "block",
            inline_pad = 1,
        },
        render_modes = { 'n', 'c', 'i', 'v', 'V', '' },
    })
EOF
endif

" === nvim-rip-substitute ===
if has("nvim")
    lua << EOF
    require("rip-substitute").setup({
        keymaps = {
            insertModeConfirm = "<C-s>",
        },
    })
    local function quit_rip_substitute()
        vim.cmd.quit()
        if vim.api.nvim_get_mode().mode == "i" then
            vim.cmd.stopinsert()
            vim.cmd.normal("l")
        end
    end
    vim.keymap.set({ "n", "v" }, "R", require("rip-substitute").sub, { desc = " Rip Substitute" })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rip-substitute",
        callback = function()
            vim.keymap.set({ "n", "i" }, "<C-c>", quit_rip_substitute, { buffer = true, desc = "Close Rip Substitute" })
            vim.keymap.set({ "n", "i" }, "<esc>", quit_rip_substitute, { buffer = true, desc = "Close Rip Substitute" })
        end
    })
EOF
endif

" === quicker.nvim ===
if has("nvim")
    lua << EOF
    require("quicker").setup({
        keys = {
            { ">", "<cmd>lua require('quicker').toggle_expand()<CR>", desc = "Expand quickfix content" },
        },
        edit = {
            enabled = false,
        },
        highlight = {
            load_buffers = false,
        },
    })
    vim.keymap.set("n", "<C-q>", require("quicker").toggle, { desc = "Toggle Quicker" })
EOF
endif

" === table-nvim ===
if has("nvim")
    lua << EOF
    require("table-nvim").setup({
        padd_column_separators = true,
        mappings = {
            next = '<TAB>',
            prev = '<S-TAB>',
            insert_row_up = '<C-M-k>',
            insert_row_down = '<C-M-j>',
            insert_column_left = '<C-M-h>',
            insert_column_right = '<C-M-l>',
            move_row_up = '<M-K>',
            move_row_down = '<M-J>',
            move_column_left = '<M-G>',
            move_column_right = '<M-:>',
            insert_table = '<C-M-t>',
            insert_table_alt = '<M-T>',
            delete_column = '<C-M-c>',
        }
    })
EOF
endif

" === venv-selector.nvim ===
if has("nvim")
    lua << EOF
    local function has_dir(path)
        local stat = vim.uv.fs_stat(path)
        return stat and stat.type == 'directory'
    end
    local function get_searches()
        local default_searches = {
            cwd = {
                command = "$FD '/bin/python$' $CWD --full-path --color never -HI -a -L"..
                    " -E /proc -E .git/ -E .wine/ -E .steam/ -E Steam/ -E site-packages/",
            },
            file = {
                command = "$FD '/bin/python$' $FILE_DIR --full-path --color never -E /proc -HI -a -L",
            },
            pipx = {
                command = "$FD '/bin/python$' ~/.local/share/pipx/venvs ~/.local/pipx/venvs --full-path --color never",
            },
            venv = {
                command = "$FD 'venv/bin/python$' ~ --full-path --color never -HI -a -L -E mason",
            },
        }
        local systems = {
            ["Linux"] = function()
                local conda_path = vim.fn.expand("~/dev/miniconda3")
                return vim.tbl_deep_extend("force", default_searches, {
                    miniconda_env = {
                        command = "$FD 'bin/python$' "..conda_path.."/envs --full-path --color never",
                        type = "anaconda",
                    },
                    miniconda_base = {
                        command = "$FD '/python$' "..conda_path.."/bin --full-path --color never",
                        type = "anaconda",
                    },
                })
            end,
            ["Windows_NT"] = function()
                local dirs = { "D:/dev/scoop/apps/miniconda3/current", "D:/dev/miniconda3" }
                local conda_path = "D:/"
                for _, dir in ipairs(dirs) do
                    if has_dir(dir) then
                        conda_path = dir
                        break
                    end
                end
                return vim.tbl_deep_extend("force", default_searches, {
                    cwd = {
                        command = "$FD Scripts//python.exe$ $CWD --full-path --color never -HI -a -L",
                    },
                    file = {
                        command = "$FD Scripts//python.exe$ $FILE_DIR --full-path --color never -HI -a -L",
                    },
                    miniconda_env = {
                        command = "$FD //python.exe$ "..conda_path.."/envs --full-path --color never -a -E Lib",
                        type = "anaconda",
                    },
                    miniconda_base = {
                        command = "$FD //python.exe$ "..conda_path.." --full-path -a --color never -E pkgs -E Lib -E envs",
                        type = "anaconda",
                    },
                    pipx = {
                        command = "$FD Scripts//python.exe$ $PIPX_HOME/venvs --full-path -a --color never",
                    },
                    venv = {
                        command = "$FD venv//Scripts//python.exe$ D:/ --full-path --color never -HI -a -L",
                    },
                })
            end,
        }
        local name = vim.loop.os_uname().sysname
        return systems[name] or systems["Linux"]
    end
    require("venv-selector").setup({ settings = {
        cache = {
            file = vim.fn.stdpath("data").."/venv-selector/venvs2.json",
        },
        options = {
            cached_venv_automatic_activation = false,
            enable_default_searches = true,
            require_lsp_activation = false,
            search_timeout = 10,
            on_venv_activate_callback = function()
                local timer = vim.uv.new_timer()
                timer:start(200, 0, vim.schedule_wrap(function()
                    timer:stop()
                    timer:close()
                    vim.cmd.CocRestart()
                    vim.api.nvim_echo({}, false, {})
                end))
            end,
        },
        search = get_searches()(),
    }})
    vim.keymap.set("n", "<leader>vs", vim.cmd.VenvSelect, { desc = "Select python venv" })
    vim.keymap.set("n", "<leader>vv", vim.cmd.VenvSelectCached, { desc = "Activate cached venv in cwd" })
EOF
endif

" === yazi.nvim ===
if has("nvim")
    lua << EOF
    local yazi = require("yazi")
    vim.keymap.set("n", "<m-y>", yazi.yazi, { desc = "Open yazi" })
EOF
endif

" === leetcode.nvim ===
if has("nvim")
    lua << EOF
    require("leetcode").setup({
        lang = "python3",
        plugins = {
            non_standalone = true,
        },
    })
    local keymaps = {
        { mode = "n", key = "<leader>lD", cmd = "Leet daily", desc = "LeetCode Daily Problem" },
        { mode = "n", key = "<leader>lL", cmd = "Leet last_submit", desc = "LeetCode Restore Last Submit" },
        { mode = "n", key = "<leader>lR", cmd = "Leet random", desc = "LeetCode Random Problem" },
        { mode = "n", key = "<leader>lc", cmd = "Leet console", desc = "LeetCode Console" },
        { mode = "n", key = "<leader>ld", cmd = "Leet desc", desc = "LeetCode Toggle Description" },
        { mode = "n", key = "<leader>lh", cmd = "Leet hints", desc = "LeetCode Hints" },
        { mode = "n", key = "<leader>li", cmd = "Leet info", desc = "LeetCode Problem Info" },
        { mode = "n", key = "<leader>ll", cmd = "Leet list", desc = "LeetCode Problem List" },
        { mode = "n", key = "<leader>lm", cmd = "Leet", desc = "LeetCode Menu" },
        { mode = "n", key = "<leader>lo", cmd = "Leet open", desc = "LeetCode Open In Browser" },
        { mode = "n", key = "<leader>lr", cmd = "Leet run", desc = "LeetCode Run" },
        { mode = "n", key = "<leader>ls", cmd = "Leet submit", desc = "LeetCode Submit" },
        { mode = "n", key = "<leader>lt", cmd = "Leet tabs", desc = "LeetCode Choose Tabs" },
        { mode = "n", key = "<leader>ly", cmd = "Leet yank", desc = "LeetCode Yank" },
        { mode = "n", key = "<leader>lq", func = require("leetcode").stop, desc = "LeetCode Quit" },
    }
    for _, keymap in ipairs(keymaps) do
        local func
        if keymap.cmd then
            func = function() vim.cmd(keymap.cmd) end
        else
            func = keymap.func
        end
        vim.keymap.set(keymap.mode, keymap.key, func, { desc = keymap.desc })
    end
EOF
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

nnoremap <M-s> <cmd>w<CR>
nnoremap <M-S> <cmd>wall<CR>
nnoremap <M-w> <cmd>q<CR>
nnoremap <M-W> <cmd>q!<CR>
nnoremap <M-q> <cmd>qall<CR>

function EditVimrc(way)
    if has("win32")
        if a:way == "normal"
            edit ~\_vimrc
        elseif a:way == "vs"
            vsplit ~\_vimrc
        endif
    else
        if a:way == "normal"
            edit ~/.vimrc
        elseif a:way == "vs"
            vsplit ~/.vimrc
        endif
    endif
endfunction

nnoremap <leader>sf <cmd>w<CR><cmd>source $MYVIMRC<CR>
if has("nvim")
    nnoremap <leader>ev <cmd>e $MYVIMRC<CR>
endif
nnoremap <leader>ef <cmd>call EditVimrc("normal")<CR>
nnoremap <leader>er <cmd>call EditVimrc("vs")<CR>

nnoremap <leader>ww <cmd>w<CR>
nnoremap <leader>q <cmd>q<CR>
nnoremap <leader>wq <cmd>wq<CR>
nnoremap <leader>fq <cmd>q!<CR>
nnoremap <leader>rq <cmd>qa<CR>
nnoremap <leader>ewq <cmd>wqa<CR>
nnoremap <leader><leader>r <cmd>redraw!<CR>
nnoremap <leader>i <cmd>Inspect<CR>

nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M--> <C-w>_
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
nnoremap <leader>sh <C-w>s
nnoremap <leader>sv <C-w>v

nnoremap <M-[> <cmd>tabp<CR>
nnoremap <M-]> <cmd>tabn<CR>
nnoremap <M-n> <cmd>tabnew<CR>
nnoremap <M-C> <cmd>tabc<CR>

noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>P "+P
inoremap <C-S-V> <C-R>+

nmap <C-J> ]c
nmap <C-K> [c
nnoremap <C-H> 10zh
nnoremap <C-L> 10zl
inoremap <C-J> <esc>o
inoremap <C-K> <esc>O
inoremap <C-H> <esc>I
inoremap <C-L> <esc>A
inoremap <M-j> <C-down>
inoremap <M-k> <C-up>
inoremap <M-h> <C-left>
inoremap <M-J> <C-down>
inoremap <M-K> <C-up>
inoremap <M-H> <C-left>
inoremap <M-L> <C-right>

nnoremap DO <cmd>%diffget<CR>
nnoremap DP <cmd>%diffput<CR>
nnoremap DU <cmd>diffupdate<CR>

for mapping in ['jj', 'jk', 'kj', 'kk', 'jl', 'jh']
    execute 'inoremap '.mapping.' <esc>'
    execute 'cnoremap '.mapping.' <C-c>'
endfor

nnoremap <C-Up> <cmd>resize -2<CR>
nnoremap <C-Down> <cmd>resize +2<CR>
nnoremap <C-Left> <cmd>vertical resize -2<CR>
nnoremap <C-Right> <cmd>vertical resize +2<CR>

let g:load_doxygen_syntax=1

" comment before duplicate a line
nmap DC yypkgccj
nmap DR ddkgcc

" navigate in quickfix list
nnoremap <M-N> <cmd>cnext<CR>
nnoremap <M-P> <cmd>cprev<CR>

if ! has("nvim")
    nnoremap <leader>c <cmd>bd<CR>
    nnoremap H <cmd>bp<CR>
    nnoremap L <cmd>bn<CR>
    nmap s <M-s>
    nmap S <M-S>
    nmap w <M-w>
    nmap q <M-q>
    nmap h <M-h>
    nmap j <M-j>
    nmap k <M-k>
    nmap l <M-l>
    nmap - <M-->
    nmap n <M-n>
    nmap C <M-C>
    nmap N <M-N>
    nmap P <M-P>
endif

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
autocmd VimEnter * clearjumps

" auto switch mode for terminal
if has("nvim")
    autocmd TermOpen term://* let g:terminal_running = v:true | set filetype=terminal
    autocmd WinEnter term://* if g:terminal_running | startinsert
    autocmd TermClose term://* let g:terminal_running = v:false | stopinsert
endif

" remove trailing ^M
command -nargs=0 FixEOL %s/\r$//


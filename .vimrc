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
Plug 'gcmt/wildfire.vim'    " <cr> select in brackets
Plug 'lambdalisue/suda.vim' " save file by sudo

if has("nvim")
    Plug 'carcuis/darcula.nvim'
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
    Plug 'CRAG666/code_runner.nvim'
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
    Plug 'kevinhwang91/nvim-hlslens'
    Plug 'NMAC427/guess-indent.nvim'    " indentation-detection
    Plug 'lukas-reineke/virt-column.nvim'
    Plug 'ggandor/leap.nvim'
    Plug 'fannheyward/telescope-coc.nvim'
else
    Plug 'carcuis/darcula'
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

if has("nvim")
    set fillchars=eob:\ ,diff:\ 
    if has("win32") || (system('uname -a') =~ "Microsoft")
        set guifont=CaskaydiaCove\ NFM:h13
    elseif has("linux")
        set guifont=UbuntuMono\ NF:h16
    elseif has("mac")
        set guifont=UbuntuMono\ Nerd\ Font\ Mono:h20
    endif
    set mousemoveevent
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
    let airline#extensions#coc#error_symbol = ':'
    let airline#extensions#coc#warning_symbol = ':'
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
    let g:NERDTreeDirArrowExpandable = ''
    let g:NERDTreeDirArrowCollapsible = ''

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
    let g:tagbar_iconchars = ['', '']
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
    \ {'l': ['  Load Session', 'call LoadSession("")']},
    \ ]
if ! has("nvim")
    let g:startify_commands += [
    \ {'f': ['  Find File', 'Leaderf file']},
    \ {'r': ['  Recently Used Files', 'Leaderf mru']},
    \ {'w': ['  Find Word', 'Leaderf rg']},
    \ {'e': ['  Nerd-Tree', 'NERDTree']},
    \ ]
else
    let g:startify_commands += [
    \ {'f': ['  Find File', 'Telescope find_files']},
    \ {'p': ['  Recent Projects', 'Telescope projects']},
    \ {'r': ['  Recently Used Files', 'Telescope oldfiles']},
    \ {'w': ['  Find Word', 'Telescope live_grep']},
    \ {'e': ['  Nvim-Tree', 'NvimTreeOpen']},
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
        TSContextToggle
    else
        NERDTreeClose
    endif
endfunction
function PostSaveSession()
    if has("nvim")
        if (winwidth(0) >= 130) && argc() < 2
            call OpenNvimTreeOnStartup()
        endif
        call timer_start(1, { tid -> execute('TSContextToggle')})
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
nnoremap <silent> <leader>ss :call SaveSession("")<CR>
nnoremap <silent> <leader>sl :call LoadSession("")<CR>

" === coc.nvim ===
if has("nvim")
    let g:coc_global_extensions = [
                \ 'coc-json', 'coc-vimlsp', 'coc-marketplace', 'coc-markdownlint',
                \ 'coc-pyright', 'coc-powershell', 'coc-sh', 'coc-clangd',
                \ 'coc-cmake', 'coc-actions', 'coc-translator', 'coc-snippets',
                \ 'coc-sumneko-lua', 'coc-tsserver', 'coc-eslint', 'coc-nav',
                \ 'coc-xml' ]
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

    " see fannheyward/telescope-coc.nvim
    nmap <silent> gd :Telescope coc definitions<CR>
    nmap <silent> gh :Telescope coc declarations<CR>
    nmap <silent> gt :Telescope coc type-definitions<CR>
    nmap <silent> ge :Telescope coc implementations<CR>
    nmap <silent> gr :Telescope coc references<CR>

    nmap <silent> gp :call CocActionAsync('jumpDefinition', v:false)<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    nmap <leader>rn <Plug>(coc-rename)
    nmap <silent><leader>Rn :CocCommand document.renameCurrentWord<CR>
    nmap <S-F5> <Plug>(coc-rename)
    nmap <leader>rf <Plug>(coc-refactor)
    nmap <leader>lo <Plug>(coc-openlink)
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)w
    nmap <M-f>  <Plug>(coc-fix-current)
    map <silent> <M-e> :call CocActionAsync('doHover')<CR>
    nmap <Leader>tr <Plug>(coc-translator-p)
    vmap <Leader>tr <Plug>(coc-translator-pv)
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

    nnoremap <silent> <M-d> :CocCommand semanticTokens.inspect<CR>
    let g:coc_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']

    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
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
    nnoremap <leader>fs :lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji', 'math', 'latex'} }<CR>
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
            \]

" === bufferline.nvim ===
if has("nvim")
    nnoremap <silent> gb :BufferLinePick<CR>
    lua << EOF
    require("bufferline").setup{
        options = {
            middle_mouse_command = function(bufnum)
                require('bufdelete').bufdelete(bufnum)
            end,
            close_command = function(bufnum)
                require('bufdelete').bufdelete(bufnum)
            end,
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
            },
            hover = {
                enabled = true,
                delay = 50,
                reveal = {'close'}
            },
            diagnostics = "coc",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
            end
        }
    }
EOF
endif

" === nvim-tree.lua ===
if has("nvim")
    noremap <leader>ee :NvimTreeToggle<CR>

    func OpenNvimTreeOnStartup()
        NvimTreeToggle
        call timer_start(1, { tid -> execute('wincmd p')})
    endfunc

    if (winwidth(0) < 130)
        let g:s_nvim_tree_quit_on_open = v:true
    endif
    if (winwidth(0) >= 130) && argc() < 2
        au VimEnter * call OpenNvimTreeOnStartup()
    endif

    autocmd BufEnter * ++nested
            \ if len(filter(nvim_list_wins(), {k,v->nvim_win_get_config(v).relative==""})) == 1
            \ && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

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
        update_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable      = true,
            update_cwd  = false,
        },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        git = {
            ignore = false,
        },
        actions = {
            open_file = {
                quit_on_open = vim.g.s_nvim_tree_quit_on_open,
            },
        },
        renderer = {
            highlight_git = true,
            root_folder_modifier = ":t",
            icons = {
                git_placement = "after",
                glyphs = {
                    git = {
                        unstaged = "",
                        staged = "",
                    },
                },
            },
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
        shading_factor = 1,
        float_opts = {
            border = 'curved',
            winblend = 10,
            highlights = {
                border = "FloatBorder",
            }
        },
    }

    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

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
            "c:", "d:", "e:", "~", "/", "*//*"
        },
    }
    require('telescope').load_extension('projects')
EOF
endif

" === nvim-colorizer.lua ===
if has("nvim")
    lua require'colorizer'.setup()
endif

" === code_runner.nvim ===
if has("nvim")
    nnoremap <leader>ru :RunFile<CR>
    nnoremap <leader>rp :RunProject<CR>
    lua << EOF
    require('code_runner').setup {
        mode = "toggleterm",
        before_run_filetype = function()
            vim.cmd(":wa")
        end,
        filetype = {
            java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
            python = "python",
            typescript = "deno run",
            rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
            cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt.exe && $dir/$fileNameWithoutExt.exe",
            c = "cd $dir && gcc $fileName -o $fileNameWithoutExt.exe && $dir/$fileNameWithoutExt.exe",
            sh = "bash",
            zsh = "zsh",
            go = "go run $fileName",
            ps1 = "pwsh -NoProfile -File $fileName",
        },
        project_path = vim.fn.stdpath("config") .. "/project_manager.json"
    }
EOF
endif

" === nvim-treesitter ===
if has("nvim")
    lua << EOF
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "python", "c", "cpp", "lua", "bash", "vim", "go", "javascript", "typescript", "make"
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
        context_commentstring = {
            enable = true
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
                sections = { lualine_b = {'filetype'} },
                filetypes = {'DiffviewFiles'},
            },
        },
        options = {
            section_separators = { left = '', right = '' },
            -- component_separators = { left = '❘', right = '❘' }
            component_separators = { left = '', right = '' }
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
                            return ''
                        end
                        return ''
                    end,
                    color = { fg = "Red" },
                    padding = { left = 0, right = 1 },
                },
                {
                    'diff',
                    diff_color = {
                        added = 'LualineGitAdd',
                        modified = 'LualineGitChange',
                        removed = 'LualineGitDelete',
                    },
                    symbols = { added = ' ', modified = ' ', removed = ' ' },
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
                                t[#t+1] = '%#' .. highlight .. '#' .. v.label .. ' %#Normal#'.. name
                            else
                                t[#t+1] = '%#' .. highlight .. '#  %#Normal#' .. name
                            end
                            if next(items,k) ~= nil then
                                t[#t+1] = '%#Normal# '
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
                        error = 'CocErrorSign',
                        warn  = 'CocWarningSign',
                        info  = 'CocInfoSign',
                        hint  = 'CocHintSign',
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
            group = "",
        },
    }
EOF
endif

" === indent-blankline.nvim ===
if has("nvim")
    let g:indent_blankline_filetype_exclude = ['checkhealth', 'help', '', 'startify', 'vim-plug', 'toggleterm']
    let g:indent_blankline_show_first_indent_level = v:false
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    lua << EOF
    require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = false,
    }
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
                chunks = {{' ', 'Ignore'}, {text, 'HlSearchLensNear'}}
            else
                text = ('[%s %d]'):format(indicator, idx)
                chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
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
    }
EOF
endif

" === gitsigns.nvim ===
if has("nvim")
    lua << EOF
    require('gitsigns').setup {
        signs = {
            add          = {hl = 'GitSignsAdd'   , text = '█', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
            change       = {hl = 'GitSignsChange', text = '█', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
            delete       = {hl = 'GitSignsDelete', text = '▶', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            topdelete    = {hl = 'GitSignsDelete', text = '▶', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text = '█', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
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
            map('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
            map('v', '<leader>gs', ':Gitsigns stage_hunk<CR>')
            map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
            map('v', '<leader>gr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>')
            map('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
            map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
            map('n', '<leader>gb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
            map('n', '<leader>gd', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
            map('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
            map('n', '<leader>gtd', '<cmd>Gitsigns toggle_deleted<CR>')
            map('n', '<leader>gtl', '<cmd>Gitsigns toggle_linehl<CR>')
            map('n', '<leader>gtn', '<cmd>Gitsigns toggle_numhl<CR>')
            map('n', '<leader>gtw', '<cmd>Gitsigns toggle_word_diff<CR>')
            map('n', '<leader>gts', '<cmd>Gitsigns toggle_signs<CR>')

            -- Text object
            map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
EOF
endif

" === diffview.nvim ===
if has("nvim")
    nnoremap <silent> <leader>gD :DiffviewOpen<CR>
    lua <<EOF
    -- local cb = require'diffview.config'.diffview_callback
    require('diffview').setup {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        file_panel = {
            win_config = {
                width = 30,
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
        char = "│"
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

" ===============

" ==================
" ===  mappings  ===
" ==================
"
nmap <C-n> *
nmap <C-p> #

nnoremap <M-s> :w<CR>
nnoremap <M-w> :q<CR>
nnoremap <M-q> :q!<CR>

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

nnoremap <leader>sf :w<CR>:source $MYVIMRC<CR>
if has("nvim")
    nnoremap <leader>ev :e $MYVIMRC<CR>
endif
nnoremap <leader>ef :call EditVimrc("normal")<CR>
nnoremap <leader>er :call EditVimrc("vs")<CR>

nnoremap <leader>ww :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>fq :q!<CR>
nnoremap <leader>rq :qa<CR>
nnoremap <leader>ewq :wqa<CR>
nnoremap <leader>gq :call SaveSession("")<CR>:qa<CR>
nnoremap <leader>du :diffupdate<CR>
nnoremap <leader><leader>r :redraw!<CR>

nnoremap <silent> <M-h> <C-w>h
nnoremap <silent> <M-j> <C-w>j
nnoremap <silent> <M-k> <C-w>k
nnoremap <silent> <M-l> <C-w>l
nnoremap <silent> <M--> <C-w>_
tnoremap <silent> <M-h> <C-\><C-N><C-w>h
tnoremap <silent> <M-j> <C-\><C-N><C-w>j
tnoremap <silent> <M-k> <C-\><C-N><C-w>k
tnoremap <silent> <M-l> <C-\><C-N><C-w>l
nnoremap <silent> <leader>sp <C-w>s
nnoremap <silent> <leader>vs <C-w>v

nnoremap <silent> <leader>tp :tabp<CR>
nnoremap <silent> <leader>tn :tabn<CR>
nnoremap <silent> <leader>tq :tabc<CR>
if ! has("nvim")
    nnoremap <leader>c :bd<CR>
endif
nnoremap <silent> H :bp<CR>
nnoremap <silent> L :bn<CR>

noremap <leader>y "+y
noremap <leader>p "+p

nmap <silent> <C-J> ]c
nmap <silent> <C-K> [c
inoremap <silent> <C-J> <esc>o
inoremap <silent> <C-K> <esc>O

" recurse do or dp in vimdiff
nmap <silent> <leader>do do]c<leader>do
nmap <silent> <leader>dp dp]c<leader>dp

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

nnoremap <silent> <C-H> 10zh
nnoremap <silent> <C-L> 10zl

let g:load_doxygen_syntax=1

if has("win32")
    au FileType cpp nnoremap <buffer> <leader>fj :w<CR>:!echo --------debugging--------
              \ && g++ % -o %:h\debug_%:t:r.exe && %:h\debug_%:t:r.exe<CR>
else
    au FileType cpp nnoremap <buffer> <leader>fj :w<CR>:!echo -e "\n--------debugging--------"
              \ && g++ % -o %:h/debug_%:t:r.out && %:h/debug_%:t:r.out &&<CR>
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

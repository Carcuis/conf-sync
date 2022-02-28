" ======================================================
"   _____                  _             _
"  / ___/__ ___________ __(_)__    _  __(_)_ _  ________
" / /__/ _ `/ __/ __/ // / (_-<  _| |/ / /  ' \/ __/ __/
" \___/\_,_/_/  \__/\_,_/_/___/ (_)___/_/_/_/_/_/  \__/
"
" ======================================================

" =================
" ===  plugins  ===
" =================
"
call plug#begin()

Plug 'carcuis/darcula'
Plug 'joshdick/onedark.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'vimcn/vimcdoc'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'pprovost/vim-ps1'
Plug 'romainl/vim-cool'
Plug 'luochen1990/rainbow'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'vifm/vifm.vim'
Plug 'liuchengxu/vista.vim'
Plug 'dstein64/vim-startuptime'
Plug 'gcmt/wildfire.vim'
Plug 'lambdalisue/suda.vim'

if has("nvim")
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
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
    Plug 'tversteeg/registers.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'rafamadriz/neon'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'folke/tokyonight.nvim'
    Plug 'folke/which-key.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'SmiteshP/nvim-gps'
    Plug 'shaunsingh/moonlight.nvim'
    Plug 'petertriho/nvim-scrollbar'
    Plug 'gelguy/wilder.nvim'
else
    Plug 'vim-airline/vim-airline'
    Plug 'Yggdroot/indentLine'
    Plug 'liuchengxu/vim-which-key'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
    Plug 'vim/killersheep'
endif

call plug#end()

" ===============

" ========================
" ===  basic settings  ===
" ========================
"
color darcula
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
set conceallevel=2

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
        set backspace=indent,eol,start
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
        set backspace=indent,eol,start
        set nocursorline
    elseif has("linux")
        " let &t_TI=""
        " let &t_TE=""
    endif
endif

if has("nvim")
    hi NonText guifg=#3C3F41
else
    hi NonText guifg=bg
endif

" ===============

" =========================
" ===  plugin settings  ===
" =========================
"

" === darcula ===
" hi! link GitGutterAdd GitAddStripe
" hi! link GitGutterChange GitChangeStripe
" hi! link GitGutterDelete GitDeleteStripe
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
" call darcula#Hi('Comment', [ '#629755', 255 ], darcula#palette.null, 'italic')
hi VertSplit guibg=#313335 guifg=#313335

" === tokyonight.nvim ===
if has("nvim")
    lua << EOF
    vim.g.tokyonight_style = "storm"
EOF
    " color tokyonight
endif

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
" let g:NERDTreeGitStatusShowClean = 1

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
    map <leader>fr :LeaderfMru<CR>
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
let g:rainbow_active = 0

" === tagbar ===
map <leader>tb :TagbarToggle<CR>
let g:tagbar_width = min([max([25, winwidth(0) / 5]), 30])
" if (winwidth(0) > 100 || has("gui_running")) && argc() < 2
"   " autocmd VimEnter * nested :TagbarOpen
"   " autocmd BufEnter * nested :call tagbar#autoopen(0)
"   autocmd FileType * nested :call tagbar#autoopen(0)
" endif
let g:tagbar_iconchars = ['', '']

" === vim-startify ===
if argc() == 0
    au VimEnter * :Startify
endif
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
    \ {'U': ['  Plug Update', 'PlugUpdate']},
    \ ]
if has("nvim")
    let g:startify_commands += [
    \ {'f': ['  Find File', 'Telescope find_files']},
    \ {'p': ['  Recent Projects', 'Telescope projects']},
    \ {'r': ['  Recently Used Files', 'Telescope oldfiles']},
    \ {'w': ['  Find Word', 'Telescope live_grep']},
    \ {'e': ['  Nvim-Tree', 'NvimTreeToggle']},
    \ {'C': ['  Configure CoC', 'CocConfig']},
    \ ]
endif
let g:startify_fortune_use_unicode = 1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" === coc.nvim ===
if has("nvim")
    let g:coc_global_extensions = [
                \ 'coc-json', 'coc-vimlsp', 'coc-marketplace', 'coc-markdownlint',
                \ 'coc-pyright', 'coc-powershell', 'coc-sh', 'coc-clangd',
                \ 'coc-cmake', 'coc-actions', 'coc-translator', 'coc-snippets',
                \ 'coc-lua']
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : "\<TAB>"
    inoremap <silent><expr> <c-e> coc#refresh()
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gp :call CocActionAsync('jumpDefinition', v:false)<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    nmap <leader>rn <Plug>(coc-rename)
    nmap <leader>rf <Plug>(coc-refactor)
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
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▶'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_removed_above_and_below = '_▔'
let g:gitgutter_sign_modified_removed = '▶'

" === telescope.nvim ===
if has("nvim")
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fp <cmd>Telescope projects<cr>
    lua << EOF
    require('telescope').setup{
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
        }
    }
EOF
endif

" === vim-trailing-whitespace ===
let g:extra_whitespace_ignored_filetypes = [
            \'TelescopePrompt',
            \'vim-plug'
            \]

" === bufferline.nvim ===
if has("nvim")
    nnoremap <silent> gb :BufferLinePick<CR>
    lua << EOF
    require("bufferline").setup{
        options = {
            middle_mouse_command = "bdelete",
            separator_style = "slant",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "Nvim Tree",
                }
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
    hi NvimTreeNormal guibg=#3C3F41
    noremap <leader>ee :NvimTreeToggle<CR>

    func OpenNvimTreeOnStartup()
        NvimTreeToggle
        call timer_start(1, { tid -> execute('wincmd p')})
    endfunc

    if (winwidth(0) < 130)
        let g:nvim_tree_quit_on_open = 1
    endif
    if (winwidth(0) >= 130) && argc() < 2
        au VimEnter * call OpenNvimTreeOnStartup()
    endif

    let g:nvim_tree_git_hl = 1
    let g:nvim_tree_respect_buf_cwd = 1
    let g:nvim_tree_icons = {
                \ 'git': {
                    \  'ignored': "-",
                    \  'unstaged': "",
                    \  'staged': "",
                    \},
                \ 'default': '',
                \ }

    lua << EOF
    require'nvim-tree'.setup {
        hijack_cursor = true,
        auto_close = true,
        update_focused_file = {
            enable      = true,
            update_cwd  = true,
        },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            }
        },
        git = {
            ignore = false
        },
    }
EOF
endif

" === FixCursorHold.nvim ===
if has("nvim")
    let g:cursorhold_updatetime = 50
endif

" === nvim-terminal.lua ===
if has("nvim")
    lua require'terminal'.setup()
endif

" === toggleterm.nvim ===
if has("nvim")
    lua << EOF
    require("toggleterm").setup {
        open_mapping = [[<c-t>]],
        direction = 'float',
        shade_terminals = true,
        shading_factor = 1,
        float_opts = {
            border = 'curved',
        },
    }
EOF
endif

" === project.nvim ===
if has("nvim")
    lua << EOF
    require("project_nvim").setup{}
    require('telescope').load_extension('projects')
EOF
endif

" === nvim-colorizer.lua ===
if has("nvim")
    lua require'colorizer'.setup()
endif

" === code_runner.nvim ===
if has("nvim")
    map <leader>ru :RunCode<CR>
    map <leader>rf :RunFile<CR>
    map <leader>rp :RunProject<CR>
    lua << EOF
    require('code_runner').setup {
        term = {
        	mode = "",
        	tab = false,
        	position = "belowright",
        	size = 8
        },
        filetype = {
            java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
            python = "python",
            typescript = "deno run",
            rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
            cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt.exe && $dir/$fileNameWithoutExt.exe",
            sh = "bash",
            zsh = "zsh"
        },
        project_path = vim.fn.stdpath("config") .. "/project_manager.json"
    }
EOF
endif

" === nvim-treesitter ===
if has("nvim")
    lua << EOF
    require'nvim-treesitter.configs'.setup {
        ensure_installed = {
            "python", "cpp", "lua", "bash"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
EOF
endif

" === lualine.nvim ===
if has("nvim")
    lua << EOF
    local gps = require("nvim-gps")
    require('lualine').setup {
        extensions = {
            'nvim-tree',
        },
        options = {
            section_separators = { left = '', right = '' },
            component_separators = { left = '❘', right = '❘' }
        },
        sections = {
            lualine_b = {
                'branch',
                {
                    'diff',
                    symbols = { added = ' ', modified = ' ', removed = ' ' },
                },
                'diagnostics',
            },
			lualine_c = {
                'filename',
				{ gps.get_location, cond = gps.is_available },
                'g:coc_status',
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
            registers = false
        }
    }
EOF
endif

" === indent-blankline.nvim ===
if has("nvim")
    let g:indent_blankline_filetype_exclude = ['checkhealth', 'help', '', 'startify', 'vim-plug']
    let g:indent_blankline_show_first_indent_level = v:false
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    lua << EOF
    require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = false,
    }
EOF
endif

" === nvim-gps ===
if has("nvim")
    lua << EOF
    require("nvim-gps").setup {
        separator = ' 〉',
    }
EOF
endif

" === nvim-scrollbar ===
if has("nvim")
    lua << EOF
    require("scrollbar").setup {
        handle = {
            color = '#565656',
        },
    }
EOF
endif

" === wilder.nvim ===
if has("nvim")
    call wilder#setup({
          \ 'modes': [':', '/', '?'],
          \ 'next_key': '<Tab>',
          \ 'previous_key': '<S-Tab>',
          \ 'accept_key': '<Down>',
          \ 'reject_key': '<Up>',
          \ })
    call wilder#set_option('renderer', wilder#popupmenu_renderer({
          \ 'pumblend': 20,
          \ 'highlighter': wilder#basic_highlighter(),
          \ 'highlights': {
          \   'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#cc7832'}]),
          \ },
          \ 'left': [
          \   ' ', wilder#popupmenu_devicons(),
          \ ],
          \ 'right': [
          \   ' ', wilder#popupmenu_scrollbar(),
          \ ],
          \ }))
endif

" ===============

" ==================
" ===  mappings  ===
" ==================
"
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
map <M--> <C-w>_
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
map <leader>sp <C-w>s
map <leader>vs <C-w>v

map <leader>tp :tabp<CR>
map <leader>tn :tabn<CR>
map <leader>c :bd<CR>
map H :bp<CR>
map L :bn<CR>

map <leader>y "+y
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
    au FileType cpp map <buffer> <leader>fj :w<CR>:!echo --------debugging--------
              \ && g++ % -o %:h\debug_%:t:r.exe && %:h\debug_%:t:r.exe<CR>
else
    au FileType cpp map <buffer> <leader>fj :w<CR>:!echo -e "\n--------debugging--------"
              \ && g++ % -o %:h/debug_%:t:r.out && %:h/debug_%:t:r.out &&<CR>
endif

" ===============

" ==============
" ===  misc  ===
" ==============
"

" auto change cursor shape
if !(has("gui_running") || has("nvim"))
    let &t_SI.="\e[5 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[1 q"
endif

" let Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

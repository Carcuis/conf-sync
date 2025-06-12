-- =============================================================================================
--   _____                  _                             __               _         __
--  / ___/__ ___________ __(_)__    _  _____ _______  ___/ /__   ___ _  __(_)_ _    / /_ _____ _
-- / /__/ _ `/ __/ __/ // / (_-<   | |/ (_-</ __/ _ \/ _  / -_) / _ \ |/ / /  ' \_ / / // / _ `/
-- \___/\_,_/_/  \__/\_,_/_/___/   |___/___/\__/\___/\_,_/\__(_)_//_/___/_/_/_/_(_)_/\_,_/\_,_/
--
-- =============================================================================================

local M = {
    has_vscode = vim.g.vscode == 1,
    not_vscode = vim.g.vscode == nil,
    autogroup = vim.api.nvim_create_augroup("user_group", { clear = true }),
    this_file_path = debug.getinfo(1).source:sub(2),
}

---@class vscode
---@field action fun(name: string, opts?: table)
---@field call fun(name: string, opts?: table, timeout?: number): any
---@field on fun(event: string, callback: function)
---@field has_config fun(name: string|string[]): boolean|boolean[]
---@field get_config fun(name: string|string[]): any|any[]
---@field update_config fun(name: string|string[], value: any|any[], target?: "global"|"workspace")
---@field notify fun(msg: string, level?: number)
---@field eval fun(code: string, opts?: table, timeout?: number): any
---@field eval_async fun(code: string, opts?: table): any
---@field with_insert fun(callback: function)
M.vscode = M.has_vscode and require("vscode") or nil

function M.set_options()
    vim.o.conceallevel = 1
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.g.mapleader = " "

    if M.not_vscode then
        vim.o.number = true
        vim.o.relativenumber = true
        vim.o.cursorline = true
        vim.o.confirm = true
        vim.o.expandtab = true
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4
        vim.o.guicursor = vim.o.guicursor .. ",n:blinkwait200-blinkon600-blinkoff500"
        vim.o.winblend = 10
        vim.o.pumblend = 10
        vim.o.pumheight = 15
        vim.o.jumpoptions = "stack"
        vim.o.scrolloff = 5
        vim.o.sidescrolloff = 10
    end
end

function M.check_appname_ok()
    local data_path = vim.fn.stdpath("data")
    return type(data_path) == "string" and (
        data_path:match("[/\\]vscnvim%-data$") or
        data_path:match("/vscnvim$")
    )
end

function M.setup_lazy_nvim()
    if not M.check_appname_ok() then
        vim.notify("warning: `NVIM_APPNAME` is not equal to `vscnvim`, skip loading lazy.nvim", vim.log.levels.WARN)
        return
    end

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    ---@diagnostic disable-next-line: undefined-field
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        if M.has_vscode then
            vim.notify("vscode nvim: Lazy.nvim not installed, please run `vscnvim` in terminal", vim.log.levels.WARN)
            return
        end

        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)

    M.load_plugins()
end

function M.load_plugins()
    require("lazy").setup({
        {
            "Mofiqul/vscode.nvim",
            cond = M.not_vscode,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("vscode")
            end,
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            cond = M.not_vscode,
            event = "VeryLazy",
            opts = {
                options = {
                    disabled_filetypes = { statusline = { "dashboard" } },
                },
            },
        },
        {
            'akinsho/bufferline.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            cond = M.not_vscode,
            opts = {
            },
        },
        {
            'ggandor/leap.nvim',
            event = "VeryLazy",
            keys = {
                { 'f', '<Plug>(leap-forward-to)', mode = { 'n', 'x', 'o' }, desc = "Leap Forward to" },
                { 'F', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = "Leap Backward to" },
            },
            opts = {
                safe_labels = 'fnut/FNLHMUGTZ?',
                labels = 'fnjklhodweimbuyvrgtaqpcxz/FNJKLHODWEIMBUYVRGTAQPCXZ?'
            },
            config = function(_, opts)
                local leap = require("leap")
                for k, v in pairs(opts) do
                    leap.opts[k] = v
                end
            end,
        },
        {
            "kylechui/nvim-surround",
            event = "VeryLazy",
            opts = {
                surrounds = {
                    ["b"] = {
                        add = { "**", "**" },
                        find = "%*%*.-%*%*",
                        delete = "^(.-%*%*)().-(%*%*)()$",
                    },
                },
                aliases = {
                    ["b"] = "b",
                },
            }
        },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
            cond = M.not_vscode,
            event = "VeryLazy",
            keys = {
                -- basic
                { '<leader>fu', '<cmd>Telescope resume<CR>', desc = "Telescope Resume" },
                { '<leader>fb', '<cmd>Telescope buffers<CR>', desc = "Buffers" },
                { '<leader>fh', '<cmd>Telescope help_tags<CR>', desc = "Help Tags" },
                { '<leader>fH', '<cmd>Telescope highlights<CR>', desc = "Highlights" },
                { '<leader>fR', '<cmd>Telescope registers<CR>', desc = "Registers" },
                { '<leader>fc', '<cmd>Telescope command_history<CR>', desc = "Command History" },

                -- files
                { '<leader><leader>', '<cmd>Telescope find_files<CR>', desc = "Find Files" },
                { '<leader>ff', '<cmd>Telescope find_files hidden=true<CR>', desc = "Find Hidden Files" },
                { '<leader>fr', '<cmd>Telescope oldfiles<CR>', desc = "Recent Files" },

                -- find and replace
                { '<leader>fw', '<cmd>Telescope live_grep<CR>', desc = "Find Text" },
                { '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = "Fuzzy Find" },

                -- git
                { '<leader>fgC', '<cmd>Telescope git_bcommits<CR>', desc = "Git BCommits" },
                { '<leader>fgb', '<cmd>Telescope git_branches<CR>', desc = "Git Branches" },
                { '<leader>fgc', '<cmd>Telescope git_commits<CR>', desc = "Git Commits" },
                { '<leader>fgf', '<cmd>Telescope git_files<CR>', desc = "Git Files" },
                { '<leader>fgs', '<cmd>Telescope git_status<CR>', desc = "Git Status" },
            },
        },
        {
            "nvimdev/dashboard-nvim",
            cond = M.not_vscode,
            lazy = false,
            opts = function()
                local logo = [[
                    ██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
                    ██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝    ████╗  ██║██║   ██║██║████╗ ████║
                    ██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗      ██╔██╗ ██║██║   ██║██║██╔████╔██║
                    ╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝      ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
                     ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
                      ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                ]]
                logo = logo:gsub(string.rep(" ", 20), "") .. "\n\n"

                local opts = {
                    theme = "doom",
                    config = {
                        header = vim.split(logo, "\n"),
                        center = {
                            { action = "Telescope find_files", desc = " Find File", icon = " ", key = "f" },
                            { action = "ene | startinsert", desc = " New File", icon = " ", key = "i" },
                            { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
                            { action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "w" },
                            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
                            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
                            { action = "qall", desc = " Quit", icon = " ", key = "q" },
                        },
                        footer = function()
                            local stats = require("lazy").stats()
                            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                            return { "⚡ Neovim loaded " ..
                            stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
                        end,
                        vertical_center = true,
                    },
                }

                for _, button in ipairs(opts.config.center) do
                    button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
                    button.key_format = "  %s"
                end

                -- open dashboard after closing lazy
                if vim.o.filetype == "lazy" then
                    vim.api.nvim_create_autocmd("WinClosed", {
                        pattern = tostring(vim.api.nvim_get_current_win()),
                        once = true,
                        callback = function()
                            vim.schedule(function()
                                vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
                            end)
                        end,
                    })
                end

                return opts
            end,
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            cond = M.not_vscode,
            event = "VeryLazy",
            main = "ibl",
            opts = function()
                local opts = {
                    scope = {
                        enabled = true,
                        show_start = true,
                        show_end = false,
                    },
                    exclude = {
                        filetypes = {
                            'dashboard',
                        },
                    },
                }

                -- local hooks = require "ibl.hooks"
                -- hooks.register(
                --     hooks.type.WHITESPACE,
                --     hooks.builtin.hide_first_space_indent_level
                -- )

                return opts
            end,
        },
        {
            'mikavilpas/yazi.nvim',
            cond = M.not_vscode,
            event = "VeryLazy",
            keys = {
                { '<M-y>', '<cmd>Yazi cwd<CR>', desc = "Open Yazi in cwd" },
                { '<M-Y>', '<cmd>Yazi<CR>', desc = "Open Yazi at file" },
                { '<leader>ee', '<cmd>Yazi cwd<CR>', desc = "Open Yazi in cwd" },
            },
            opts = {
                yazi_floating_window_border = "none",
                yazi_floating_window_winblend = 10,
            },
        },
        {
            'gcmt/wildfire.vim',
            event = "VeryLazy",
        },
        {
            'romainl/vim-cool',
            event = "VeryLazy",
        },
    })
end

function M.set_keymaps()
    for _, mapping in ipairs({ "jj", "jk", "kj", "kk", "jl", "jh" }) do
        vim.keymap.set("c", mapping, "<C-c>", { noremap = true })
        if M.not_vscode then
            vim.keymap.set("i", mapping, "<esc>", { noremap = true })
        end
    end

    ---@class VscAction
    ---@field [1] string|string[] vscode action id
    ---@field wait? boolean use `vscode.call` instead of `vscode.action` if true
    ---@field post_esc? boolean press `<esc>` after action if true

    ---@class Keymap: vim.keymap.set.Opts
    ---@field [1] string lhs
    ---@field [2] string|function|VscAction rhs
    ---@field mode? string|string[] @default "n"

    ---@type Keymap[]
    local keymaps = {
        -- basic commands

        -- copy and paste
        { "<leader>y", "\"+y", mode = { "n", "v" }, noremap = true },
        { "<leader>p", "\"+p", mode = { "n", "v" }, noremap = true },

        -- cursor movement
        { "<C-n>", "g*", noremap = true },
        { "<C-p>", "g#", noremap = true },
        { "<C-n>", function() vim.api.nvim_input("*") end, mode = "v" },
        { "<C-p>", function() vim.api.nvim_input("#") end, mode = "v" },
        { "<C-j>", "<esc>o", mode = "i", noremap = true },
        { "<C-k>", "<esc>O", mode = "i", noremap = true },
        { "<C-h>", "<esc>I", mode = "i", noremap = true },
        { "<C-l>", "<esc>A", mode = "i", noremap = true },
        { "<A-J>", "<Down>", mode = "i", noremap = true },
        { "<A-K>", "<Up>", mode = "i", noremap = true },
        { "<A-H>", "<C-Left>", mode = "i", noremap = true },
        { "<A-L>", "<C-Right>", mode = "i", noremap = true },
        { "<A-j>", "<Down>", mode = "i", noremap = true },
        { "<A-k>", "<Up>", mode = "i", noremap = true },
        { "<A-h>", "<C-Left>", mode = "i", noremap = true },
    }

    if M.has_vscode then
        keymaps = vim.list_extend(keymaps, {
            -- basic commands
            { "<A-s>", { "workbench.action.files.save" } },
            { "<A-S>", { "workbench.action.files.saveAll" } },
            { "<A-w>", vim.cmd.Quit },
            { "<leader>c", vim.cmd.Quit },
            { "<leader>q", vim.cmd.Quit },
            { "<leader>sv", vim.cmd.Vsplit },
            { "<leader>sh", vim.cmd.Split },
            { "<leader>b", { "workbench.action.toggleSidebarVisibility" } },

            -- copy and paste
            { "<A-c>", { "editor.action.clipboardCopyAction", wait = true, post_esc = true }, mode = { "n", "v" } },
            { "<C-S-c>", { "editor.action.clipboardCopyAction", wait = true, post_esc = true }, mode = { "n", "v" } },

            -- edit config file and source
            { "<leader>ef", function() vim.cmd.Edit(M.this_file_path) end },
            { "<leader>sf", function() vim.cmd.source(M.this_file_path) end },
            { "<leader>ec", { "workbench.action.openSettingsJson" } },
            { "<leader>ek", { "workbench.action.openGlobalKeybindingsFile" } },

            -- backup line and restore
            {
                "DC",
                {
                    {
                        "editor.action.commentLine",
                        "editor.action.clipboardCopyAction",
                        "editor.action.clipboardPasteAction",
                        "editor.action.commentLine",
                    },
                    wait = true,
                }
            },
            {
                "DR",
                {
                    {
                        "editor.action.deleteLines",
                        "cursorUp",
                        "editor.action.commentLine",
                    },
                    wait = true,
                }
            },

            -- copilot
            { "<A-n>", { "editor.action.inlineSuggest.showPrevious" }, mode = "i" },
            { "<A-p>", { "editor.action.inlineSuggest.showNext" }, mode = "i" },
            { "<A-I>", { "interactiveEditor.start" }, mode = "i" },
            { "<A-i>", { "workbench.panel.chat.view.copilot.focus", post_esc = true }, mode = "i" },
            { "<A-i>", { "workbench.panel.chat.view.copilot.focus" }, mode = { "n", "v" } },
            { "<A-a>", { "editor.action.inlineSuggest.commit" }, mode = "i" },
            { "<A-Right>", { "editor.action.inlineSuggest.acceptNextWord" }, mode = "i" },
            { "<A-C-Right>", { "editor.action.inlineSuggest.acceptNextLine" }, mode = "i" },
            { "<C-i>", { "inlineChat.start" }, mode = "v" },

            -- cursor movement
            { "H", { "workbench.action.previousEditor" } },
            { "L", { "workbench.action.nextEditor" } },
            { "<A-l>", { "tabout" }, mode = "i" },
            { "<C-j>", { "workbench.action.editor.nextChange" } },
            { "<C-k>", { "workbench.action.editor.previousChange" } },
            { "<C-l>", "50l", noremap = true },
            { "<C-h>", "50h", noremap = true },
            { "<C-i>", { "workbench.action.navigateForward" } },
            { "<C-o>", { "workbench.action.navigateBack" } },

            -- lsp
            { "<leader>rn", { "editor.action.rename" } },
            { "<A-e>", { "editor.action.showHover" } },
            { "<A-f>", { "editor.action.formatDocument" } },
            { "gr", { "editor.action.goToReferences" } },
            { "gp", { "editor.action.showDefinitionPreviewHover" } },
            { "[g", { "editor.action.marker.prevInFiles" } },
            { "]g", { "editor.action.marker.nextInFiles" } },

            -- files
            { "<leader>fr", { "workbench.action.quickOpen" } },
            { "<leader><leader>", { "workbench.action.quickOpen" } },
            { "<leader>ee", { "workbench.files.action.focusFilesExplorer" } },

            -- find and replace
            { "<leader>fw", { "workbench.action.findInFiles", wait = true, post_esc = true }, mode = { "n", "v" } },
            { "<leader>RR", { "workbench.action.replaceInFiles", wait = true, post_esc = true }, mode = { "n", "v" } },
            { "R", { "editor.action.startFindReplaceAction", wait = true, post_esc = true }, mode = { "n", "v" } },

            -- run and debug
            { "<leader>ru", { "code-runner.run" } },
            { "<leader>rr", { "taskExplorer.runLastTask" } },

            -- git
            { "<leader>gg", { "workbench.view.scm" } },
            { "<leader>gd", { { "workbench.view.scm", "git.openChange" } } },
            { "<leader>gf", { "git.viewFileHistory" } },
            { "<leader>gp", { "editor.action.dirtydiff.next" } },
            { "<leader>gr", { "git.revertSelectedRanges" } },
            { "<leader>gs", { "git.stageSelectedRanges" } },
        })
    else
        keymaps = vim.list_extend(keymaps, {
            -- basic commands
            { "<A-s>", vim.cmd.write },
            { "<A-S>", vim.cmd.wall },
            { "<A-w>", vim.cmd.quit },
            { "<A-W>", function() vim.cmd.quit({ bang = true }) end },
            { "<A-q>", vim.cmd.quitall },
            { "<leader>c", vim.cmd.bdelete },
            { "<leader>q", vim.cmd.quit },
            { "<leader>sv", vim.cmd.vsplit },
            { "<leader>sh", vim.cmd.split },

            -- edit config file and source
            { "<leader>ef", function() vim.cmd.edit("$MYVIMRC") end },
            { "<leader>sf", function() vim.cmd.source("$MYVIMRC") end },

            -- backup line and restore
            { "DC", function() vim.api.nvim_input("yypkgccj") end },
            { "DR", function() vim.api.nvim_input("ddkgcc") end },

            -- cursor movement
            { "H", vim.cmd.bprevious },
            { "L", vim.cmd.bnext },
            { "<A-h>", "<C-w>h", noremap = true },
            { "<A-j>", "<C-w>j", noremap = true },
            { "<A-k>", "<C-w>k", noremap = true },
            { "<A-l>", "<C-w>l", noremap = true },
            { "<A-->", "<C-w>_", noremap = true },
            { "<C-h>", "10zh", noremap = true },
            { "<C-l>", "10zl", noremap = true },
            { "<A-l>", "<C-Right>", mode = "i", noremap = true },

            -- diff
            { "DO", function() vim.cmd("%diffget") end },
            { "DP", function() vim.cmd("%diffput") end },
            { "DU", vim.cmd.diffupdate },

            -- quickfix
            { "<A-N>", vim.cmd.cnext },
            { "<A-P>", vim.cmd.cprevious },
        })
    end

    ---@param map Keymap
    ---@return vim.keymap.set.Opts
    local function get_opts(map)
        local opts = {}
        for k, v in pairs(map) do
            if type(k) ~= "number" and k ~= "mode" then
                opts[k] = v
            end
        end
        return opts
    end

    for _, map in ipairs(keymaps) do
        local rhs = map[2] --[[@as string|function|table]]
        if type(rhs) == "table" then
            local action = rhs[1]
            local _run = rhs.wait and M.vscode.call or M.vscode.action
            local _esc = rhs.post_esc and function() vim.api.nvim_input("<esc>") end or function() end
            rhs = type(action) == "string" and function()
                _run(action)
                _esc()
            end or function()
                for _, n in ipairs(action) do
                    _run(n)
                    _esc()
                end
            end
        end
        vim.keymap.set(map.mode or "n", map[1], rhs, get_opts(map))
    end
end

function M.set_autocmds()
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = M.autogroup,
        callback = function()
            vim.highlight.on_yank({ higroup = "Search", timeout = 300 })
        end,
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = M.autogroup,
        command = "set formatoptions-=cro"
    })

    if M.has_vscode then
    else
        vim.api.nvim_create_autocmd("BufReadPost", {
            group = M.autogroup,
            pattern = "*",
            callback = function()
                if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                    vim.api.nvim_input("g'\"")
                end
            end
        })
    end
end

function M.set_usercmds()
    if M.has_vscode then
        vim.api.nvim_create_user_command("FixWhitespace", function()
            M.vscode.action("editor.action.trimTrailingWhitespace")
        end, {})
        vim.api.nvim_create_user_command("ReloadWindow", function()
            M.vscode.action("workbench.action.reloadWindow")
        end, {})
        vim.api.nvim_create_user_command("RestartAllExtension", function()
            M.vscode.action("workbench.action.restartExtensionHost")
        end, {})
        vim.api.nvim_create_user_command("RestartNeovim", function()
            M.vscode.action("vscode-neovim.restart")
        end, {})
        vim.api.nvim_create_user_command("MarkdownPreview", function()
            M.vscode.action("markdown.showPreviewToSide")
        end, {})
    end
end

function M.setup()
    if M.has_vscode then
        vim.notify = M.vscode.notify
        if not M.check_appname_ok() then
            vim.notify("warning(vscode nvim): `NVIM_APPNAME` is not equal to `vscnvim`", vim.log.levels.WARN)
        end
    end

    M.set_options()
    M.setup_lazy_nvim()
    M.set_keymaps()
    M.set_autocmds()
    M.set_usercmds()
end

M.setup()

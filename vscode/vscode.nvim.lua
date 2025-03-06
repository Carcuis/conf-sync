-- =============================================================================================
--   _____                  _                             __               _         __
--  / ___/__ ___________ __(_)__    _  _____ _______  ___/ /__   ___ _  __(_)_ _    / /_ _____ _
-- / /__/ _ `/ __/ __/ // / (_-<   | |/ (_-</ __/ _ \/ _  / -_) / _ \ |/ / /  ' \_ / / // / _ `/
-- \___/\_,_/_/  \__/\_,_/_/___/   |___/___/\__/\___/\_,_/\__(_)_//_/___/_/_/_/_(_)_/\_,_/\_,_/
--
-- =============================================================================================

local M = {}

function M.set_options()
    vim.o.conceallevel = 1
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.g.mapleader = " "

    if not vim.g.vscode then
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
        vim.notify("NVIM_APPNAME error, not equal to `vscnvim`", vim.log.levels.ERROR)
        return
    end

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    ---@diagnostic disable-next-line: undefined-field
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        if vim.g.vscode then
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
            cond = vim.g.vscode == nil,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("vscode")
            end,
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            cond = vim.g.vscode == nil,
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
            cond = vim.g.vscode == nil,
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
            cond = vim.g.vscode == nil,
            event = "VeryLazy",
        },
        {
            "nvimdev/dashboard-nvim",
            cond = vim.g.vscode == nil,
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
                            { action = 'Telescope find_files', desc = " Find File", icon = " ", key = "f" },
                            { action = "ene | startinsert", desc = " New File", icon = " ", key = "i" },
                            { action = 'Telescope oldfiles', desc = " Recent Files", icon = " ", key = "r" },
                            { action = 'Telescope live_grep', desc = " Find Text", icon = " ", key = "w" },
                            { action = 'e $MYVIMRC', desc = " Config", icon = " ", key = "c" },
                            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
                            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
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
            cond = vim.g.vscode == nil,
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

                local hooks = require "ibl.hooks"
                hooks.register(
                    hooks.type.WHITESPACE,
                    hooks.builtin.hide_first_space_indent_level
                )

                return opts
            end,
        },
        {
            'mikavilpas/yazi.nvim',
            cond = vim.g.vscode == nil,
            event = "VeryLazy",
            keys = {
                { '<M-y>', '<cmd>Yazi<CR>', desc = "Open Yazi" },
            },
        }
    })
end

function M.set_keymaps()
    ---@class Keymap
    ---@field mode string|string[]
    ---@field lhs string
    ---@field rhs? string
    ---@field func? function
    ---@field opts? table

    for _, mapping in ipairs({ "jj", "jk", "kj", "kk", "jl", "jh" }) do
        vim.keymap.set("i", mapping, "<esc>", { noremap = true })
        vim.keymap.set("c", mapping, "<C-c>", { noremap = true })
    end

    ---@type Keymap[]
    local keymaps = {
        -- basic commands
        { mode = "n", lhs = "<esc>", func = vim.cmd.nohlsearch },
        { mode = "n", lhs = "<A-s>", func = vim.cmd.write },
        { mode = "n", lhs = "<A-S>", func = vim.cmd.wall },
        { mode = "n", lhs = "<A-w>", func = vim.cmd.quit },
        { mode = "n", lhs = "<leader>c", func = vim.cmd.bdelete },
        { mode = "n", lhs = "<leader>q", func = vim.cmd.quit },
        { mode = "n", lhs = "<leader>sv", func = vim.cmd.vsplit },
        { mode = "n", lhs = "<leader>sh", func = vim.cmd.split },

        -- edit config file and source
        { mode = "n", lhs = "<leader>ef", func = function() vim.cmd.edit("$MYVIMRC") end },
        { mode = "n", lhs = "<leader>sf", func = function() vim.cmd.source("$MYVIMRC") end },

        -- copy and paste
        { mode = { "n", "v" }, lhs = "<leader>y", rhs = "\"+y", opts = { noremap = true } },
        { mode = { "n", "v" }, lhs = "<leader>p", rhs = "\"+p", opts = { noremap = true } },

        -- window navigation
        { mode = "n", lhs = "<A-h>", rhs = "<C-w>h", opts = { noremap = true } },
        { mode = "n", lhs = "<A-j>", rhs = "<C-w>j", opts = { noremap = true } },
        { mode = "n", lhs = "<A-k>", rhs = "<C-w>k", opts = { noremap = true } },
        { mode = "n", lhs = "<A-l>", rhs = "<C-w>l", opts = { noremap = true } },
        { mode = "n", lhs = "<A-->", rhs = "<C-w>_", opts = { noremap = true } },
        { mode = "n", lhs = "H", func = vim.cmd.bprevious },
        { mode = "n", lhs = "L", func = vim.cmd.bnext },
    }
    for _, map in ipairs(keymaps) do
        local rhs = map.func or map.rhs or ""
        vim.keymap.set(map.mode, map.lhs, rhs, map.opts)
    end
end

---@param vscode vscode
function M.vsc_set_keymaps(vscode)
    local file_path = debug.getinfo(1).source:sub(2)

    for _, mapping in ipairs({ "jj", "jk", "kj", "kk", "jl", "jh" }) do
        vim.keymap.set("c", mapping, "<C-c>", { noremap = true })
    end

    ---@class VscKeymap
    ---@field mode string|string[]
    ---@field lhs string
    ---@field rhs? string
    ---@field func? function
    ---@field action? string
    ---@field wait? boolean
    ---@field post_esc? boolean
    ---@field opts? table

    ---@type VscKeymap[]
    local keymaps = {
        -- basic commands
        { mode = "n", lhs = "<esc>", func = vim.cmd.nohlsearch },
        { mode = "n", lhs = "<A-s>", action = "workbench.action.files.save" },
        { mode = "n", lhs = "<A-S>", action = "workbench.action.files.saveAll" },
        { mode = "n", lhs = "<A-w>", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>c", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>q", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>sv", func = vim.cmd.Vsplit },
        { mode = "n", lhs = "<leader>sh", func = vim.cmd.Split },

        -- copy and paste
        { mode = { "n", "v" }, lhs = "<A-c>", action = "editor.action.clipboardCopyAction", wait = true, post_esc = true },
        { mode = { "n", "v" }, lhs = "<leader>y", rhs = "\"+y", opts = { noremap = true } },
        { mode = { "n", "v" }, lhs = "<leader>p", rhs = "\"+p", opts = { noremap = true } },

        -- edit config file and source
        { mode = "n", lhs = "<leader>ef", func = function() vim.cmd.Edit(file_path) end },
        { mode = "n", lhs = "<leader>sf", func = function() vim.cmd.source(file_path) end },

        -- backup line and restore
        {
            mode = "n",
            lhs = "DC",
            func = function()
                vscode.call("editor.action.commentLine")
                vscode.call("editor.action.clipboardCopyAction")
                vscode.call("editor.action.clipboardPasteAction")
                vscode.call("editor.action.commentLine")
            end
        },
        {
            mode = "n",
            lhs = "DR",
            func = function()
                vscode.call("editor.action.deleteLines")
                vscode.call("cursorUp")
                vscode.call("editor.action.commentLine")
            end
        },

        -- copilot
        { mode = "i", lhs = "<A-n>", action = "editor.action.inlineSuggest.showPrevious" },
        { mode = "i", lhs = "<A-p>", action = "editor.action.inlineSuggest.showNext" },
        { mode = "i", lhs = "<A-I>", action = "interactiveEditor.start" },
        { mode = "i", lhs = "<A-i>", action = "workbench.panel.chat.view.copilot.focus", post_esc = true },
        { mode = { "n", "v" }, lhs = "<A-i>", action = "workbench.panel.chat.view.copilot.focus" },
        { mode = "i", lhs = "<A-a>", action = "editor.action.inlineSuggest.commit" },
        { mode = "i", lhs = "<A-right>", action = "editor.action.inlineSuggest.acceptNextWord" },
        { mode = "i", lhs = "<A-C-right>", action = "editor.action.inlineSuggest.acceptNextLine" },
        { mode = "v", lhs = "<C-i>", action = "inlineChat.start" },

        -- cursor movement
        { mode = "n", lhs = "H", action = "workbench.action.previousEditor" },
        { mode = "n", lhs = "L", action = "workbench.action.nextEditor" },
        { mode = "i", lhs = "<A-l>", action = "tabout" },
        { mode = "n", lhs = "<C-j>", action = "workbench.action.editor.nextChange" },
        { mode = "n", lhs = "<C-k>", action = "workbench.action.editor.previousChange" },
        { mode = "n", lhs = "<C-l>", rhs = "50l", opts = { noremap = true } },
        { mode = "n", lhs = "<C-h>", rhs = "50h", opts = { noremap = true } },
        { mode = { "n", "v" }, lhs = "<C-n>", rhs = "*<esc>", opts = { noremap = true } },
        { mode = { "n", "v" }, lhs = "<C-p>", rhs = "#<esc>", opts = { noremap = true } },
        { mode = "n", lhs = "<C-i>", action = "workbench.action.navigateForward" },
        { mode = "n", lhs = "<C-o>", action = "workbench.action.navigateBack" },

        -- lsp
        { mode = "n", lhs = "<leader>rn", action = "editor.action.rename" },
        { mode = "n", lhs = "<A-e>", action = "editor.action.showHover" },
        { mode = "n", lhs = "gr", action = "editor.action.goToReferences" },
        { mode = "n", lhs = "gp", action = "editor.action.showDefinitionPreviewHover" },

        -- files
        { mode = "n", lhs = "<leader>fr", action = "workbench.action.quickOpen" },
        { mode = "n", lhs = "<leader>ff", action = "workbench.action.quickOpen" },
        { mode = "n", lhs = "<leader>ee", action = "workbench.files.action.focusFilesExplorer" },

        -- find and replace
        { mode = { "n", "v" }, lhs = "<leader>fw", action = "workbench.action.findInFiles", wait = true, post_esc = true },
        { mode = { "n", "v" }, lhs = "<leader>fR", action = "workbench.action.replaceInFiles", wait = true, post_esc = true },
        { mode = { "n", "v" }, lhs = "R", action = "editor.action.startFindReplaceAction", wait = true, post_esc = true },

        -- run and debug
        { mode = "n", lhs = "<leader>ru", action = "code-runner.run" },
        { mode = "n", lhs = "<leader>rr", action = "taskExplorer.runLastTask" },
    }
    for _, map in ipairs(keymaps) do
        local rhs = map.func or map.rhs or function()
            if map.wait then
                vscode.call(map.action)
            else
                vscode.action(map.action)
            end
            if map.post_esc then
                vim.api.nvim_input("<esc>")
            end
        end
        vim.keymap.set(map.mode, map.lhs, rhs, map.opts)
    end
end

function M.set_autocmds()
    local group = vim.api.nvim_create_augroup("user_group", { clear = true })

    -- autocmds for all
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = group,
        callback = function()
            vim.highlight.on_yank({ higroup = "Search", timeout = 300 })
        end,
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        command = "set formatoptions-=cro"
    })

    if vim.g.vscode then
        -- autocmds inside vscode only
    else
        -- autocmds outside vscode only
        vim.api.nvim_create_autocmd("BufReadPost", {
            group = group,
            pattern = "*",
            callback = function()
                if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                    vim.api.nvim_input("g'\"")
                end
            end
        })
    end
end

---@param vscode vscode
function M.vsc_set_usercmds(vscode)
    vim.api.nvim_create_user_command("FixWhitespace", function()
        vscode.action("editor.action.trimTrailingWhitespace")
    end, {})
end

function M.setup()
    M.set_options()

    if vim.g.vscode then
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
        local vscode = require("vscode")

        vim.notify = vscode.notify
        if not M.check_appname_ok() then
            vim.notify("vscode nvim: `NVIM_APPNAME` error, not equal to `vscnvim`", vim.log.levels.WARN)
        end
        M.vsc_set_keymaps(vscode)
        M.vsc_set_usercmds(vscode)
    else
        M.set_keymaps()
    end

    M.set_autocmds()
    M.setup_lazy_nvim()
end

M.setup()

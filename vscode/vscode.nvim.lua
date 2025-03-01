-- =============================================================================================
--   _____                  _                             __               _         __
--  / ___/__ ___________ __(_)__    _  _____ _______  ___/ /__   ___ _  __(_)_ _    / /_ _____ _
-- / /__/ _ `/ __/ __/ // / (_-<   | |/ (_-</ __/ _ \/ _  / -_) / _ \ |/ / /  ' \_ / / // / _ `/
-- \___/\_,_/_/  \__/\_,_/_/___/   |___/___/\__/\___/\_,_/\__(_)_//_/___/_/_/_/_(_)_/\_,_/\_,_/
--
-- =============================================================================================

---@diagnostic disable-next-line: undefined-global
local vim = vim
local vscode = require("vscode")

local file_path = debug.getinfo(1).source:sub(2)

local M = {}

function M.set_options()
    vim.o.conceallevel = 1
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.g.mapleader = " "
end

function M.set_keymaps()
    for _, mapping in ipairs({ "jj", "jk", "kj", "kk", "jl", "jh" }) do
        vim.keymap.set("c", mapping, "<C-c>", { noremap = true })
    end

    ---@class Keymap
    ---@field mode string|string[]
    ---@field lhs string
    ---@field rhs? string
    ---@field func? function
    ---@field action? string
    ---@field wait? boolean
    ---@field post_esc? boolean
    ---@field opts? table

    ---@type Keymap[]
    local keymaps = {
        -- basic commands
        { mode = "n", lhs = "<esc>", func = vim.cmd.nohlsearch },
        { mode = "n", lhs = "<A-s>", action = "workbench.action.files.save" },
        { mode = "n", lhs = "<A-S>", action = "workbench.action.files.saveAll" },
        { mode = "n", lhs = "<A-w>", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>c", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>q", func = vim.cmd.Quit },
        { mode = "n", lhs = "<leader>vs", func = vim.cmd.Vsplit },
        { mode = "n", lhs = "<leader>sp", func = vim.cmd.Split },

        -- copy and paste
        { mode = { "n", "v" }, lhs = "<A-c>", action = "editor.action.clipboardCopyAction", wait = true, post_esc = true },
        { mode = { "n", "v" }, lhs = "<leader>y", rhs = "\"+y", opts = { noremap = true } },
        { mode = { "n", "v" }, lhs = "<leader>p", rhs = "\"+p", opts = { noremap = true } },

        -- edit config file and source
        { mode = "n", lhs = "<leader>ef", func = function() vim.cmd.Edit(file_path) end },
        { mode = "n", lhs = "<leader>sf", func = function() vim.cmd.source(file_path) end },

        -- backup line and restore
        { mode = "n", lhs = "DC", func = function()
            vscode.call("editor.action.commentLine")
            vscode.call("editor.action.clipboardCopyAction")
            vscode.call("editor.action.clipboardPasteAction")
            vscode.call("editor.action.commentLine")
        end },
        { mode = "n", lhs = "DR", func = function()
            vscode.call("editor.action.deleteLines")
            vscode.call("cursorUp")
            vscode.call("editor.action.commentLine")
        end },

        -- copilot
        { mode = "i", lhs = "<A-n>", action = "editor.action.inlineSuggest.showPrevious" },
        { mode = "i", lhs = "<A-p>", action = "editor.action.inlineSuggest.showNext" },
        { mode = "i", lhs = "<A-I>", action = "interactiveEditor.start" },
        { mode = "i", lhs = "<A-i>", action = "workbench.panel.chat.view.copilot.focus", post_esc = true },
        { mode = { "n", "v" }, lhs = "<A-i>", action = "workbench.panel.chat.view.copilot.focus" },
        { mode = "i", lhs = "<A-a>", action = "editor.action.inlineSuggest.commit" },
        { mode = "i", lhs = "<A-right>", action = "editor.action.inlineSuggest.acceptNextWord" },
        { mode = "i", lhs = "<A-C-right>", action = "editor.action.inlineSuggest.acceptNextLine" },

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
end

function M.set_usercmds()
    vim.api.nvim_create_user_command("FixWhitespace", function()
        vscode.action("editor.action.trimTrailingWhitespace")
    end, {})
end

function M.setup()
    M.set_options()
    M.set_keymaps()
    M.set_autocmds()
    M.set_usercmds()
end

M.setup()

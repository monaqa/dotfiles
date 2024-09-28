local vec = require("rc.util.vec")
local shorthand = require("monaqa.shorthand")
local autocmd_vimrc = shorthand.autocmd_vimrc
local create_cmd = shorthand.create_cmd

local plugins = vec {}

plugins:push {
    "https://github.com/lambdalisue/gina.vim",
    cmd = {
        "Gina",
        "GinaBrowseYank",
        "GinaPrChanges",
    },
    config = function()
        autocmd_vimrc { "FileType" } {
            pattern = "gina-blame",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.signcolumn = "no"
                vim.opt_local.foldcolumn = "0"
            end,
        }

        autocmd_vimrc { "FileType" } {
            pattern = "gina-status",
            callback = function()
                vim.keymap.set("n", "<C-l>", "<Cmd>e<CR>", { buffer = true })
            end,
        }

        autocmd_vimrc { "FileType" } {
            pattern = "gina-log",
            callback = function()
                vim.keymap.set("n", "c", "<Plug>(gina-changes-between)", { buffer = true, nowait = true })
                vim.keymap.set("n", "C", "<Plug>(gina-commit-checkout)", { buffer = true, nowait = true })
                vim.keymap.set(
                    "n",
                    "}",
                    [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'W')<CR>]],
                    { buffer = true, nowait = true }
                )
                vim.keymap.set(
                    "n",
                    "{",
                    [[<Cmd>call search('\v%^<Bar>%$<Bar>^(.*\x{7})@!.*$', 'Wb')<CR>]],
                    { buffer = true, nowait = true }
                )
            end,
        }

        vim.g["gina#command#blame#formatter#format"] = "%su%=|%au %ti %ma%in"

        create_cmd("GinaBrowseYank") {
            desc = [[指定した範囲の GitHub URL を clipboard にコピーする]],
            range = "%",
            function(meta)
                vim.cmd {
                    cmd = "Gina",
                    args = {
                        "browse",
                        "--exact",
                        "--yank",
                        ":",
                    },
                    range = { meta.line1, meta.line2 },
                }
                vim.fn.setreg("+", vim.fn.getreg([["]]))
                vim.notify("Copied URL: " .. vim.fn.getreg("+"))
            end,
        }

        create_cmd("GinaPrChanges") {
            desc = [[今開いているブランチの PR について、差分を表示する]],
            nargs = "?",
            function(meta)
                local branch = meta.args
                if meta.args == "" then
                    local base_ref = vim.trim(vim.fn.system("gh pr view --json baseRefName -q '.baseRefName'"))
                    if vim.startswith(base_ref, "no ") then
                        branch = vim.trim(vim.fn.system("git mom"))
                    else
                        branch = base_ref
                    end
                end
                package.loaded.gitsigns.change_base(branch, true)
                vim.cmd(([[Gina changes %s...HEAD]]):format(branch))
            end,
        }
    end,
}

plugins:push {
    "https://github.com/lewis6991/gitsigns.nvim",
    lazy = false,
    config = function(_, opts)
        require("gitsigns").setup(opts)

        local gs = package.loaded.gitsigns

        -- Navigation
        vim.keymap.set("n", "gj", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        vim.keymap.set("n", "gk", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        local function complete_branches(arglead, cmdline, cursorpos)
            local branches = vim.fn.systemlist { "git", "rev-parse", "--symbolic", "--branches", "--tags", "--remotes" }
            branches = vim.tbl_filter(function(cand)
                return vim.startswith(cand, arglead)
            end, branches)
            return branches
        end

        vim.api.nvim_create_user_command("GitsignsChangeBase", function(opts)
            local branch = "HEAD"
            if opts.fargs[1] ~= nil then
                branch = opts.fargs[1]
            else
                local branches = complete_branches("")
                for _, item in ipairs { "master", "main" } do
                    if vim.tbl_contains(branches, item) then
                        branch = item
                        break
                    end
                end
            end
            package.loaded.gitsigns.change_base(branch, true)
        end, {
            nargs = "*",
            complete = complete_branches,
        })
    end,
    opts = {
        signs = {
            add = { text = "║" },
            change = { text = "║" },
            delete = {},
            topdelete = {},
            changedelete = {
                text = "┋",
            },
        },
        signcolumn = false,
        numhl = true,
        linehl = false,
        word_diff = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "right_align",
            delay = 10,
            ignore_whitespace = true,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Actions
            -- map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
            -- map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
            -- map("n", "<leader>hS", gs.stage_buffer)
            -- map("n", "<leader>hu", gs.undo_stage_hunk)
            -- map("n", "<leader>hR", gs.reset_buffer)

            map("n", "<Space>d", gs.preview_hunk)
            map("n", "@b", gs.toggle_current_line_blame)

            -- map("n", "<leader>hb", function()
            --     gs.blame_line { full = true }
            -- end)
            -- map("n", "<leader>tb", gs.toggle_current_line_blame)
            -- map("n", "<leader>hd", gs.diffthis)
            -- map("n", "<leader>hD", function()
            --     gs.diffthis "~"
            -- end)
            -- map("n", "<leader>td", gs.toggle_deleted)

            -- Text object
            -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
    },
}

return plugins:collect()

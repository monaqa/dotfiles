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

plugins:push {
    "https://github.com/sindrets/diffview.nvim",
    config = function()
        -- Lua
        local actions = require("diffview.actions")

        require("diffview").setup {
            diff_binaries = false, -- Show diffs for binaries
            enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
            git_cmd = { "git" }, -- The git executable followed by default args.
            use_icons = true, -- Requires nvim-web-devicons
            show_help_hints = true, -- Show hints for how to open the help panel
            watch_index = true, -- Update views and index buffers when the git index changes.
            icons = { -- Only applies when use_icons is true.
                folder_closed = "",
                folder_open = "",
            },
            signs = {
                fold_closed = "",
                fold_open = "",
                done = "✓",
            },
            view = {
                -- Configure the layout and behavior of different types of views.
                -- Available layouts:
                --  'diff1_plain'
                --    |'diff2_horizontal'
                --    |'diff2_vertical'
                --    |'diff3_horizontal'
                --    |'diff3_vertical'
                --    |'diff3_mixed'
                --    |'diff4_mixed'
                -- For more info, see |diffview-config-view.x.layout|.
                default = {
                    -- Config for changed files, and staged files in diff views.
                    layout = "diff2_horizontal",
                    disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
                    winbar_info = false, -- See |diffview-config-view.x.winbar_info|
                },
                merge_tool = {
                    -- Config for conflicted files in diff views during a merge or rebase.
                    layout = "diff3_horizontal",
                    disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
                    winbar_info = true, -- See |diffview-config-view.x.winbar_info|
                },
                file_history = {
                    -- Config for changed files in file history views.
                    layout = "diff2_horizontal",
                    disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
                    winbar_info = false, -- See |diffview-config-view.x.winbar_info|
                },
            },
            file_panel = {
                listing_style = "tree", -- One of 'list' or 'tree'
                tree_options = { -- Only applies when listing_style is 'tree'
                    flatten_dirs = true, -- Flatten dirs that only contain one single dir
                    folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
                },
                win_config = { -- See |diffview-config-win_config|
                    position = "bottom",
                    height = 10,
                    win_opts = {},
                },
            },
            file_history_panel = {
                log_options = { -- See |diffview-config-log_options|
                    git = {
                        single_file = {
                            diff_merges = "combined",
                        },
                        multi_file = {
                            diff_merges = "first-parent",
                        },
                    },
                    hg = {
                        single_file = {},
                        multi_file = {},
                    },
                },
                win_config = { -- See |diffview-config-win_config|
                    position = "bottom",
                    height = 16,
                    win_opts = {},
                },
            },
            commit_log_panel = {
                win_config = {}, -- See |diffview-config-win_config|
            },
            default_args = { -- Default args prepended to the arg-list for the listed commands
                DiffviewOpen = {},
                DiffviewFileHistory = {},
            },
            hooks = {}, -- See |diffview-config-hooks|
            keymaps = {
                disable_defaults = true, -- Disable the default keymaps
                view = {
                    -- The `view` bindings are active in the diff buffers, only when the current
                    -- tabpage is a Diffview.
                    {
                        "n",
                        "<Down>",
                        actions.select_next_entry,
                        { desc = "Open the diff for the next file" },
                    },
                    {
                        "n",
                        "<Up>",
                        actions.select_prev_entry,
                        { desc = "Open the diff for the previous file" },
                    },
                    {
                        "n",
                        "<CR>",
                        actions.goto_file_edit,
                        { desc = "Open the file in the previous tabpage" },
                    },
                    {
                        "n",
                        "gf",
                        actions.goto_file_edit,
                        { desc = "Open the file in the previous tabpage" },
                    },
                    {
                        "n",
                        "[x",
                        actions.prev_conflict,
                        { desc = "In the merge-tool: jump to the previous conflict" },
                    },
                    {
                        "n",
                        "]x",
                        actions.next_conflict,
                        { desc = "In the merge-tool: jump to the next conflict" },
                    },
                    {
                        "n",
                        "q",
                        actions.toggle_files,
                        { desc = "Toggle the file panel" },
                    },
                },
                diff1 = {
                    -- Mappings in single window diff layouts
                    { "n", "g?", actions.help { "view", "diff1" }, { desc = "Open the help panel" } },
                },
                diff2 = {
                    -- Mappings in 2-way diff layouts
                    { "n", "g?", actions.help { "view", "diff2" }, { desc = "Open the help panel" } },
                },
                diff3 = {
                    -- Mappings in 3-way diff layouts
                    {
                        { "n", "x" },
                        "2do",
                        actions.diffget("ours"),
                        { desc = "Obtain the diff hunk from the OURS version of the file" },
                    },
                    {
                        { "n", "x" },
                        "3do",
                        actions.diffget("theirs"),
                        { desc = "Obtain the diff hunk from the THEIRS version of the file" },
                    },
                    { "n", "g?", actions.help { "view", "diff3" }, { desc = "Open the help panel" } },
                },
                diff4 = {
                    -- Mappings in 4-way diff layouts
                    {
                        { "n", "x" },
                        "1do",
                        actions.diffget("base"),
                        { desc = "Obtain the diff hunk from the BASE version of the file" },
                    },
                    {
                        { "n", "x" },
                        "2do",
                        actions.diffget("ours"),
                        { desc = "Obtain the diff hunk from the OURS version of the file" },
                    },
                    {
                        { "n", "x" },
                        "3do",
                        actions.diffget("theirs"),
                        { desc = "Obtain the diff hunk from the THEIRS version of the file" },
                    },
                    { "n", "g?", actions.help { "view", "diff4" }, { desc = "Open the help panel" } },
                },
                file_panel = {
                    {
                        "n",
                        "j",
                        actions.next_entry,
                        { desc = "Bring the cursor to the next file entry" },
                    },
                    {
                        "n",
                        "<down>",
                        actions.next_entry,
                        { desc = "Bring the cursor to the next file entry" },
                    },
                    {
                        "n",
                        "k",
                        actions.prev_entry,
                        { desc = "Bring the cursor to the previous file entry" },
                    },
                    {
                        "n",
                        "<up>",
                        actions.prev_entry,
                        { desc = "Bring the cursor to the previous file entry" },
                    },
                    {
                        "n",
                        "<cr>",
                        actions.select_entry,
                        { desc = "Open the diff for the selected entry" },
                    },
                    {
                        "n",
                        "l",
                        actions.select_entry,
                        { desc = "Open the diff for the selected entry" },
                    },
                    {
                        "n",
                        "-",
                        actions.toggle_stage_entry,
                        { desc = "Stage / unstage the selected entry" },
                    },
                    {
                        "n",
                        "L",
                        actions.open_commit_log,
                        { desc = "Open the commit log panel" },
                    },
                    { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
                    { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
                    { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
                    { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
                    { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
                    { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
                    { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
                    {
                        "n",
                        "<Down>",
                        actions.select_next_entry,
                        { desc = "Open the diff for the next file" },
                    },
                    {
                        "n",
                        "<Up>",
                        actions.select_prev_entry,
                        { desc = "Open the diff for the previous file" },
                    },
                    {
                        "n",
                        "gf",
                        actions.goto_file_edit,
                        { desc = "Open the file in the previous tabpage" },
                    },
                    {
                        "n",
                        "i",
                        actions.listing_style,
                        { desc = "Toggle between 'list' and 'tree' views" },
                    },
                    {
                        "n",
                        "R",
                        actions.refresh_files,
                        { desc = "Update stats and entries in the file list" },
                    },
                    {
                        "n",
                        "q",
                        actions.toggle_files,
                        { desc = "Toggle the file panel" },
                    },
                    {
                        "n",
                        "[x",
                        actions.prev_conflict,
                        { desc = "Go to the previous conflict" },
                    },
                    {
                        "n",
                        "]x",
                        actions.next_conflict,
                        { desc = "Go to the next conflict" },
                    },
                    { "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
                },
                file_history_panel = {
                    { "n", "g!", actions.options, { desc = "Open the option panel" } },
                    {
                        "n",
                        "d",
                        actions.open_in_diffview,
                        { desc = "Open the entry under the cursor in a diffview" },
                    },
                    {
                        "n",
                        "y",
                        actions.copy_hash,
                        { desc = "Copy the commit hash of the entry under the cursor" },
                    },
                    { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
                    { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
                    { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
                    { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
                    { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
                    { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
                    { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
                    {
                        "n",
                        "j",
                        actions.next_entry,
                        { desc = "Bring the cursor to the next file entry" },
                    },
                    {
                        "n",
                        "<down>",
                        actions.next_entry,
                        { desc = "Bring the cursor to the next file entry" },
                    },
                    {
                        "n",
                        "k",
                        actions.prev_entry,
                        { desc = "Bring the cursor to the previous file entry" },
                    },
                    {
                        "n",
                        "<up>",
                        actions.prev_entry,
                        { desc = "Bring the cursor to the previous file entry" },
                    },
                    {
                        "n",
                        "<cr>",
                        actions.select_entry,
                        { desc = "Open the diff for the selected entry" },
                    },
                    {
                        "n",
                        "l",
                        actions.select_entry,
                        { desc = "Open the diff for the selected entry" },
                    },
                    {
                        "n",
                        "<Down>",
                        actions.select_next_entry,
                        { desc = "Open the diff for the next file" },
                    },
                    {
                        "n",
                        "<Up>",
                        actions.select_prev_entry,
                        { desc = "Open the diff for the previous file" },
                    },
                    {
                        "n",
                        "gf",
                        actions.goto_file_edit,
                        { desc = "Open the file in the previous tabpage" },
                    },
                    { "n", "q", actions.toggle_files, { desc = "Toggle the file panel" } },
                    { "n", "g?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
                },
                option_panel = {
                    { "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
                    { "n", "q", actions.close, { desc = "Close the panel" } },
                    { "n", "g?", actions.help("option_panel"), { desc = "Open the help panel" } },
                },
                help_panel = {
                    { "n", "q", actions.close, { desc = "Close help menu" } },
                    { "n", "<esc>", actions.close, { desc = "Close help menu" } },
                },
            },
        }

        create_cmd("DiffPrChanges") {
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
                vim.cmd(([[DiffviewOpen %s...HEAD]]):format(branch))
            end,
        }
    end,
}

plugins:push {
    "https://github.com/rickhowe/spotdiff.vim",
    cmd = {
        "Diffthis",
        "Diffoff",
        "Diffupdate",
        "VDiffthis",
        "VDiffoff",
        "VDiffupdate",
    },
}

return plugins:collect()

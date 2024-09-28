local vec = require("rc.util.vec")
local mapset = require("monaqa.shorthand").mapset

local plugins = vec {}

plugins:push {
    "https://github.com/stevearc/aerial.nvim",
    dependencies = { "https://github.com/kyazdani42/nvim-web-devicons" },
    -- lazy = false,
    keys = {
        {
            "<Space>t",
            function()
                require("aerial").toggle { focus = false }
            end,
        },
        {
            "<Space>i",
            function()
                require("aerial").focus()
            end,
        },
    },
    opts = {
        -- Priority list of preferred backends for aerial.
        -- This can be a filetype map (see :help aerial-filetype-map)
        backends = {
            "treesitter",
            -- "lsp",
            "markdown",
            "man",
        },

        layout = {
            -- These control the width of the aerial window.
            -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_width and max_width can be a list of mixed types.
            -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
            max_width = { 40, 0.3 },
            width = nil,
            min_width = 20,

            -- key-value pairs of window-local options for aerial window (e.g. winhl)
            win_opts = {
                winblend = 30,
            },

            -- Determines the default direction to open the aerial window. The 'prefer'
            -- options will open the window in the other direction *if* there is a
            -- different buffer in the way of the preferred direction
            -- Enum: prefer_right, prefer_left, right, left, float
            default_direction = "float",

            -- Determines where the aerial window will be opened
            --   edge   - open aerial at the far right/left of the editor
            --   window - open aerial to the right/left of the current window
            placement = "window",
        },

        -- -- Determines how the aerial window decides which buffer to display symbols for
        -- --   window - aerial window will display symbols for the buffer in the window from which it was opened
        -- --   global - aerial window will display symbols for the current window
        attach_mode = "window",
        --
        -- -- List of enum values that configure when to auto-close the aerial window
        -- --   unfocus       - close aerial when you leave the original source window
        -- --   switch_buffer - close aerial when you change buffers in the source window
        -- --   unsupported   - close aerial when attaching to a buffer that has no symbol source
        -- close_automatic_events = {},
        close_automatic_events = {
            "unfocus",
            "switch_buffer",
            "unsupported",
        },
        --
        -- -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
        -- -- Additionally, if it is a string that matches "aerial.<name>",
        -- -- it will use the mapping at require("aerial.action").<name>
        -- -- Set to `false` to remove a keymap
        -- keymaps = {
        --     ["?"] = "actions.show_help",
        --     ["g?"] = "actions.show_help",
        --     ["<CR>"] = "actions.jump",
        --     ["<2-LeftMouse>"] = "actions.jump",
        --     ["<C-v>"] = "actions.jump_vsplit",
        --     ["<C-s>"] = "actions.jump_split",
        --     ["p"] = "actions.scroll",
        --     ["<C-j>"] = "actions.down_and_scroll",
        --     ["<C-k>"] = "actions.up_and_scroll",
        --     ["{"] = "actions.prev",
        --     ["}"] = "actions.next",
        --     ["[["] = "actions.prev_up",
        --     ["]]"] = "actions.next_up",
        --     ["q"] = "actions.close",
        --     ["o"] = "actions.tree_toggle",
        --     ["za"] = "actions.tree_toggle",
        --     ["O"] = "actions.tree_toggle_recursive",
        --     ["zA"] = "actions.tree_toggle_recursive",
        --     ["l"] = "actions.tree_open",
        --     ["zo"] = "actions.tree_open",
        --     ["L"] = "actions.tree_open_recursive",
        --     ["zO"] = "actions.tree_open_recursive",
        --     ["h"] = "actions.tree_close",
        --     ["zc"] = "actions.tree_close",
        --     ["H"] = "actions.tree_close_recursive",
        --     ["zC"] = "actions.tree_close_recursive",
        --     ["zr"] = "actions.tree_increase_fold_level",
        --     ["zR"] = "actions.tree_open_all",
        --     ["zm"] = "actions.tree_decrease_fold_level",
        --     ["zM"] = "actions.tree_close_all",
        --     ["zx"] = "actions.tree_sync_folds",
        --     ["zX"] = "actions.tree_sync_folds",
        -- },
        --
        -- -- When true, don't load aerial until a command or function is called
        -- -- Defaults to true, unless `on_attach` is provided, then it defaults to false
        -- lazy_load = true,

        -- Disable aerial on files with this many lines
        disable_max_lines = 100000,

        -- Disable aerial on files this size or larger (in bytes)
        disable_max_size = 2000000, -- Default 2MB

        -- A list of all symbols to display. Set to false to display all symbols.
        -- This can be a filetype map (see :help aerial-filetype-map)
        -- To see all available values, see :help SymbolKind
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },

        -- -- Determines line highlighting mode when multiple splits are visible.
        -- -- split_width   Each open window will have its cursor location marked in the
        -- --               aerial buffer. Each line will only be partially highlighted
        -- --               to indicate which window is at that location.
        -- -- full_width    Each open window will have its cursor location marked as a
        -- --               full-width highlight in the aerial buffer.
        -- -- last          Only the most-recently focused window will have its location
        -- --               marked in the aerial buffer.
        -- -- none          Do not show the cursor locations in the aerial window.
        highlight_mode = "last",

        -- -- Highlight the closest symbol if the cursor is not exactly on one.
        -- highlight_closest = true,
        --
        -- -- Highlight the symbol in the source buffer when cursor is in the aerial win
        -- highlight_on_hover = false,
        --
        -- -- When jumping to a symbol, highlight the line for this many ms.
        -- -- Set to false to disable
        -- highlight_on_jump = 300,
        --
        -- -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
        -- -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
        -- -- default collapsed icon. The default icon set is determined by the
        -- -- "nerd_font" option below.
        -- -- If you have lspkind-nvim installed, it will be the default icon set.
        -- -- This can be a filetype map (see :help aerial-filetype-map)
        -- icons = {},
        --
        -- -- Control which windows and buffers aerial should ignore.
        -- -- If attach_mode is "global", focusing an ignored window/buffer will
        -- -- not cause the aerial window to update.
        -- -- If open_automatic is true, focusing an ignored window/buffer will not
        -- -- cause an aerial window to open.
        -- -- If open_automatic is a function, ignore rules have no effect on aerial
        -- -- window opening behavior; it's entirely handled by the open_automatic
        -- -- function.
        -- ignore = {
        --     -- Ignore unlisted buffers. See :help buflisted
        --     unlisted_buffers = true,
        --
        --     -- List of filetypes to ignore.
        --     filetypes = {},
        --
        --     -- Ignored buftypes.
        --     -- Can be one of the following:
        --     -- false or nil - No buftypes are ignored.
        --     -- "special"    - All buffers other than normal buffers are ignored.
        --     -- table        - A list of buftypes to ignore. See :help buftype for the
        --     --                possible values.
        --     -- function     - A function that returns true if the buffer should be
        --     --                ignored or false if it should not be ignored.
        --     --                Takes two arguments, `bufnr` and `buftype`.
        --     buftypes = "special",
        --
        --     -- Ignored wintypes.
        --     -- Can be one of the following:
        --     -- false or nil - No wintypes are ignored.
        --     -- "special"    - All windows other than normal windows are ignored.
        --     -- table        - A list of wintypes to ignore. See :help win_gettype() for the
        --     --                possible values.
        --     -- function     - A function that returns true if the window should be
        --     --                ignored or false if it should not be ignored.
        --     --                Takes two arguments, `winid` and `wintype`.
        --     wintypes = "special",
        -- },

        -- Use symbol tree for folding. Set to true or false to enable/disable
        -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
        -- This can be a filetype map (see :help aerial-filetype-map)
        -- manage_folds = "auto",
        manage_folds = false,

        -- When you fold code with za, zo, or zc, update the aerial tree as well.
        -- Only works when manage_folds = true
        link_folds_to_tree = false,

        -- Fold code when you open/collapse symbols in the tree.
        -- Only works when manage_folds = true
        link_tree_to_folds = true,

        -- -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
        -- -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
        nerd_font = true,
        --
        -- -- Call this function when aerial attaches to a buffer.
        -- on_attach = function(bufnr) end,
        --
        -- -- Call this function when aerial first sets symbols on a buffer.
        -- on_first_symbols = function(bufnr) end,
        --
        -- -- Automatically open aerial when entering supported buffers.
        -- -- This can be a function (see :help aerial-open-automatic)
        -- open_automatic = false,
        open_automatic = function()
            return false
            -- local aerial = require "aerial"
            -- return aerial.num_symbols() > 1 and not aerial.was_closed()
        end,

        --
        -- -- Run this command after jumping to a symbol (false will disable)
        -- post_jump_cmd = "normal! zz",
        --
        -- -- When true, aerial will automatically close after jumping to a symbol
        close_on_select = false,
        --
        -- -- The autocmds that trigger symbols update (not used for LSP backend)
        -- update_events = "TextChanged,InsertLeave",
        --
        -- -- Show box drawing characters for the tree hierarchy
        show_guides = true,
        --
        -- -- Customize the characters used when show_guides = true
        -- guides = {
        --     -- When the child item has a sibling below it
        --     mid_item = "├─",
        --     -- When the child item is the last in the list
        --     last_item = "└─",
        --     -- When there are nested child guides to the right
        --     nested_top = "│ ",
        --     -- Raw indentation
        --     whitespace = "  ",
        -- },

        -- Options for opening aerial in a floating win
        float = {
            -- Controls border appearance. Passed to nvim_open_win
            border = "rounded",

            -- Determines location of floating window
            --   cursor - Opens float on top of the cursor
            --   editor - Opens float centered in the editor
            --   win    - Opens float centered in the window
            relative = "win",

            -- These control the height of the floating window.
            -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_height and max_height can be a list of mixed types.
            -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
            max_height = 0.4,
            height = nil,
            min_height = 8,

            override = function(conf, source_winid)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout

                -- vim.print { conf = conf, source_winid = source_winid }

                -- telescope の floating window の下に出るようにする
                conf.zindex = 49
                conf.anchor = "SE"
                conf.col = vim.fn.winwidth(source_winid)
                conf.row = vim.fn.winheight(source_winid)
                return conf
            end,
        },

        -- lsp = {
        --     -- Fetch document symbols when LSP diagnostics update.
        --     -- If false, will update on buffer changes.
        --     diagnostics_trigger_update = true,
        --
        --     -- Set to false to not update the symbols when there are LSP errors
        --     update_when_errors = true,
        --
        --     -- How long to wait (in ms) after a buffer change before updating
        --     -- Only used when diagnostics_trigger_update = false
        --     update_delay = 300,
        -- },
        --
        -- treesitter = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
        --
        -- markdown = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
        --
        -- man = {
        --     -- How long to wait (in ms) after a buffer change before updating
        --     update_delay = 300,
        -- },
    },
}

plugins:push {
    "https://github.com/stevearc/oil.nvim",
    -- `vim <dir>` のときも自動で開いてほしい
    lazy = false,
    keys = {
        "gf",
        "sf",
        "sF",
        "sc",
    },
    cmd = {
        "Oil",
    },
    config = function()
        local oil = require("oil")

        local sort_rules = {
            {
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
                columns = {
                    "icon",
                },
            },
            {
                sort = {
                    -- { "type", "asc" },
                    { "mtime", "desc" },
                    { "name", "asc" },
                },
                columns = {
                    { "mtime", format = "%Y-%m-%d %H:%M:%S", highlight = "@number" },
                    "icon",
                },
            },
        }
        local default_rule_idx = 1

        local function change_sort_by_rule()
            default_rule_idx = default_rule_idx % #sort_rules + 1
            local rule = sort_rules[default_rule_idx]
            oil.set_columns(rule.columns)
            oil.set_sort(rule.sort)
        end

        require("oil").setup {
            -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
            -- Set to false if you still want to use netrw.
            default_file_explorer = true,
            -- Id is automatically added at the beginning, and name at the end
            -- See :help oil-columns
            columns = {
                -- { "mtime", format = "%m/%d %H:%M", highlight = "@field" },
                "icon",
                -- "permissions",
                -- "size",
                -- "mtime",
            },
            -- Buffer-local options to use for oil buffers
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            -- Window-local options to use for oil buffers
            win_options = {
                wrap = false,
                signcolumn = "yes:2",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
            delete_to_trash = true,
            -- Skip the confirmation popup for simple operations
            skip_confirm_for_simple_edits = false,
            -- Change this to customize the command used when deleting to trash
            -- trash_command = "trash-put",
            -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
            prompt_save_on_select_new_entry = true,
            -- Oil will automatically delete hidden buffers after this delay
            -- You can set the delay to false to disable cleanup entirely
            -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
            cleanup_delay_ms = false,
            -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
            -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
            -- Additionally, if it is a string that matches "actions.<name>",
            -- it will use the mapping at require("oil.actions").<name>
            -- Set to `false` to remove a keymap
            -- See :help oil-actions for a list of all available actions
            keymaps = {
                ["?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-p>"] = "actions.preview",
                ["M"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                -- ["<C-l>"] = "actions.refresh",
                ["H"] = "actions.parent",
                ["L"] = {
                    callback = function()
                        local actions = require("oil.actions")
                        local entry = require("oil").get_cursor_entry()
                        local preview_win = require("oil.util").get_preview_win()

                        if entry == nil then
                            return
                        end

                        local is_dir_or_dirlink = entry.type == "directory"
                            or (entry.type == "link" and entry.meta.link_stat.type == "directory")

                        if not is_dir_or_dirlink then
                            return
                        end

                        actions.select.callback()

                        if preview_win ~= nil then
                            -- actions.select の時点で preview が消えてしまうため、
                            -- preview が出ていたときは preview window を出しなおす
                            actions.preview.callback()
                        end
                    end,
                    desc = "Right move",
                },
                ["gs"] = {
                    callback = change_sort_by_rule,
                    desc = "Change sort by pre-defined rules",
                },
                ["gS"] = "actions.change_sort",
                ["<Space><CR>"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = false,
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = false,
                -- This function defines what is considered a "hidden" file
                is_hidden_file = function(name, bufnr)
                    return vim.tbl_contains({
                        "__pycache__",
                        ".mypy_cache",
                        ".pytest_cache",
                        ".ruff_cache",
                        ".DS_Store",
                        "..",
                    }, name)
                end,
                -- This function defines what will never be shown, even when `show_hidden` is set
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                -- Sort file names in a more intuitive order for humans. Is less performant,
                -- so you may want to set to false if you work with large directories.
                natural_order = true,
                sort = {
                    -- sort order can be "asc" or "desc"
                    -- see :help oil-columns to see which columns are sortable
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
            -- Configuration for the floating window in oil.open_float
            float = {
                -- Padding around the floating window
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                override = function(conf)
                    return conf
                end,
            },
            -- Configuration for the actions floating preview window
            preview = {
                -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a single value or a list of mixed integer/float types.
                -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
                max_width = 0.9,
                -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
                min_width = { 40, 0.4 },
                -- optionally define an integer/float for the exact width of the preview window
                width = nil,
                -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_height and max_height can be a single value or a list of mixed integer/float types.
                -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
                max_height = 0.9,
                -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
                min_height = { 5, 0.1 },
                -- optionally define an integer/float for the exact height of the preview window
                height = nil,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
            },
            -- Configuration for the floating progress window
            progress = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                width = nil,
                max_height = { 10, 0.9 },
                min_height = { 5, 0.1 },
                height = nil,
                border = "rounded",
                minimized_border = "none",
                win_options = {
                    winblend = 0,
                },
            },
        }
        -- vim.api.nvim_create_autocmd("User", {
        --     pattern = "OilEnter",
        --     callback = vim.schedule_wrap(function(args)
        --         local oil = require "oil"
        --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
        --             oil.select { preview = true }
        --         end
        --     end),
        -- })

        mapset.n("sf") {
            desc = [[cwd 上ファイルではそのファイルが有る場所を、それ以外は cwd を開く。]],
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:find("://") then
                    -- 特殊なバッファなので cwd にする
                    require("oil").open(vim.fn.getcwd())
                else
                    local dir_rel = vim.fn.fnamemodify(bufname, ":.")
                    if vim.startswith(dir_rel, "/") then
                        require("oil").open(vim.fn.getcwd())
                    else
                        require("oil").open()
                    end
                end
            end,
        }
        mapset.n("sF") {
            desc = [[そのファイルが有る場所を強制的に開く。]],
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:find("://") then
                    -- 特殊なバッファなので cwd にする
                    require("oil").open(vim.fn.getcwd())
                else
                    -- デフォルトの挙動に fallback
                    require("oil").open()
                end
            end,
        }
        mapset.n("sc") {
            desc = [[カレントディレクトリを開く。]],
            function()
                require("oil").open(vim.fn.getcwd())
            end,
        }
    end,
}

plugins:push {
    "https://github.com/refractalize/oil-git-status.nvim",
    lazy = true,
    dependencies = {
        "stevearc/oil.nvim",
    },

    config = function()
        require("oil-git-status").setup {
            show_ignored = false, -- show files that match gitignore with !!
        }
    end,
}

return plugins:collect()

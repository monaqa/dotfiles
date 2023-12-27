local util = require "rc.util"
local vec = require "rc.util.vec"

local plugins = vec {}
-- telescope
plugins:push {
    "https://github.com/nvim-telescope/telescope.nvim",
    dependencies = {
        "https://github.com/fannheyward/telescope-coc.nvim",
        "https://github.com/nvim-telescope/telescope-smart-history.nvim",
        "https://github.com/kkharji/sqlite.lua",
        "https://github.com/fdschmidt93/telescope-egrepify.nvim",
    },
    cmd = { "Telescope" },
    keys = {
        {
            "so",
            function()
                local builtin = require "telescope.builtin"
                builtin.git_files { prompt_prefix = "𝝋" }
            end,
        },
        {
            "sO",
            function()
                local builtin = require "telescope.builtin"
                builtin.find_files { prompt_prefix = "𝝋" }
            end,
        },
        {
            "sb",
            function()
                local builtin = require "telescope.builtin"
                builtin.buffers { prompt_prefix = "𝜷" }
            end,
        },
        {
            "sg",
            function()
                -- local builtin = require "telescope.builtin"
                -- builtin.live_grep { prompt_prefix = "𝜸" }
                require("telescope").extensions.egrepify.egrepify {
                    prompt_prefix = "𝜸",
                }
            end,
        },
        {
            "tq",
            function()
                local builtin = require "telescope.builtin"
                builtin.quickfix { prompt_prefix = "𝝄" }
            end,
        },
        -- {
        --     "si",
        --     function()
        --         local extensions = require("telescope").extensions
        --         extensions.frecency.frecency { prompt_prefix = "𝑓", workspace = "CWD" }
        --     end,
        -- },
    },
    config = function()
        local actions = require "telescope.actions"

        require("telescope").load_extension "coc"
        require("telescope").load_extension "smart_history"
        require("telescope").load_extension "egrepify"
        -- require("telescope").load_extension "frecency"

        -- manage database history
        local db_dir = vim.fn.stdpath "data" .. "/databases"
        if not util.to_bool(vim.fn.isdirectory(db_dir)) then
            vim.fn.mkdir(db_dir, "p")
        end

        util.autocmd_vimrc "FileType" {
            pattern = "TelescopePrompt",
            callback = function()
                -- vim.b.lexima_disabled = 1

                -- なぜか lexima が <Esc><Esc> という mapping をはやしてしまうため
                -- それより優先度の高いマッピングを入れておく
                -- vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = true, nowait = true })
                -- vim.keymap.set("n", "<Plug>(telescopt-scroll-f)", function()
                --     actions.move_selection_next(0)
                -- end, { buffer = true, nowait = true })
                -- vim.keymap.set("n", "<Plug>(telescopt-scroll-b)", function()
                --     actions.move_selection_previous(0)
                -- end, { buffer = true, nowait = true })
            end,
        }

        -- Global remapping
        require("telescope").setup {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--line-number",
                    "--no-heading",
                    "--color=never",
                    "--hidden",
                    "--with-filename",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "𝜻",
                find_command = {
                    "rg",
                    "--ignore",
                    "--hidden",
                    "--files",
                },
                mappings = {
                    n = {
                        ["<Esc>"] = actions.close,
                        -- ["<C-f>"] = function(prompt_buffer)
                        --     -- actions.move_selection_next(prompt_buffer)
                        --     vim.fn["smooth_scroll#flick"](
                        --         vim.v.count1 * vim.fn.winheight(0),
                        --         20,
                        --         "<Plug>(telescope-scroll-f)",
                        --         "<Plug>(telescope-scroll-b)"
                        --     )
                        -- end,
                    },
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-f>"] = false,
                    },
                },
                history = {
                    path = db_dir .. "/telescope_history.sqlite3",
                    limite = 100,
                },
                extensions = {
                    egrepify = {
                        prefixes = {
                            ["#"] = {
                                -- #$REMAINDER
                                -- # is caught prefix
                                -- `input` becomes $REMAINDER
                                -- in the above example #lua,md -> input: lua,md
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[*.{%s}]], input)
                                end,
                            },
                            -- filter for (partial) folder names
                            -- example prompt: >conf $MY_PROMPT
                            -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
                            -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
                            [">"] = {
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[**/{%s}*/**]], input)
                                end,
                            },
                            -- filter for (partial) file names
                            -- example prompt: &egrep $MY_PROMPT
                            -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
                            -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
                            ["&"] = {
                                flag = "glob",
                                cb = function(input)
                                    return string.format([[*{%s}*]], input)
                                end,
                            },
                        },
                        mappings = {
                            ["<C-z>"] = false,
                            ["<C-a>"] = false,
                            ["<C-r>"] = false,
                        },
                    },
                },
            },
        }
    end,
}

plugins:push {
    "https://github.com/fannheyward/telescope-coc.nvim",
    cmd = { "Telescope" },
    dependencies = { "https://github.com/neoclide/coc.nvim" },
}

plugins:push {
    "https://github.com/fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "https://github.com/nvim-lua/plenary.nvim" },
}

plugins:push { "https://github.com/nvim-lua/popup.nvim", lazy = true }

plugins:push { "https://github.com/nvim-lua/plenary.nvim", lazy = true }

return plugins:collect()

local vec = require("rc.util.vec")

local plugins = vec {}

-- denops
-- plugins:push {
--     "https://github.com/Shougo/ddu.vim",
--     dependencies = { "https://github.com/vim-denops/denops.vim" },
--     enabled = false,
--     config = function()
--         vim.keymap.set("n", "sm", function()
--             vim.fn["ddu#start"] {
--                 sources = {
--                     { name = "mr", params = { kind = "mru" } },
--                 },
--             }
--         end)
--
--         -- vim.keymap.set("n", "@o", function()
--         --     vim.fn["ddu#start"] {
--         --         sources = {
--         --             { name = "file_external", params = {} },
--         --         },
--         --     }
--         -- end)
--         --
--         -- vim.keymap.set("n", "@g", function()
--         --     vim.fn["ddu_rg#find"]()
--         -- end)
--
--         vim.fn["ddu#custom#patch_global"] {
--             ui = "ff",
--             uiParams = {
--                 ff = { split = "floating" },
--             },
--             sources = {
--                 { name = "file_rec", params = {} },
--             },
--             sourceOptions = {
--                 ["_"] = {
--                     matchers = { "matcher_substring" },
--                 },
--                 rg = {
--                     args = { "--column", "--no-heading", "--color", "never" },
--                 },
--             },
--             kindOptions = {
--                 file = { defaultAction = "open" },
--             },
--             sourceParams = {
--                 rg = {
--                     args = { "--column", "--no-heading", "--color", "--hidden" },
--                 },
--                 file_external = {
--                     cmd = { "fd", ".", "-H", "-E", "__pycache__", "-t", "f" },
--                 },
--             },
--         }
--
--         local function nmap_action(lhs, action)
--             vim.keymap.set(
--                 "n",
--                 lhs,
--                 [[<Cmd>call ddu#ui#ff#do_action(']] .. action .. [[')<CR>]],
--                 { buffer = true, silent = true }
--             )
--         end
--
--         util.autocmd_vimrc "FileType" {
--             pattern = "ddu-ff",
--             callback = function()
--                 nmap_action("<CR>", "itemAction")
--                 nmap_action("<Space>", "toggleSelectItem")
--                 nmap_action("i", "openFilterWindow")
--                 nmap_action("q", "quit")
--                 nmap_action("<Esc>", "quit")
--             end,
--         }
--
--         util.autocmd_vimrc "FileType" {
--             pattern = "ddu-ff-filter",
--             callback = function()
--                 vim.keymap.set("i", "<CR>", "<Esc><Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "<CR>", "<Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true })
--                 vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = true, silent = true })
--             end,
--         }
--     end,
-- }
-- plugins:push { "https://github.com/Shougo/ddu-filter-matcher_substring" }
-- plugins:push { "https://github.com/Shougo/ddu-kind-file" }
-- plugins:push { "https://github.com/Shougo/ddu-source-file_rec" }
-- plugins:push { "https://github.com/Shougo/ddu-ui-ff" }
-- plugins:push { "https://github.com/kuuote/ddu-source-mr" }
-- plugins:push { "https://github.com/lambdalisue/mr.vim", branch = "main" }
-- plugins:push { "https://github.com/matsui54/ddu-source-file_external" }
-- plugins:push { "https://github.com/shun/ddu-source-rg" }

plugins:push { "https://github.com/vim-denops/denops.vim", lazy = false }

-- plugins:push { "https://github.com/lambdalisue/guise.vim", lazy = false }

plugins:push {
    "https://github.com/4513ECHO/denops-gitter.vim",
    dependencies = { "https://github.com/vim-denops/denops.vim" },
    enabled = false,
    config = function()
        vim.g["gitter#token"] = vim.fn.getenv("GITTER_TOKEN")
    end,
}

plugins:push {
    "https://github.com/lambdalisue/kensaku.vim",
    lazy = false,
    dependencies = { "https://github.com/vim-denops/denops.vim" },
}

plugins:push {
    "https://github.com/gamoutatsumi/dps-ghosttext.vim",
    config = function()
        vim.g["dps_ghosttext#ftmap"] = {
            ["github.com"] = "markdown",
        }
    end,
}

return plugins:collect()

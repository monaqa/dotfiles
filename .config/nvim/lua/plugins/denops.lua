local vec = require("rc.util.vec")

local plugins = vec {}

plugins:push { "https://github.com/vim-denops/denops.vim", lazy = false }

plugins:push {
    "https://github.com/lambdalisue/kensaku.vim",
    lazy = false,
    dependencies = { "https://github.com/vim-denops/denops.vim" },
}

plugins:push {
    "https://github.com/gamoutatsumi/dps-ghosttext.vim",
    commit = "6d92d184de685b16ef8a334c2a892183c3846232",
    config = function()
        vim.g["dps_ghosttext#ftmap"] = {
            ["github.com"] = "markdown",
        }
    end,
}

return plugins:collect()

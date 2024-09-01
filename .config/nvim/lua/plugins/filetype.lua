local vec = require("rc.util.vec")

local plugins = vec {}

plugins:push { "https://github.com/bfontaine/Brewfile.vim", ft = { "brewfile" } }

plugins:push { "https://github.com/cespare/vim-toml", ft = { "toml" } }

plugins:push { "https://github.com/ekalinin/Dockerfile.vim", ft = { "dockerfile" } }

plugins:push { "https://github.com/evanleck/vim-svelte", ft = { "svelte" } }

plugins:push { "https://github.com/justinmk/vim-syntax-extra", ft = { "vim" } }

plugins:push { "https://github.com/othree/html5.vim", ft = { "html" } }

plugins:push { "https://github.com/pangloss/vim-javascript", ft = { "javascript" } }

plugins:push {
    "https://github.com/rust-lang/rust.vim",
    ft = { "rust" },
    config = function()
        -- なんかめちゃ重かった
        vim.g["rustfmt_autosave"] = 0
    end,
}

plugins:push { "https://github.com/vito-c/jq.vim", ft = { "jq" } }

plugins:push { "https://github.com/wlangstroth/vim-racket", ft = { "racket" } }

plugins:push { "https://github.com/terrastruct/d2-vim", ft = { "d2" } }

-- plugins:push {
--     "https://github.com/kaarmu/typst.vim",
--     ft = { "typst" },
--     -- ひとまず以下の issue が解決するまでは
--     -- https://github.com/kaarmu/typst.vim/issues/64
--     commit = "65f9e78c11829a643d1539f3481c0ff875c83603",
-- }

plugins:push { "https://github.com/mityu/vim-applescript", ft = { "applescript" } }

return plugins:collect()

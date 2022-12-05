local util = require "rc.util"
local config = require "rc.plugin_config"

local disable_plugins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}

for _, name in ipairs(disable_plugins) do
    vim.g["loaded_" .. name] = 1
end

vim.cmd [[
    packadd vim-jetpack
]]

local callbacks = {}
require("jetpack.packer").startup(function(use)
    ---`use` 関数を wrap して、hook 系が渡せるようにする。
    --- * hook_before: プラグインをロードする前に読み込む。ほとんど使わない。
    --- * hook_after: プラグインをロードした後に読み込む。
    --- * unless_cwd: 特定のディレクトリ上で Vim を開いたときは、そのプラグインを読み込まない。
    ---@param t {hook_before?: fun(), hook_after?: fun(), unless_cwd?: string}
    local function add(t)
        local packname = vim.fn.fnamemodify(t[1], ":t")
        if t.hook_before ~= nil then
            t.hook_before()
        end
        if t.unless_cwd ~= nil then
            t.opt = true
            table.insert(callbacks, function()
                if vim.fn.expand(t.unless_cwd) ~= vim.fn.getcwd() then
                    vim.cmd.packadd(packname)
                    if t.hook_after ~= nil then
                        t.hook_after()
                    end
                else
                    util.print_error(([[WARNING: package '%s' is not loaded.]]):format(packname), "WarningMsg")
                end
            end)
        elseif t.hook_after ~= nil then
            table.insert(callbacks, t.hook_after)
        end
        use(t)
    end

    -- bootstrap
    add { "tani/vim-jetpack", opt = 1 }

    -- general plugins
    -- add { "mhinz/vim-signify" }
    add { "Shougo/vimproc.vim" }
    add { "Vimjas/vim-python-pep8-indent" }
    add { "akinsho/bufferline.nvim", hook_after = config.bufferline }
    add { "glidenote/memolist.vim" }
    add { "haya14busa/vim-asterisk", hook_after = config.asterisk }
    add { "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", hook_after = config.markdown_preview }
    add { "itchyny/vim-qfedit" }
    add { "kana/vim-altr", hook_after = config.altr }
    add { "kkiyama117/zenn-vim" }
    add { "kyazdani42/nvim-web-devicons" }
    add { "lambdalisue/fern-hijack.vim" }
    add { "lambdalisue/fern-renderer-nerdfont.vim" }
    add { "lambdalisue/fern.vim", branch = "main", hook_after = config.fern }
    add { "lambdalisue/gina.vim", hook_after = config.gina }
    add { "lambdalisue/nerdfont.vim" }
    add { "lambdalisue/vim-protocol" }
    add { "lervag/vimtex", hook_after = config.vimtex }
    add { "lewis6991/gitsigns.nvim", hook_after = config.gitsigns }
    add { "mattn/emmet-vim", hook_after = config.emmet }
    add { "mattn/vim-maketable" }
    add { "mbbill/undotree", hook_after = config.undotree }
    add { "nvim-lualine/lualine.nvim", hook_after = config.lualine }
    add { "rhysd/rust-doc.vim", hook_after = config.rust_doc }
    add { "terrortylor/nvim-comment", hook_after = config.nvim_comment }
    add { "thinca/vim-qfreplace" }
    add { "thinca/vim-quickrun" }
    add { "tpope/vim-capslock", hook_after = config.capslock }
    add { "tyru/capture.vim" }
    add { "tyru/open-browser.vim", hook_after = config.open_browser }
    add { "uga-rosa/ccc.nvim", hook_after = config.ccc }
    add { "xolox/vim-misc" }
    add { "xolox/vim-session", hook_after = config.session }
    -- add { "stevearc/aerial.nvim", hook_after = config.aerial, opt = true }
    add {
        "stevearc/aerial.nvim",
        unless_cwd = "~/ghq/github.com/stevearc/aerial.nvim",
        hook_after = config.aerial,
    }

    -- colorscheme
    add { "habamax/vim-gruvbit", hook_after = config.gruvbit }
    add { "yasukotelin/shirotelin", opt = true }

    -- paren
    add { "cohama/lexima.vim", hook_after = config.lexima }
    add { "machakann/vim-sandwich", hook_after = config.sandwich }
    add { "andymass/vim-matchup", hook_after = config.matchup }

    -- textedit
    add { "bps/vim-textobj-python" }
    add { "glts/vim-textobj-comment", hook_after = config.textobj_comment }
    add { "kana/vim-operator-replace", hook_after = config.operator_replace }
    add { "kana/vim-operator-user" }
    add { "kana/vim-textobj-entire", hook_after = config.textobj_entire }
    add { "kana/vim-textobj-user", hook_after = config.textobj_user }
    add { "machakann/vim-swap", hook_after = config.swap }
    add { "machakann/vim-textobj-functioncall", hook_after = config.textobj_functioncall }

    -- coc
    add { "neoclide/coc.nvim", branch = "release", hook_after = config.coc }
    add { "rafcamlet/coc-nvim-lua" }

    -- telescope
    add { "nvim-telescope/telescope.nvim", hook_after = config.telescope }
    add { "nvim-lua/popup.nvim" }
    add { "nvim-lua/plenary.nvim" }
    add { "fannheyward/telescope-coc.nvim" }

    -- denops
    add { "Shougo/ddu.vim", hook_after = config.ddu }
    add { "Shougo/ddu-filter-matcher_substring" }
    add { "Shougo/ddu-kind-file" }
    add { "Shougo/ddu-source-file_rec" }
    add { "Shougo/ddu-ui-ff" }
    add { "kuuote/ddu-source-mr" }
    add { "lambdalisue/mr.vim", branch = "main" }
    add { "matsui54/ddu-source-file_external" }
    add { "shun/ddu-source-rg" }
    add { "vim-denops/denops.vim" }
    add { "4513ECHO/denops-gitter.vim", hook_after = config.denops_gitter, opt = true }

    -- tree-sitter
    add { "nvim-treesitter/nvim-treesitter", hook_after = config.treesitter }
    add { "nvim-treesitter/playground" }
    add { "mfussenegger/nvim-treehopper", hook_after = config.treehopper }

    -- filetype
    -- add { "abhishekmukherg/xonsh-vim" }
    -- add { "jsborjesson/vim-uppercase-sql" }
    add { "JuliaEditorSupport/julia-vim" }
    add { "aklt/plantuml-syntax" }
    add { "bfontaine/Brewfile.vim" }
    add { "cespare/vim-toml" }
    add { "chr4/nginx.vim" }
    add { "ekalinin/Dockerfile.vim" }
    add { "evanleck/vim-svelte" }
    add { "justinmk/vim-syntax-extra" }
    add { "ocaml/vim-ocaml" }
    add { "othree/html5.vim" }
    add { "pangloss/vim-javascript" }
    add { "pest-parser/pest.vim" }
    -- add { "preservim/vim-markdown", hook_after = config.markdown }
    add { "rust-lang/rust.vim", hook_after = config.rust }
    add { "vim-python/python-syntax", hook_after = config.python }
    add { "vito-c/jq.vim" }
    add { "wlangstroth/vim-racket" }

    -- monaqa
    add { "monaqa/colordinate.vim", opt = true }
    add {
        "monaqa/dial.nvim",
        unless_cwd = "~/ghq/github.com/monaqa/dial.nvim",
        hook_after = config.dial,
    }
    add { "monaqa/modesearch.vim", hook_after = config.modesearch }
    add { "monaqa/peridot.vim" }
    add { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim", hook_after = config.pretty_fold }
    -- add{"monaqa/satysfi.vim"}
    add { "monaqa/smooth-scroll.vim", hook_after = config.smooth_scroll }
    add { "monaqa/vim-edgemotion" }
    add {
        "monaqa/vim-partedit",
        unless_cwd = "~/ghq/github.com/monaqa/vim-partedit",
        branch = "feat-prefix_pattern",
        opt = true,
        hook_after = config.partedit,
    }
    -- add { "thinca/vim-partedit", hook_after = config.partedit }
end)

for _, name in ipairs(vim.fn["jetpack#names"]()) do
    if not util.to_bool(vim.fn["jetpack#tap"](name)) then
        vim.fn["jetpack#sync"]()
        return false
    end
end

for _, callback in ipairs(callbacks) do
    callback()
end

return true

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

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = {
    dev = {
        -- directory where you store your local plugin projects
        path = "~/ghq/github.com/",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = { "monaqa" }, -- For example {"folke"}
        fallback = false, -- Fallback to git when local plugin doesn't exist
    },
}

local function cond_dev(plug_path)
    return vim.fn.getcwd() == vim.fn.expand "~/ghq/github.com/" .. plug_path
end

local function add(tbl)
    table.insert(lazy_config, tbl)
end

-- add { "Shougo/vimproc.vim" }
add { "Vimjas/vim-python-pep8-indent" }
add { "akinsho/bufferline.nvim", config = config.bufferline }
add { "glidenote/memolist.vim" }
add { "haya14busa/vim-asterisk", config = config.asterisk }
add { "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", config = config.markdown_preview }
add { "itchyny/vim-qfedit" }
add { "kana/vim-altr", config = config.altr }
add { "kkiyama117/zenn-vim" }
add { "kyazdani42/nvim-web-devicons" }
add { "lambdalisue/fern-hijack.vim" }
add { "lambdalisue/fern-git-status.vim" }
-- add { "lambdalisue/fern-mapping-git.vim" }
add { "lambdalisue/fern-renderer-nerdfont.vim", dependencies = { "fern.vim" } }
add { "lambdalisue/fern.vim", branch = "main", config = config.fern }
add { "lambdalisue/gina.vim", config = config.gina }
add { "lambdalisue/nerdfont.vim" }
add { "lambdalisue/vim-protocol" }
add { "lervag/vimtex", config = config.vimtex }
add { "lewis6991/gitsigns.nvim", config = config.gitsigns }
add { "mattn/emmet-vim", config = config.emmet }
add { "mattn/vim-maketable" }
add { "mbbill/undotree", config = config.undotree }
add { "nvim-lualine/lualine.nvim", config = config.lualine }
add { "rhysd/rust-doc.vim", config = config.rust_doc }
add { "ryicoh/deepl.vim", config = config.deepl }
add { "terrortylor/nvim-comment", config = config.nvim_comment }
add { "thinca/vim-qfreplace" }
add { "thinca/vim-quickrun" }
add { "tpope/vim-capslock", config = config.capslock }
add { "tyru/capture.vim" }
add { "tyru/open-browser.vim", config = config.open_browser }
add { "uga-rosa/ccc.nvim", config = config.ccc }
add { "xolox/vim-misc" }
add { "xolox/vim-session", config = config.session, dependencies = { "vim-misc" } }
add {
    "stevearc/aerial.nvim",
    unless_cwd = "~/ghq/github.com/stevearc/aerial.nvim",
    config = config.aerial,
}
add {
    "thinca/vim-partedit",
    unless_cwd = "~/ghq/github.com/monaqa/vim-partedit",
    config = config.partedit,
}

add {
    "atusy/tsnode-marker.nvim",
    config = config.tsnode_marker,
}

-- colorscheme
add { "habamax/vim-gruvbit", config = config.gruvbit }
add { "yasukotelin/shirotelin", opt = true }

-- paren
add { "cohama/lexima.vim", config = config.lexima, lazy = 1, event = "InsertEnter" }
add { "machakann/vim-sandwich", config = config.sandwich }
add { "andymass/vim-matchup", config = config.matchup }

-- textedit
add { "kana/vim-operator-replace", config = config.operator_replace, dependencies = { "vim-operator-user" } }
add { "kana/vim-operator-user" }

add { "bps/vim-textobj-python", dependencies = { "vim-textobj-user" } }
add { "glts/vim-textobj-comment", config = config.textobj_comment, dependencies = { "vim-textobj-user" } }
add { "kana/vim-textobj-entire", config = config.textobj_entire, dependencies = { "vim-textobj-user" } }
add { "machakann/vim-textobj-functioncall", config = config.textobj_functioncall, dependencies = { "vim-textobj-user" } }
add { "kana/vim-textobj-user", config = config.textobj_user }

add { "machakann/vim-swap", config = config.swap }

-- coc
add { "neoclide/coc.nvim", branch = "release", config = config.coc }
-- add { "rafcamlet/coc-nvim-lua" }

-- nvim_lsp

-- add { "neovim/nvim-lspconfig", opt = 1, config = config.nvim_lsp }
-- add { "williamboman/mason.nvim", opt = 1 }
-- add { "williamboman/mason-lspconfig.nvim", opt = 1 }
-- add { "hrsh7th/nvim-cmp", opt = 1 }
-- add { "hrsh7th/cmp-nvim-lsp", opt = 1 }
-- add { "hrsh7th/cmp-vsnip", opt = 1 }
-- add { "hrsh7th/cmp-buffer", opt = 1 }
-- add { "hrsh7th/cmp-path", opt = 1 }
-- add { "hrsh7th/cmp-cmdline", opt = 1 }
-- add { "hrsh7th/vim-vsnip", opt = 1 }
-- add { "folke/neodev.nvim", opt = 1 }

-- telescope
add {
    "nvim-telescope/telescope.nvim",
    config = config.telescope,
    -- dependencies = {
    --     "fannheyward/telescope-coc.nvim",
    -- },
}
add { "fannheyward/telescope-coc.nvim", dependencies = { "nvim-telescope/telescope.nvim" } }
add { "nvim-lua/popup.nvim" }
add { "nvim-lua/plenary.nvim" }

-- denops
add { "Shougo/ddu.vim", config = config.ddu }
add { "Shougo/ddu-filter-matcher_substring" }
add { "Shougo/ddu-kind-file" }
add { "Shougo/ddu-source-file_rec" }
add { "Shougo/ddu-ui-ff" }
add { "kuuote/ddu-source-mr" }
add { "lambdalisue/mr.vim", branch = "main" }
add { "matsui54/ddu-source-file_external" }
add { "shun/ddu-source-rg" }
add { "vim-denops/denops.vim" }
add { "4513ECHO/denops-gitter.vim", config = config.denops_gitter, enabled = false }
add { "lambdalisue/kensaku.vim" }

-- tree-sitter
add { "nvim-treesitter/nvim-treesitter", config = config.treesitter }
add { "nvim-treesitter/playground" }
add { "mfussenegger/nvim-treehopper", config = config.treehopper }

-- filetype
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
add { "rust-lang/rust.vim", config = config.rust }
add { "vim-python/python-syntax", config = config.python }
add { "vito-c/jq.vim" }
add { "wlangstroth/vim-racket" }
add { "terrastruct/d2-vim" }

-- monaqa
add { "monaqa/colordinate.vim", enabled = false }
add {
    "monaqa/dial.nvim",
    dev = cond_dev "monaqa/dial.nvim",
    -- enabled = function()
    --     if vim.fn.getcwd() == vim.fn.expand "~/ghq/github.com/monaqa/dial.nvim" then
    --         util.print_error("dial.nvim is not loaded.", "WarningMsg")
    --         return false
    --     end
    --     return true
    -- end,
    config = config.dial,
}
add {
    "monaqa/modesearch.nvim",
    dev = cond_dev "monaqa/modesearch.nvim",
    config = config.modesearch,
}
add { "monaqa/peridot.vim" }
add { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim", config = config.pretty_fold }
add { "monaqa/smooth-scroll.vim", config = config.smooth_scroll }
add { "monaqa/vim-edgemotion" }
add {
    "monaqa/nvim-treesitter-clipping",
    dev = cond_dev "monaqa/nvim-treesitter-clipping",
    config = config.clipping,
    -- unless_cwd = "~/ghq/github.com/monaqa/nvim-treesitter-clipping",
}

require("lazy").setup(lazy_config)

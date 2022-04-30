require("jetpack").startup(
function(use)

    -- general plugins
    use"machakann/vim-sandwich"
    use"Shougo/vimproc.vim"
    use"Vimjas/vim-python-pep8-indent"
    use"bps/vim-textobj-python"
    use"cohama/lexima.vim"
    use"glidenote/memolist.vim"
    use"glts/vim-textobj-comment"
    use"habamax/vim-gruvbit"
    use"haya14busa/vim-asterisk"
    use"itchyny/vim-qfedit"
    use{"iamcco/markdown-preview.nvim", ["do"] = 'packloadall! | call mkdp#util#install()'}
    use"kana/vim-altr"
    use"kana/vim-operator-user"
    use"kana/vim-textobj-user"
    use"kkiyama117/zenn-vim"
    use"kyazdani42/nvim-web-devicons"
    use"lambdalisue/fern-hijack.vim"
    use"lambdalisue/fern-renderer-nerdfont.vim"
    use"lambdalisue/fern.vim"
    use"lambdalisue/gina.vim"
    use"lambdalisue/nerdfont.vim"
    use"lervag/vimtex"
    use"liuchengxu/vista.vim"
    use"machakann/vim-sandwich"
    use"machakann/vim-swap"
    use"machakann/vim-textobj-functioncall"
    use"mattn/vim-maketable"
    use"mbbill/undotree"
    use"mhinz/vim-signify"
    use{"neoclide/coc.nvim", branch = "release"}
    use"rafcamlet/coc-nvim-lua"
    use"nvim-lualine/lualine.nvim"
    use"rhysd/rust-doc.vim"
    use"romgrk/barbar.nvim"
    use"thinca/vim-qfreplace"
    use"thinca/vim-quickrun"
    use"thinca/vim-submode"
    use"tpope/vim-capslock"
    use"tyru/capture.vim"
    use"tyru/caw.vim"
    use"tyru/open-browser.vim"
    use"xolox/vim-misc"
    use"xolox/vim-session"
    use{"yasukotelin/shirotelin", opt = true}
    use"powerman/vim-plugin-AnsiEsc"

    -- telescope
    use"nvim-lua/popup.nvim"
    use"nvim-lua/plenary.nvim"
    use"nvim-telescope/telescope.nvim"
    use"fannheyward/telescope-coc.nvim"

    -- denops
    use"vim-denops/denops.vim"
    use"Shougo/ddu.vim"
    use"Shougo/ddu-ui-ff"
    use"Shougo/ddu-source-file_rec"
    use"matsui54/ddu-source-file_external"
    use"shun/ddu-source-rg"
    use"kuuote/ddu-source-mr"
    use"lambdalisue/mr.vim"
    use"Shougo/ddu-filter-matcher_substring"
    use"Shougo/ddu-kind-file"

    -- tree-sitter
    use"nvim-treesitter/nvim-treesitter"
    use"nvim-treesitter/playground"
    use"sainnhe/gruvbox-material"

    -- filetype
    use"JuliaEditorSupport/julia-vim"
    use"cespare/vim-toml"
    use"ekalinin/Dockerfile.vim"
    use"leafgarland/typescript-vim"
    use"pangloss/vim-javascript"
    use"ocaml/vim-ocaml"
    use"pest-parser/pest.vim"
    use"rust-lang/rust.vim"
    use"vim-python/python-syntax"
    use"wlangstroth/vim-racket"
    use"aklt/plantuml-syntax"
    use"bfontaine/Brewfile.vim"
    use"chr4/nginx.vim"
    use"vito-c/jq.vim"

    -- monaqa
    use{"monaqa/dial.nvim", opt = true}
    use"monaqa/peridot.vim"
    use"monaqa/satysfi.vim"
    use"monaqa/smooth-scroll.vim"
    use"monaqa/vim-edgemotion"
    use"monaqa/modesearch.vim"
    use"monaqa/colordinate.vim"
    use{"monaqa/pretty-fold.nvim", branch = "for_stable_neovim"}
    use{"monaqa/vim-partedit", branch = "feat-prefix_pattern"}

end
)

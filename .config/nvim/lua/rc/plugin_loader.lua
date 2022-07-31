-- vim:fdm=marker:fmr=§§,■■

local util = require("rc.util")

require("jetpack").startup(
function(use)

    -- general plugins
    use{"Shougo/vimproc.vim"}
    use{"Vimjas/vim-python-pep8-indent"}
    use{"bps/vim-textobj-python"}
    use{"glidenote/memolist.vim"}
    use{"glts/vim-textobj-comment"}
    use{"habamax/vim-gruvbit"}
    use{"haya14busa/vim-asterisk"}
    use{"iamcco/markdown-preview.nvim", ["do"] = 'packloadall! | call mkdp#util#install()'}
    use{"itchyny/vim-qfedit"}
    use{"kana/vim-altr"}
    use{"kana/vim-operator-user"}
    use{"kana/vim-textobj-user"}
    use{"kkiyama117/zenn-vim"}
    use{"kyazdani42/nvim-web-devicons"}
    use{"lambdalisue/fern-hijack.vim"}
    use{"lambdalisue/fern-renderer-nerdfont.vim"}
    use{"lambdalisue/fern.vim", branch = "main"}
    use{"lambdalisue/gina.vim"}
    use{"lambdalisue/nerdfont.vim"}
    use{"lervag/vimtex"}
    use{"liuchengxu/vista.vim"}
    use{"machakann/vim-sandwich"}
    use{"machakann/vim-swap"}
    use{"machakann/vim-textobj-functioncall"}
    use{"mattn/vim-maketable"}
    use{"mattn/emmet-vim"}
    use{"mbbill/undotree"}
    use{"mhinz/vim-signify"}
    use{"nvim-lualine/lualine.nvim"}
    use{"nvim-neorg/neorg"}
    use{"powerman/vim-plugin-AnsiEsc"}
    use{"rhysd/rust-doc.vim"}
    use{"romgrk/barbar.nvim"}
    use{"thinca/vim-qfreplace"}
    use{"thinca/vim-quickrun"}
    use{"thinca/vim-submode"}
    use{"tpope/vim-capslock"}
    use{"tyru/capture.vim"}
    use{"tyru/caw.vim"}
    use{"tyru/open-browser.vim"}
    use{"xolox/vim-misc"}
    use{"xolox/vim-session"}
    use{"yasukotelin/shirotelin", opt = true}
    use{"kana/vim-textobj-entire"}
    use{"andymass/vim-matchup"}

    -- paren
    use{"cohama/lexima.vim"}
    use{"machakann/vim-sandwich"}

    -- coc
    use{"neoclide/coc.nvim", branch = "release"}
    use{"rafcamlet/coc-nvim-lua"}

    -- telescope
    use{"nvim-telescope/telescope.nvim"}
    use{"nvim-lua/popup.nvim"}
    use{"nvim-lua/plenary.nvim"}
    use{"fannheyward/telescope-coc.nvim"}

    -- denops
    use{"Shougo/ddu.vim"}
    use{"Shougo/ddu-filter-matcher_substring"}
    use{"Shougo/ddu-kind-file"}
    use{"Shougo/ddu-source-file_rec"}
    use{"Shougo/ddu-ui-ff"}
    use{"kuuote/ddu-source-mr"}
    use{"lambdalisue/mr.vim"}
    use{"matsui54/ddu-source-file_external"}
    use{"shun/ddu-source-rg"}
    use{"vim-denops/denops.vim"}

    -- tree-sitter
    use{"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use{"nvim-treesitter/playground"}
    use{"sainnhe/gruvbox-material"}

    -- filetype
    use{"JuliaEditorSupport/julia-vim"}
    use{"aklt/plantuml-syntax"}
    use{"bfontaine/Brewfile.vim"}
    use{"cespare/vim-toml"}
    use{"chr4/nginx.vim"}
    use{"ekalinin/Dockerfile.vim"}
    use{"evanleck/vim-svelte"}
    use{"leafgarland/typescript-vim"}
    use{"ocaml/vim-ocaml"}
    use{"pangloss/vim-javascript"}
    use{"pest-parser/pest.vim"}
    -- use{"qnighy/satysfi.vim"}
    use{"rust-lang/rust.vim"}
    use{"vim-python/python-syntax"}
    use{"vito-c/jq.vim"}
    use{"wlangstroth/vim-racket"}
    use{"othree/html5.vim"}
    use{"preservim/vim-markdown"}
    use{"justinmk/vim-syntax-extra"}

    -- monaqa
    use{"monaqa/colordinate.vim", opt = true}
    use{"monaqa/dial.nvim", opt = true}
    use{"monaqa/modesearch.vim"}
    use{"monaqa/peridot.vim"}
    use{"monaqa/pretty-fold.nvim", branch = "for_stable_neovim"}
    -- use{"monaqa/satysfi.vim"}
    use{"monaqa/smooth-scroll.vim"}
    use{"monaqa/vim-edgemotion"}
    use{"monaqa/vim-partedit", branch = "feat-prefix_pattern"}

end
)

for _, name in ipairs(vim.fn["jetpack#names"]()) do
    if not util.to_bool(vim.fn["jetpack#tap"](name)) then
        vim.fn["jetpack#sync"]()
        return false
    end
end

return true

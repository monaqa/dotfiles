let s:script = expand('<sfile>')

function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " call minpac#add('kevinhwang91/nvim-hlslens')
  call minpac#add('Konfekt/FastFold')
  call minpac#add('Shougo/vimproc.vim')
  call minpac#add('Vimjas/vim-python-pep8-indent')
  call minpac#add('bps/vim-textobj-python')
  call minpac#add('cohama/lexima.vim')
  call minpac#add('glidenote/memolist.vim')
  call minpac#add('glts/vim-textobj-comment')
  call minpac#add('habamax/vim-gruvbit')
  call minpac#add('haya14busa/vim-asterisk')
  call minpac#add('itchyny/vim-qfedit')
  call minpac#add('kana/vim-altr')
  call minpac#add('kana/vim-operator-user')
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('kkiyama117/zenn-vim')
  call minpac#add('kyazdani42/nvim-web-devicons')
  call minpac#add('lambdalisue/fern-hijack.vim')
  call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
  call minpac#add('lambdalisue/fern.vim')
  call minpac#add('lambdalisue/gina.vim')
  call minpac#add('lambdalisue/nerdfont.vim')
  call minpac#add('lervag/vimtex')
  call minpac#add('liuchengxu/vista.vim')
  call minpac#add('machakann/vim-sandwich')
  call minpac#add('machakann/vim-swap')
  call minpac#add('machakann/vim-textobj-functioncall')
  call minpac#add('mattn/vim-maketable')
  call minpac#add('mattn/vim-sonictemplate')
  call minpac#add('mbbill/undotree')
  call minpac#add('mhinz/vim-signify')
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
  call minpac#add('nvim-lualine/lualine.nvim')
  call minpac#add('previm/previm')
  call minpac#add('rafcamlet/coc-nvim-lua')
  call minpac#add('rhysd/rust-doc.vim')
  call minpac#add('romgrk/barbar.nvim')
  call minpac#add('thinca/vim-qfreplace')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('thinca/vim-submode')
  call minpac#add('tpope/vim-capslock')
  call minpac#add('tyru/capture.vim')
  call minpac#add('tyru/caw.vim')
  call minpac#add('tyru/open-browser.vim')
  call minpac#add('xolox/vim-misc')
  call minpac#add('xolox/vim-session')
  call minpac#add('yasukotelin/shirotelin', {'type': 'opt'})

  " telescope
  call minpac#add('nvim-lua/popup.nvim')
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('nvim-telescope/telescope.nvim')
  call minpac#add('fannheyward/telescope-coc.nvim')

  " denops
  call minpac#add('vim-denops/denops.vim')
  " call minpac#add('monaqa/dps-dial.vim', {'type': 'opt'})
  call minpac#add('monaqa/dps-dial.vim')

  " Treesitter
  call minpac#add('nvim-treesitter/nvim-treesitter')
  call minpac#add('nvim-treesitter/playground')
  call minpac#add('sainnhe/gruvbox-material')
  " call minpac#add('nvim-treesitter/nvim-treesitter-textobjects', {'branch': '0.5-compat'})

  " Filetype Plugins
  " call minpac#add('sheerun/vim-polyglot')
  call minpac#add('JuliaEditorSupport/julia-vim')
  call minpac#add('cespare/vim-toml')
  call minpac#add('ekalinin/Dockerfile.vim')
  call minpac#add('leafgarland/typescript-vim')
  call minpac#add('pangloss/vim-javascript')
  call minpac#add('ocaml/vim-ocaml')
  call minpac#add('pest-parser/pest.vim')
  " call minpac#add('plasticboy/vim-markdown')
  call minpac#add('rust-lang/rust.vim')
  call minpac#add('vim-python/python-syntax')
  call minpac#add('wlangstroth/vim-racket')
  call minpac#add('aklt/plantuml-syntax')
  call minpac#add('bfontaine/Brewfile.vim')
  call minpac#add('mracos/mermaid.vim')
  call minpac#add('chr4/nginx.vim')
  call minpac#add('vito-c/jq.vim')

  " My packages
  call minpac#add('monaqa/dial.nvim', {'type': 'opt'})
  call minpac#add('monaqa/peridot.vim')
  call minpac#add('monaqa/satysfi.vim')
  call minpac#add('monaqa/smooth-scroll.vim')
  call minpac#add('monaqa/vim-edgemotion')
  call minpac#add('monaqa/modesearch.vim')
  call minpac#add('monaqa/colordinate.vim')
  call minpac#add('monaqa/pretty-fold.nvim', { 'branch': 'for_stable_neovim' })

endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

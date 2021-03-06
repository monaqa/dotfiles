let s:script = expand('<sfile>')

function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('Konfekt/FastFold')
  call minpac#add('Shougo/vimproc.vim')
  call minpac#add('Vimjas/vim-python-pep8-indent')
  call minpac#add('bps/vim-textobj-python')
  call minpac#add('cohama/lexima.vim')
  call minpac#add('glidenote/memolist.vim')
  call minpac#add('glts/vim-textobj-comment')
  call minpac#add('habamax/vim-gruvbit')
  call minpac#add('hoob3rt/lualine.nvim')
  call minpac#add('kana/vim-altr')
  call minpac#add('kana/vim-operator-user')
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('kkiyama117/zenn-vim')
  call minpac#add('kyazdani42/nvim-web-devicons')
  call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
  call minpac#add('lambdalisue/fern-hijack.vim')
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
  call minpac#add('monaqa/dial.nvim', {'type': 'opt'})
  call minpac#add('monaqa/satysfi.vim')
  call minpac#add('monaqa/smooth-scroll.vim')
  call minpac#add('monaqa/vim-edgemotion')
  call minpac#add('neoclide/coc.nvim')
  call minpac#add('previm/previm')
  call minpac#add('rafcamlet/coc-nvim-lua')
  call minpac#add('raghur/vim-ghost')
  call minpac#add('rhysd/rust-doc.vim')
  call minpac#add('romgrk/barbar.nvim')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('thinca/vim-splash')
  call minpac#add('thinca/vim-submode')
  call minpac#add('tpope/vim-capslock')
  call minpac#add('tyru/caw.vim')
  call minpac#add('xolox/vim-misc')
  call minpac#add('xolox/vim-session')
  call minpac#add('yasukotelin/shirotelin', {'type': 'opt'})
  call minpac#add('yuki-yano/fern-preview.vim')

  " telescope
  call minpac#add('nvim-lua/popup.nvim')
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('nvim-telescope/telescope.nvim')

  " denops
  call minpac#add('vim-denops/denops.vim')
  call minpac#add('yutkat/dps-coding-now.nvim', {'type': 'opt'})

  " Treesitter
  call minpac#add('nvim-treesitter/nvim-treesitter')
  call minpac#add('nvim-treesitter/nvim-treesitter-textobjects')

  " Filetype Plugins
  " call minpac#add('sheerun/vim-polyglot')
  call minpac#add('JuliaEditorSupport/julia-vim')
  call minpac#add('cespare/vim-toml')
  call minpac#add('ocaml/vim-ocaml')
  call minpac#add('pest-parser/pest.vim')
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('rust-lang/rust.vim')
  call minpac#add('vim-python/python-syntax')

endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

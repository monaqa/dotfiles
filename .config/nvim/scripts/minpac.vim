let s:script = expand('<sfile>')

if exists('*minpac#init')
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " call minpac#add('file:///Users/shinichi/ghq/github.com/monaqa/vim-satynx')
  call minpac#add('Konfekt/FastFold')
  call minpac#add('Shougo/vimproc.vim')
  call minpac#add('Vimjas/vim-python-pep8-indent')
  call minpac#add('bps/vim-textobj-python')
  call minpac#add('cohama/lexima.vim')
  call minpac#add('glts/vim-textobj-comment')
  call minpac#add('habamax/vim-gruvbit')
  call minpac#add('junegunn/fzf')
  call minpac#add('kana/vim-altr')
  call minpac#add('kana/vim-operator-user')
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('kkiyama117/zenn-vim')
  call minpac#add('kyazdani42/nvim-web-devicons')
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
  call minpac#add('mbbill/undotree')
  call minpac#add('mhinz/vim-signify')
  call minpac#add('monaqa/satysfi.vim')
  call minpac#add('monaqa/smooth-scroll.vim')
  call minpac#add('monaqa/vim-edgemotion')
  call minpac#add('neoclide/coc.nvim')
  call minpac#add('pest-parser/pest.vim')
  call minpac#add('previm/previm')
  call minpac#add('rafcamlet/coc-nvim-lua')
  call minpac#add('raghur/vim-ghost')
  call minpac#add('rhysd/rust-doc.vim')
  call minpac#add('romgrk/barbar.nvim')
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('thinca/vim-splash')
  call minpac#add('thinca/vim-submode')
  call minpac#add('tpope/vim-capslock')
  call minpac#add('tyru/caw.vim')
  call minpac#add('xolox/vim-misc')
  call minpac#add('xolox/vim-session')
  call minpac#add('yasukotelin/shirotelin', {'type': 'opt'})

  call minpac#add('hoob3rt/lualine.nvim')
endif
packloadall

" Load plugins/*.vim
" function! s:load_configurations() abort
"   for path in glob($HOME . '/.config/nvim/plugins/*.vim', 1, 1, 1)
"     execute printf('source %s', fnameescape(path))
"   endfor
" endfunction
" call s:load_configurations()

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
if !exists('*s:init')
  function! s:init() abort
    packadd minpac
    execute 'source' fnameescape(s:script)
  endfunction
endif
command! PackUpdate call s:init() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call s:init() | call minpac#clean()
command! PackStatus call s:init() | call minpac#status()

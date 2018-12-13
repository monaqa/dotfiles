" 高速化に大きな寄与を与える
" https://github.com/neovim/neovim/issues/7237
" let g:clipboard = {
          " \   'name': 'xclip-custom',
          " \   'copy': {
          " \      '+': 'xclip -quiet -i -selection clipboard',
          " \      '*': 'xclip -quiet -i -selection primary',
          " \    },
          " \   'paste': {
          " \      '+': 'xclip -o -selection clipboard',
          " \      '*': 'xclip -o -selection primary',
          " \   },
          " \ }
 
" Mac では以下のようにしないと pbcopy が使えないっぽい
" https://github.com/neovim/neovim/issues/8631
let g:clipboard = {'copy': {'+': 'pbcopy', '*': 'pbcopy'}, 'paste': {'+': 'pbpaste', '*': 'pbpaste'}, 'name': 'pbcopy', 'cache_enabled': 0}
set clipboard+=unnamedplus

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set ambiwidth=double

if has('mac')
  let g:vimtex_view_method='skim'
else
  let g:vimtex_view_method='zathura'
endif

let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

" vim:fdm=marker:fmr=§§,■■

" Package を load する前に予め設定する変数値など．

" §§1 Plugin settings for lambdalisue/fern.vim

let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" §§1 Plugin settings for lervag/vimtex

let g:tex_flavor = "latex"

" §§1 Plugin settings for liuchengxu/vista.vim

let g:vista_default_executive = 'coc'

" §§1 Plugin settings for sheerun/vim-polyglot

let g:polyglot_disabled = ['tex', 'latex', 'fish']

" §§1 Plugin settings for thinca/vim-splash

let g:splash#path = $HOME . "/.config/nvim/scripts/template/monaqa.txt"

" §§1 Plugin settings for thinca/vim-textobj-between

let g:textobj_between_no_default_key_mappings = 1

" §§1 Plugin settings for vim-airline/vim-airline

let g:airline_theme = 'sol'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_idx_mode = 3
let g:airline#extensions#tabline#buffer_idx_format = {
\ '0': '𝟎',
\ '1': '𝟏',
\ '2': '𝟐',
\ '3': '𝟑',
\ '4': '𝟒',
\ '5': '𝟓',
\ '6': '𝟔',
\ '7': '𝟕',
\ '8': '𝟖',
\ '9': '𝟗'
\}

nmap sp <Plug>AirlineSelectPrevTab
nmap sn <Plug>AirlineSelectNextTab
nmap s1 <Plug>AirlineSelectTab01
nmap s2 <Plug>AirlineSelectTab02
nmap s3 <Plug>AirlineSelectTab03
nmap s4 <Plug>AirlineSelectTab04
nmap s5 <Plug>AirlineSelectTab05
nmap s6 <Plug>AirlineSelectTab06
nmap s7 <Plug>AirlineSelectTab07
nmap s8 <Plug>AirlineSelectTab08
nmap s9 <Plug>AirlineSelectTab09


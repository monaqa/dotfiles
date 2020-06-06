" let g:airline_theme = 'gruvbox'
" let g:airline_theme = 'dracula'
let g:airline_theme = 'sol'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
\ '0': '0:',
\ '1': '1:',
\ '2': '2:',
\ '3': '3:',
\ '4': '4:',
\ '5': '5:',
\ '6': '6:',
\ '7': '7:',
\ '8': '8:',
\ '9': '9:'
\}
nmap sp <Plug>AirlineSelectPrevTab
nmap sn <Plug>AirlineSelectNextTab
" 謎のエラーが出る
" nmap <expr> s<Space> "<Plug>AirlineSelectTab" . v:count
nmap 1s<Space> <Plug>AirlineSelectTab1
nmap 2s<Space> <Plug>AirlineSelectTab2
nmap 3s<Space> <Plug>AirlineSelectTab3
nmap 4s<Space> <Plug>AirlineSelectTab4
nmap 5s<Space> <Plug>AirlineSelectTab5
nmap 6s<Space> <Plug>AirlineSelectTab6
nmap 7s<Space> <Plug>AirlineSelectTab7
nmap 8s<Space> <Plug>AirlineSelectTab8
nmap 9s<Space> <Plug>AirlineSelectTab9
" let g:airline#extensions#whitespace#mixed_indent_algo = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1

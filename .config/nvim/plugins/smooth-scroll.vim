let g:smooth_scroll_no_default_key_mappings = 1
let g:smooth_scroll_interval = 1000.0 / 40
let g:smooth_scroll_scrollkind = "quintic"
nnoremap <silent> <C-d> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0) / 2, 15,  1)<CR>
nnoremap <silent> <C-u> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0) / 2, 15, -1)<CR>
nnoremap <silent> <C-f> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0)    , 25,  1)<CR>
nnoremap <silent> <C-b> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0)    , 25, -1)<CR>

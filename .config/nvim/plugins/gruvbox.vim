let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_material_background = 'hard'
set background=dark

set termguicolors
colorscheme gruvbit

augroup vimrc_colorscheme
  autocmd!
  autocmd VimEnter,BufNew,BufRead * if g:colors_name ==# 'gruvbox'
  autocmd VimEnter,BufNew,BufRead *   call s:setting_gruvbox()
  autocmd VimEnter,BufNew,BufRead * end
  autocmd VimEnter,BufNew,BufRead * if g:colors_name ==# 'gruvbit'
  autocmd VimEnter,BufNew,BufRead *   call s:setting_gruvbit()
  autocmd VimEnter,BufNew,BufRead * end
augroup END

function! s:setting_gruvbox() abort
  hi! link SpecialKey GruvboxBg4
  hi! NonText ctermfg=103 guifg=#8787af
  hi! MatchParen ctermbg=66 ctermfg=223 guibg=#5f8787 guifg=#ffdfdf
  hi! CursorColumn ctermbg=238 guibg=#444444
  hi! CursorLine ctermbg=238 guibg=#444444
  hi! FoldColumn ctermbg=236 guibg=#303030
  hi! SignColumn ctermbg=238 guibg=#444444
  hi! link Folded GruvboxPurpleBold
  hi! link VertSplit GruvboxFg1
  hi! link HighlightedyankRegion DiffChange
  autocmd vimrc FileType help hi! Ignore ctermfg=66 guifg=#5f8787
endfunction

function! s:setting_gruvbit() abort
  hi! FoldColumn ctermbg=236 guibg=#303030
endfunction

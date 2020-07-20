let g:gruvbox_contrast_dark = 'hard'
set background=dark

colorscheme gruvbox

autocmd VimEnter,BufNew,BufRead * call s:setting_gruvbox()

function! s:setting_gruvbox() abort
  hi! link SpecialKey GruvboxBg4
  hi! NonText ctermfg=103 guifg=#8787af
  hi! MatchParen ctermbg=66 ctermfg=223 guibg=#5f8787 guifg=#ffdfdf
  hi! CursorColumn ctermbg=240 guibg=#585858
  hi! CursorLine ctermbg=240 guibg=#585858
  hi! FoldColumn ctermbg=236 guibg=#303030
  hi! SignColumn ctermbg=238 guibg=#444444
  hi! link Folded GruvboxPurpleBold
  hi! link VertSplit GruvboxFg1
  hi! link HighlightedyankRegion DiffChange
  autocmd vimrc FileType help hi! Ignore ctermfg=66 guifg=#5f8787
endfunction

let g:firenvim_config = {
\     'globalSettings': {
\         'alt': 'all',
\      },
\     'localSettings': {
\         '.*': {
\             'cmdline': 'neovim',
\             'priority': 0,
\             'selector': 'textarea',
\             'takeover': 'never',
\         },
\     }
\ }

augroup Firenvim
  autocmd!
  autocmd BufEnter play.golang.org_*.txt set filetype=go
  autocmd BufEnter play.rust-lang.org_*.txt set filetype=rust
  autocmd BufEnter github.com_*.txt set filetype=markdown
  autocmd BufEnter localhost_notebooks*.txt set filetype=python
  autocmd BufEnter localhost_notebooks*.txt let b:coc_diagnostic_disable = 1
augroup END

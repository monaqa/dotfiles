let s:gina_custom_translation_patterns = [
\   [
\     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
\     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
\   ], {
\     'root':  'https://\1/\2/\3/tree/%r1/',
\     '_':     'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-L}le',
\     'exact': 'https://\1/\2/\3/blob/%h1/%pt%{#L|}ls%{-L}le',
\   },
\ ]

nnoremap <Space>gs :<C-u>Gina status -s --opener=split<CR>
nnoremap <Space>gb :Gina browse --exact --yank :<CR>:let @+=@"<CR>:echo @+<CR>
vnoremap <Space>gb :Gina browse --exact --yank :<CR>:let @+=@"<CR>:echo @+<CR>

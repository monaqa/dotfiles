-- vim:fdm=marker:fmr=§§,■■

local util = require "rc.util"

-- §§1 Plugin settings for dial.nvim

-- §§1 Plugin settings for monaqa/smooth-scroll.vim


-- §§1 Plugin settings for modesearch.vim

-- §§1 Plugin settings for partedit

-- vim.cmd[[
-- let g:partedit#opener = ":vsplit"
-- let g:partedit#prefix_pattern = '\v\s*'
--
-- command! -range ParteditCodeblock call s:partedit_code_block(<line1>, <line2>)
-- function! s:partedit_code_block(line1, line2)
--   let line_codeblock_start = getline(a:line1 - 1)
--   let filetype = matchstr(line_codeblock_start, '\v```\zs[-a-zA-Z0-9]+\ze')
--   let options = { "filetype": filetype }
--   call partedit#start(a:line1, a:line2, options)
-- endfunction
-- ]]

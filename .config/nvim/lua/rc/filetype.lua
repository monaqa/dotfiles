-- vim:fdm=marker:fmr=§§,■■
local util = require("rc.util")

-- §§1 SATySFi
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "Satyristes",
    command = [[setfiletype lisp]]
}

util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "*.saty",
    callback = function ()
        vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", {buffer = true})
        vim.keymap.set("n", "@q", ":!satysfi %<CR>", {buffer = true})
        vim.keymap.set("n", "@Q", ":!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space --debug-show-overfull %<CR>", {buffer = true})
    end
}

-- §§1 fish
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "*.fish",
    command = [[setfiletype fish]]
}

-- §§1 mermaid
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "*.mmd",
    command = [[setfiletype mermaid]]
}

-- §§1 hydrogen
vim.cmd[[
function HydrogenFoldOnlyCode(lnum) abort
  if getline(a:lnum + 1) =~ '^# %%'
    return '0'
  endif
  if getline(a:lnum) =~ '^# %%$'
    return '1'
  endif
  return '='
endfunction

function HydrogenCustomFoldText()
  let line_fstart = getline(v:foldstart)
  if line_fstart =~ '^# %% \[markdown\]'
    let kind = '[M]'
    let line_content = getline(v:foldstart + 2)
  else
    let kind = '[ ]'
    let line_content = getline(v:foldstart + 1)
  endif
  " let line_content = getline(v:foldstart + 2)
  " let sub = substitute(line, '', '', 'g')
  return kind . ' ' . line_content . ' '
endfunction
]]


-- §§1 quickfix
util.autocmd_vimrc("FileType"){
    pattern = "qf",
    callback = function ()
        vim.keymap.set("n", "<CR>", "<CR>", {buffer = true})
        vim.keymap.set("n", "j", "j", {buffer = true})
        vim.keymap.set("n", "k", "k", {buffer = true})
    end
}

-- §§1 todome
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "*.todome",
    command = [[setfiletype todome]]
}

-- §§1 html
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "*.html",
    callback = function ()
        vim.keymap.set("i", "</", "</<C-x><C-o>", {buffer = true})
        vim.bo.shiftwidth = 2
    end
}

-- §§1 LICENSE
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = "LICENSE",
    command = [[setfiletype license]]
}

-- §§1 .init.lua.local
util.autocmd_vimrc{"BufRead", "BufNewFile"}{
    pattern = [[.init.lua.local]],
    command = [[setfiletype lua]]
}


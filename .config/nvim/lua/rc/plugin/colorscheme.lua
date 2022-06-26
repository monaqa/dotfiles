local util = require("rc.util")

util.autocmd_vimrc{"ColorScheme"}{
    pattern = "gruvbit",
    callback = function ()

        vim.cmd [[
            hi! FoldColumn guibg=#303030
            hi! NonText    guifg=#496da9
            hi! CocHintFloat guibg=#444444 guifg=#45daef
            hi! link CocRustChainingHint CocHintFloat
            " Diff に関しては前のバージョン
            " (https://github.com/habamax/vim-gruvbit/commit/a19259a1f02bbfff37d72eebef6b5d5d22f22248)
            " のほうが好みだったので。
            hi! DiffChange guifg=NONE guibg=#314a5c gui=NONE cterm=NONE
            hi! DiffDelete guifg=#968772 guibg=#5c3728 gui=NONE cterm=NONE
            hi! MatchParen guifg=#ebdbb2 guibg=#51547d gui=NONE cterm=NONE

            " hi! WeakTitle  cterm=bold ctermfg=225 gui=bold guifg=#fabd2f
            " hi! WeakTitle  gui=nocombine,NONE guifg=#e69393
            hi! WeakTitle  guifg=#fad57f
            hi! Quote      guifg=#c6b7a2

            hi! VertSplit  guifg=#c8c8c8 guibg=None    gui=NONE cterm=NONE
            hi! Visual     guifg=NONE    guibg=#4d564e gui=NONE cterm=NONE
            hi! VisualBlue guifg=NONE    guibg=#4d569e gui=NONE cterm=NONE
            hi! Pmenu      guibg=#505064

            hi! CursorLine           guifg=NONE    guibg=#535657
            hi! CursorColumn         guifg=NONE    guibg=#535657
            hi! QuickFixLine         guifg=NONE    guibg=#4d569e

            hi! BufferCurrent        guifg=#ebdbb2 guibg=#444444 gui=bold
            hi! BufferCurrentMod     guifg=#dc9656 guibg=#444444 gui=bold
            hi! BufferCurrentSign    guifg=#e9593d guibg=#444444 gui=bold
            hi! BufferCurrentTarget  guifg=red     guibg=#444444 gui=bold
            hi! BufferInactive       guifg=#bbbbbb guibg=#777777
            hi! BufferInactiveMod    guifg=#dc9656 guibg=#777777
            hi! BufferInactiveSign   guifg=#444444 guibg=#777777
            hi! BufferInactiveTarget guifg=red     guibg=#777777
            hi! BufferVisible        guifg=#888888 guibg=#444444
            hi! BufferVisibleMod     guifg=#dc9656 guibg=#444444
            hi! BufferVisibleSign    guifg=#888888 guibg=#444444
            hi! BufferVisibleTarget  guifg=red     guibg=#444444
            hi! BufferTabpages       guifg=#e9593d guibg=#444444 gui=bold
            hi! BufferTabpageFill    guifg=#888888 guibg=#c8c8c8
            hi! TabLineFill          guibg=#c8c8c8

            " nvim-treesitter
            hi! TSParameter ctermfg=14 guifg=#b3d5c8
            hi! TSField     ctermfg=14 guifg=#b3d5c8

            " Rust
            hi! rustCommentLineDoc   guifg=#a6a182
        ]]

    end
}

util.autocmd_vimrc{"ColorScheme"}{
    pattern = "gruvbox-material",
    callback = function ()

        vim.cmd [[
            hi! BufferCurrent        guifg=#ebdbb2 guibg=#444444 gui=bold
            hi! BufferCurrentMod     guifg=#dc9656 guibg=#444444 gui=bold
            hi! BufferCurrentSign    guifg=#e9593d guibg=#444444 gui=bold
            hi! BufferCurrentTarget  guifg=red     guibg=#444444 gui=bold
            hi! BufferInactive       guifg=#bbbbbb guibg=#777777
            hi! BufferInactiveMod    guifg=#dc9656 guibg=#777777
            hi! BufferInactiveSign   guifg=#444444 guibg=#777777
            hi! BufferInactiveTarget guifg=red     guibg=#777777
            hi! BufferVisible        guifg=#888888 guibg=#444444
            hi! BufferVisibleMod     guifg=#dc9656 guibg=#444444
            hi! BufferVisibleSign    guifg=#888888 guibg=#444444
            hi! BufferVisibleTarget  guifg=red     guibg=#444444
            hi! BufferTabpages       guifg=#e9593d guibg=#444444 gui=bold
            hi! BufferTabpageFill    guifg=#888888 guibg=#c8c8c8
            hi! TabLineFill          guibg=#c8c8c8

            hi! LineNr       guifg=#888888
            hi! CursorLineNr guifg=#ebdbb2 guibg=#535657    gui=bold
            hi! CursorLine   guifg=NONE    guibg=#535657
            hi! CursorColumn guifg=NONE    guibg=#535657
            hi! QuickFixLine guifg=NONE    guibg=#4d569e
            hi! NonText      guifg=#496da9
            hi! WhiteSpace   guifg=#496da9
            hi! SpecialKey   guifg=#496da9
            hi! Folded       guifg=#9e8f7a guibg=#535657 gui=NONE cterm=NONE
            hi! VertSplit    guifg=#c8c8c8 guibg=None    gui=NONE cterm=NONE
            hi! MatchParen   guifg=#ebdbb2 guibg=#51547d gui=NONE cterm=NONE

            hi! Visual       guifg=NONE    guibg=#4d564e gui=NONE cterm=NONE
            hi! VisualBlue   guifg=NONE    guibg=#4d569e gui=NONE cterm=NONE

            hi! link IncSearch Search
            " hi! IncSearch    ctermfg=234 ctermbg=142 guifg=#1d2021 guibg=#a9b665
            " hi! link Search VisualBlue

            hi! Pmenu            guibg=#505064
            hi! NormalFloat      guibg=#505064
            hi! CocRustHintFloat guibg=#444444 guifg=#258aaf
            hi! link CocRustChainingHint CocRustHintFloat
            hi! link CocRustTypeHint     CocRustHintFloat

            hi! link TSField Normal
        ]]

    end
}

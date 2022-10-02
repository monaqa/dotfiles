local util = require "rc.util"

---@alias tbl_hl {name: string, gui?: string, guifg?: string, guibg?: string, cterm?: string, ctermbg?: string, ctermfg?: string}
---@alias tbl_link {name: string, link: string}

---@param tbl tbl_hl | tbl_link
local function sethl(tbl)
    if tbl.link ~= nil then
        vim.cmd(table.concat({
            "highlight!",
            "link",
            tbl.name,
            tbl.link,
        }, " "))
    else
        local opts = {}
        for _, key in ipairs { "gui", "guifg", "guibg", "cterm", "ctermfg", "ctermbg" } do
            if tbl[key] ~= nil then
                table.insert(opts, key .. "=" .. tbl[key])
            end
        end
        local opts_str = table.concat(opts, " ")
        vim.cmd(table.concat({
            "highlight!",
            tbl.name,
            opts_str,
        }, " "))
    end
end

-- TODO: foo
util.autocmd_vimrc { "ColorScheme" } {
    pattern = "gruvbit",
    callback = function()
        -- basic
        sethl { name = "FoldColumn", guibg = "#303030" }
        sethl { name = "NonText", guifg = "#496da9" }
        sethl { name = "Todo", gui = "bold", guibg = "#444444", guifg = "#c6b7a2" }

        sethl {
            name = "VertSplit",
            guifg = "#c8c8c8",
            guibg = "None",
            -- gui="bold",
        }
        sethl { name = "Visual", guibg = "#4d564e" }
        sethl { name = "Pmenu", guibg = "#404064" }
        sethl { name = "QuickFixLine", guibg = "#4d569e" }

        sethl { name = "DiffChange", guibg = "#314a5c" }
        sethl { name = "DiffDelete", guibg = "#5c3728", guifg = "#968772" }
        sethl { name = "MatchParen", guibg = "#51547d", guifg = "#ebdbb2" }

        -- coc.nvim
        sethl { name = "CocHintFloat", guibg = "#444444", guifg = "#45daef" }
        sethl { name = "CocRustChainingHint", link = "CocHintFloat" }
        sethl { name = "CocSearch", guifg = "#fabd2f" }
        sethl { name = "CocMenuSel", guibg = "#303054" }

        -- custom highlight name
        sethl { name = "WeakTitle", guifg = "#fad57f" }
        sethl { name = "Quote", guifg = "#c6b7a2" }
        sethl { name = "VisualBlue", guibg = "#4d569e" }

        -- nvim-treesitter
        sethl { name = "TSParameter", guifg = "#b3d5c8" }
        sethl { name = "TSField", guifg = "#b3d5c8" }

        -- misc
        sethl { name = "rustCommentLineDoc", guifg = "#a6a182" }
    end,
}

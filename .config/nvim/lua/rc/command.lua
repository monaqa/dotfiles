local util = require "rc.util"
local obsidian = require "rc.obsidian"
-- vim:fdm=marker:fmr=§§,■■

local function create_cmd(name, impl, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_create_user_command(name, impl, options)
end

-- §§1 highlight
create_cmd("HighlightGroup", function ()
    print(
    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)), "name")
    )
end)
create_cmd("HighlightItem", function ()
    print(
    vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name")
    )
end)

-- §§1 encoding
create_cmd("Utf8", "edit ++enc=utf-8 %")
create_cmd("Cp932", "edit ++enc=cp932 %")
create_cmd("Unix", "edit ++enc=unix %")
create_cmd("Dos", "edit ++enc=dos %")
create_cmd("AsUtf8", "set fenc=utf-8|w")

-- §§1 diff
create_cmd("DiffThese", function ()
    if vim.fn.winnr("$") == 2 then
        vim.cmd[[
            diffthis
            wincmd w
            diffthis
            wincmd w
        ]]
    else
        vim.cmd[[echomsg "Too many windows."]]
    end
end)

-- §§1 rename/delete file
-- thanks to cohama
create_cmd("DeleteMe", function (meta)
    local force = meta.bang
    if force or not vim.bo.modified then
        local filename = vim.fn.expand("%", nil, nil)
        vim.cmd[[bdelete!]]
        vim.fn.delete(filename)
    else
        vim.cmd[[echomsg 'File modified']]
    end
end, {bang = true})

create_cmd("RenameMe", function (meta)
    local new_fname = meta.args
    local current_fname = vim.fn.expand("%", nil, nil)
    vim.cmd("saveas " .. new_fname)
    vim.cmd[[bdelete! #]]
    vim.fn.delete(current_fname)
end, {nargs = 1})
vim.cmd[[
    cnoreabbrev <expr> RenameMe "RenameMe " . expand('%')
]]

-- §§1 行末の空白とか最終行の空行を削除
create_cmd("RemoveUnwantedSpaces", function (meta)
    local pos_save = vim.fn.getpos(".")
    vim.cmd([[keeppatterns ]] .. meta.line1 .. "," .. meta.line2 .. [[s/\s\+$//e]])
    while true do
        if vim.regex([[^\s*$]]):match_str(vim.fn.getline("$")) and vim.fn.line("$") ~= 1 then
            vim.cmd[[silent $delete]]
        else
            break
        end
    end
    vim.fn.setpos(".", pos_save)
end, {range = "%"})

create_cmd("YankCurrentFileName", [[let @+ = expand("%:p")]])

create_cmd("SubstituteCommaPeriod", function (meta)
    local invert = meta.bang
    if invert then
        vim.cmd[[
        keeppatterns %substitute/、/，/g
        keeppatterns %substitute/。/．/g
        ]]
    else
        vim.cmd[[
        keeppatterns %substitute/，/、/g
        keeppatterns %substitute/．/。/g
        ]]
    end
end, {bang = true})

-- §§1 memolist.vim + telescope
create_cmd("MemoFind", function ()
    require("telescope.builtin").find_files{ cwd = "~/memo" }
end)

create_cmd("MemoFind", function ()
    require("telescope.builtin").live_grep{ cwd = "~/memo" }
end)

create_cmd("Normal", function (tbl)
    local code = vim.api.nvim_replace_termcodes(tbl.args, true, true, true)
    local cmd = util.ifexpr(tbl.bang, "normal!", "normal")
    for i = tbl.line1, tbl.line2, 1 do
        vim.cmd(i .. cmd .. " " .. code)
    end
end, {range = true, nargs = 1, bang = true})

-- §§1 obsidian.vim
create_cmd("ObsidianList", obsidian.open_fern)
create_cmd("ObsidianOpenDiary", obsidian.open_diary)
create_cmd("ObsidianGrep", function ()
    vim.ui.input({prompt = "g/"}, function (kwd)
        obsidian.grep_keyword(kwd)
    end)
end)

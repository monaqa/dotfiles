-- vim:fdm=marker:fmr=§§,■■

-- §§1 highlight
vim.api.nvim_create_user_command("HighlightGroup", function ()
    print(
    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)), "name")
    )
end, {})
vim.api.nvim_create_user_command("HighlightItem", function ()
    print(
    vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name")
    )
end, {})

-- §§1 encoding
vim.api.nvim_create_user_command("Utf8", "edit ++enc=utf-8 %", {})
vim.api.nvim_create_user_command("Cp932", "edit ++enc=cp932 %", {})
vim.api.nvim_create_user_command("Unix", "edit ++enc=unix %", {})
vim.api.nvim_create_user_command("Dos", "edit ++enc=dos %", {})
vim.api.nvim_create_user_command("AsUtf8", "set fenc=utf-8|w", {})

-- §§1 diff
vim.api.nvim_create_user_command("DiffThese", function ()
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
end, {})

-- §§1 rename/delete file
-- thanks to cohama
vim.api.nvim_create_user_command("DeleteMe", function (meta)
    local force = meta.bang
    if force or not vim.bo.modified then
        local filename = vim.fn.expand("%", nil, nil)
        vim.cmd[[bdelete!]]
        vim.fn.delete(filename)
    else
        vim.cmd[[echomsg 'File modified']]
    end
end, {bang = true})

vim.api.nvim_create_user_command("RenameMe", function (meta)
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
vim.api.nvim_create_user_command("RemoveUnwantedSpaces", function (meta)
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

vim.api.nvim_create_user_command("YankCurrentFileName", [[let @+ = expand("%:p")]], {})

vim.api.nvim_create_user_command("SubstituteCommaPeriod", function (meta)
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
vim.api.nvim_create_user_command("MemoFind", function ()
    require("telescope.builtin").find_files{ cwd = "~/memo" }
end, {})

vim.api.nvim_create_user_command("MemoFind", function ()
    require("telescope.builtin").live_grep{ cwd = "~/memo" }
end, {})

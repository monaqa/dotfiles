local monaqa = require("monaqa")
local util = require("rc.util")
-- vim:fdm=marker:fmr=§§,■■

-- §§1 highlight
util.create_cmd("HighlightGroup", function()
    print(vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)), "name"))
end)
util.create_cmd("HighlightItem", function()
    print(vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name"))
end)

-- §§1 encoding
util.create_cmd("Utf8", "edit ++enc=utf-8 %")
util.create_cmd("Cp932", "edit ++enc=cp932 %")
util.create_cmd("Unix", "edit ++enc=unix %")
util.create_cmd("Dos", "edit ++enc=dos %")
util.create_cmd("AsUtf8", "set fenc=utf-8|w")

-- §§1 diff
util.create_cmd("DiffThese", function()
    if vim.fn.winnr("$") == 2 then
        vim.cmd.diffoff { bang = true }
        vim.cmd.diffthis()
        vim.cmd.wincmd("w")
        vim.cmd.diffthis()
        vim.cmd.wincmd("w")
    else
        vim.cmd.echomsg([[Too many windows.]])
    end
end)

-- §§1 rename/delete file
-- thanks to cohama
util.create_cmd("DeleteMe", function(meta)
    local force = meta.bang
    if force or not vim.bo.modified then
        local filename = vim.fn.expand("%", nil, nil)
        vim.cmd([[bdelete!]])
        vim.fn.delete(filename)
    else
        vim.cmd([[echomsg 'File modified']])
    end
end, { bang = true })

util.create_cmd("RenameMe", function(meta)
    local new_fname = meta.args
    local current_fname = vim.fn.expand("%", nil, nil)
    vim.cmd("saveas " .. new_fname)
    vim.cmd([[bdelete! #]])
    vim.fn.delete(current_fname)
end, { nargs = 1 })
vim.cmd([[
    cnoreabbrev <expr> RenameMe "RenameMe " . expand('%')
]])

-- §§1 行末の空白とか最終行の空行を削除
util.create_cmd("RemoveUnwantedSpaces", function(meta)
    local pos_save = vim.fn.getpos(".")
    vim.cmd([[keeppatterns ]] .. meta.line1 .. "," .. meta.line2 .. [[s/[ \t\r]\+$//e]])
    while true do
        if vim.regex([[^\s*$]]):match_str(vim.fn.getline("$")) and vim.fn.line("$") ~= 1 then
            vim.cmd([[silent $delete]])
        else
            break
        end
    end
    vim.fn.setpos(".", pos_save)
end, { range = "%" })

util.create_cmd("YankCurrentFileName", [[let @+ = expand("%:p")]])

util.create_cmd("SubstituteCommaPeriod", function(meta)
    local invert = meta.bang
    if invert then
        vim.cmd([[
        keeppatterns %substitute/、/，/g
        keeppatterns %substitute/。/．/g
        ]])
    else
        vim.cmd([[
        keeppatterns %substitute/，/、/g
        keeppatterns %substitute/．/。/g
        ]])
    end
end, { bang = true })

util.create_cmd("EditFtplugin", function()
    vim.cmd.edit { "~/.config/nvim/after/ftplugin/" .. vim.opt_local.filetype:get() .. ".lua" }
end)

util.create_cmd("Normal", function(tbl)
    local code = vim.api.nvim_replace_termcodes(tbl.args, true, true, true)
    local cmd = util.ifexpr(tbl.bang, "normal!", "normal")
    for i = tbl.line1, tbl.line2, 1 do
        vim.cmd(i .. cmd .. " " .. code)
    end
end, { range = true, nargs = 1, bang = true })

-- §§1 todome
util.create_cmd("TodomeOpen", "edit ~/todome/tasks.todome")

monaqa.shorthand.create_cmd("Split", function(meta)
    util.split_window()
    vim.cmd(meta.args)
end, { nargs = 1 })

-- §§1 Save Clipboard Image

vim.api.nvim_create_user_command(
    "PutClipboardImage",
    require("rc.clipboard").command_put_clipboard_image {
        fn_image_path = function(name)
            local current_file_dir = vim.fn.expand("%:h")
            local dir = current_file_dir .. "/image/"
            if name == nil or name == "" then
                name = vim.fn.strftime("%Y-%m-%d-%H-%M-%S")
            end
            return dir .. name .. ".png"
        end,
        fn_markup_string = function(name, path)
            return "![](" .. path .. ")"
        end,
    },
    { nargs = "*" }
)

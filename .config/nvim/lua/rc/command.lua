-- vim:fdm=marker:fmr=§§,■■
local monaqa = require("monaqa")
local logic = monaqa.logic
local create_cmd = monaqa.shorthand.create_cmd
local mapset = monaqa.shorthand.mapset

-- §§1 highlight
create_cmd("HighlightGroup") {
    desc = [[カーソル位置のハイライトグループを表示する]],
    function()
        vim.notify(vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)), "name"))
    end,
}
create_cmd("HighlightGroup") {
    desc = [[カーソル位置のハイライトを表示する]],
    function()
        vim.notify(vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name"))
    end,
}

-- §§1 encoding
create_cmd("Utf8") { "edit ++enc=utf-8 %" }
create_cmd("Cp932") { "edit ++enc=cp932 %" }
create_cmd("Unix") { "edit ++enc=unix %" }
create_cmd("Dos") { "edit ++enc=dos %" }
create_cmd("AsUtf8") { "set fenc=utf-8|w" }

-- §§1 ウィンドウ操作

create_cmd("Split") {
    desc = [[いい感じに window を split してコマンドを実行する]],
    nargs = 1,
    function(meta)
        monaqa.window.wise_split()
        vim.cmd(meta.args)
    end,
}
create_cmd("DiffThese") {
    desc = [[2ウィンドウを開いているとき、両者の差分を取る]],
    function()
        if vim.fn.winnr("$") == 2 then
            vim.cmd.diffoff { bang = true }
            vim.cmd.diffthis()
            vim.cmd.wincmd("w")
            vim.cmd.diffthis()
            vim.cmd.wincmd("w")
        else
            vim.notify([[Too many windows.]], vim.log.levels.ERROR)
        end
    end,
}

-- §§1 rename/delete file
-- thanks to cohama

create_cmd("DeleteMe") {
    desc = [[開いているファイル自体を削除し、バッファも閉じる]],
    bang = true,
    function(meta)
        local force = meta.bang
        if force or not vim.bo.modified then
            local filename = vim.fn.expand("%", nil, nil)
            vim.cmd([[bdelete!]])
            vim.fn.delete(filename)
        else
            vim.cmd([[echomsg 'File modified']])
        end
    end,
}

create_cmd("RenameMe") {
    desc = [[開いているファイルをリネームする]],
    nargs = 1,
    function(meta)
        local new_fname = meta.args
        local current_fname = vim.fn.expand("%", nil, nil)
        vim.cmd("saveas " .. new_fname)
        vim.cmd([[bdelete! #]])
        vim.fn.delete(current_fname)
    end,
}
mapset.ca("RenameMe") {
    desc = [[現在のファイル名を自動で補完する]],
    expr = true,
    function()
        return "RenameMe " .. vim.fn.expand("%")
    end,
}

-- §§1 テキスト編集
create_cmd("RemoveUnwantedSpaces") {
    desc = [[行末の空白とか最終行の空行を削除]],
    range = "%",
    function(meta)
        local pos_save = vim.fn.getpos(".")
        vim.cmd.substitute {
            [[/[ \t\r]\+$//e]],
            range = { meta.line1, meta.line2 },
            mods = { keeppatterns = true },
        }
        while true do
            if vim.regex([[^\s*$]]):match_str(vim.fn.getline("$")) and vim.fn.line("$") ~= 1 then
                vim.cmd([[silent $delete]])
            else
                break
            end
        end
        vim.fn.setpos(".", pos_save)
    end,
}

create_cmd("YankCurrentFileName") { [[let @+ = expand("%:p")]] }

create_cmd("SubstituteCommaPeriod") {
    desc = [[コンマ・ピリオドを句読点に直す]],
    bang = true,
    range = "%",
    function(meta)
        local substitute_patterns
        if meta.bang then
            substitute_patterns = { "/、/，/g", "/。/．/g" }
        else
            substitute_patterns = { "/，/、/g", "/．/。/g" }
        end
        for _, pattern in ipairs(substitute_patterns) do
            vim.cmd.substitute {
                pattern,
                range = { meta.line1, meta.line2 },
                mods = { keeppatterns = true },
            }
        end
    end,
}

create_cmd("EditFtplugin") {
    desc = [[開いているファイルの filetype に対応する ftplugin ファイルを開く]],
    function()
        vim.cmd.edit { "~/.config/nvim/after/ftplugin/" .. vim.opt_local.filetype:get() .. ".lua" }
    end,
}

create_cmd("Normal") {
    desc = [[args の termcodes を展開した Normal コマンドを実行する]],
    range = true,
    nargs = 1,
    bang = true,
    function(tbl)
        local code = vim.api.nvim_replace_termcodes(tbl.args, true, true, true)
        local cmd = logic.ifexpr(tbl.bang, "normal!", "normal")
        for i = tbl.line1, tbl.line2, 1 do
            vim.cmd(i .. cmd .. " " .. code)
        end
    end,
}

-- §§1 Save Clipboard Image
create_cmd("PutClipboardImage") {
    desc = [[クリップボードに保存されている画像を貼り付ける]],
    nargs = "*",
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
}

-- §§1 misc
create_cmd("CocEditSnippet") {
    function()
        vim.cmd.edit("~/.config/coc/ultisnips/" .. vim.bo.filetype .. ".snippets")
    end,
}
create_cmd("EditSnippet") {
    function()
        monaqa.snippet.edit_snippet_file(vim.bo.filetype)
    end,
}

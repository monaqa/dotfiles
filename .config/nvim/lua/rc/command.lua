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
        vim.cmd.diffoff { bang = true }
        vim.cmd.diffthis()
        vim.cmd.wincmd("w")
        vim.cmd.diffthis()
        vim.cmd.wincmd("w")
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

create_cmd("Compress") {
    desc = [[空行を消す]],
    range = "%",
    function(meta)
        vim.cmd.substitute {
            [[/^$\n//]],
            range = { meta.line1, meta.line2 },
            mods = { keeppatterns = true },
        }
    end,
}

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

-- §§1 spell
create_cmd("Vocabrary") {
    function()
        vim.iter(vim.opt.spellfile:get()):each(function(file)
            vim.cmd.split { file }
            vim.cmd.setfiletype { "conf" }
        end)
    end
}

-- §§1 Pi
local pi_terminal_bufid = nil
local pi_session_buffers = {}

local function pi_terminal_alive(buf)
    return buf and vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buftype == "terminal"
        and vim.fn.jobwait({ vim.b[buf].terminal_job_id }, 0)[1] == -1
end

function _G.vimrc.fn.has_pi_terminal()
    return not not pi_terminal_alive(pi_terminal_bufid)
end

local function map_pi_keys(buf)
    local mapset = monaqa.shorthand.mapset_local

    local function send(key)
        return function()
            vim.api.nvim_chan_send(vim.b[buf].terminal_job_id, vim.keycode(key))
        end
    end

    mapset.n("<CR>") {
        desc = [[Pi: submit (Ctrl + Enter)]],
        function()
            vim.api.nvim_chan_send(vim.b[buf].terminal_job_id, "\27[13;5u")
        end,
    }

    mapset.n("<C-t>") { send("<C-t>"), desc = [[Pi: thinking blocks]] }

    mapset.n("o") { [[i<C-g>]], desc = [[Pi: open prompt buffer in neovim]] }
    mapset.t("<Esc>") { [[<C-\><C-n>]], desc = [[Pi: back to NORMAL mode]] }
end

create_cmd("Pi") {
    desc = [[Pi 専用の terminal window を開く]],
    nargs = "*",
    function(meta)
        -- 引数があるときは指定した引数で新しく起動
        local reuse = meta.args == "" and pi_terminal_alive(pi_terminal_bufid)
        if not reuse and not logic.to_bool(vim.fn.executable("fish")) then
            vim.notify("fish が見つかりません", vim.log.levels.ERROR)
            return
        end

        if reuse then
            local win = vim.fn.bufwinid(pi_terminal_bufid)
            if win ~= -1 then
                vim.api.nvim_set_current_win(win)
                return
            end
        end

        monaqa.window.wise_split()
        if reuse then
            vim.cmd.buffer { pi_terminal_bufid }
        else
            vim.cmd.enew()
            vim.fn.jobstart(
                { "fish", "-c", "exec pi" .. (meta.args == "" and "" or " " .. meta.args) },
                { term = true }
            )
            pi_terminal_bufid = vim.api.nvim_get_current_buf()
            vim.b[pi_terminal_bufid].pi_terminal = true
            map_pi_keys(pi_terminal_bufid)
        end
    end
}

create_cmd("PiSessionOpen") {
    desc = [[カーソル下の #session("...") を Pi で開く]],
    function()
        local path = require("rc.pi_session").path_at_cursor()
        if not path then
            vim.notify("カーソル下に有効なセッションが存在しません", vim.log.levels.ERROR)
            return
        end
        local buf = pi_session_buffers[path]
        if pi_terminal_alive(buf) then
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
                vim.api.nvim_set_current_win(win)
                return
            end
        else
            buf = nil
            pi_session_buffers[path] = nil
        end

        if not buf and not vim.uv.fs_stat(path) then
            vim.fn.mkdir(vim.fs.dirname(path), "p")
            local file, err = io.open(path, "w")
            if file then
                file:close()
            elseif not vim.uv.fs_stat(path) then
                vim.notify("セッションファイルを作成できません", vim.log.levels.ERROR)
                return
            end
        end

        monaqa.window.wise_split()
        if buf then
            vim.cmd.buffer { buf }
            return
        end

        vim.cmd.enew()
        local job = vim.fn.jobstart({ "pi", "--session", path }, { term = true })
        if job <= 0 then
            vim.notify("Pi の起動に失敗しました", vim.log.levels.ERROR)
            return
        end

        buf = vim.api.nvim_get_current_buf()
        pi_session_buffers[path] = buf
        vim.b[buf].pi_terminal = true
        map_pi_keys(buf)
    end
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

create_cmd("Codequote") {
    range = true,
    function(meta)
        local filename = vim.fn.expand("%:t")
        local filetype = vim.bo.filetype
        local start_line = meta.line1
        local lines = vim.api.nvim_buf_get_lines(0, meta.line1 - 1, meta.line2, false)
        local content = table.concat(lines, "\n")

        local result = string.format(
            '#codequote("%s:%d")(````%s\n%s\n````)',
            filename,
            start_line,
            filetype,
            content
        )
        vim.fn.setreg("+", result)
        vim.fn.setreg('"', result)
        vim.notify("Codequoted to clipboard")
    end,
}

-- vim:fdm=marker:fmr=§§,■■

local monaqa = require("monaqa")
local autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
local to_bool = monaqa.logic.to_bool
local mapset_local = monaqa.shorthand.mapset_local

-- §§1 表示設定
autocmd_vimrc("StdinReadPost") {
    desc = [[標準入力から nvim を開いたときに編集された扱いにしない]],
    command = "set nomodified",
}

autocmd_vimrc { "WinLeave", "FocusLost", "InsertEnter" } {
    desc = "temporal attention の設定初期化",
    callback = function()
        vim.opt_local.cursorline = false
        vim.opt_local.cursorcolumn = false
        vim.opt_local.relativenumber = false
    end,
}

autocmd_vimrc("Syntax") {
    desc = "minlines と maxlines の設定",
    command = "syn sync minlines=500 maxlines=1000",
}

autocmd_vimrc { "VimEnter", "WinEnter" } {
    desc = "全角スペースハイライト (https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776)",
    command = [[
        highlight link UnicodeSpaces Error
        match UnicodeSpaces /[\u180E\u2000-\u200A\u2028\u2029\u202F\u205F\u3000]/
    ]],
}
autocmd_vimrc("ColorScheme") {
    desc = "UnicodeSpaces を Error 色にハイライトする",
    command = "highlight link UnicodeSpaces Error",
}

autocmd_vimrc("VimResized") {
    desc = "ウィンドウの画面幅を揃える",
    command = [[Normal! <C-w>=]],
}

autocmd_vimrc("BufRead") {
    desc = "カーソル位置を閉じたときの場所に戻す",
    callback = function(arg)
        if vim.bo.filetype == "commit" or vim.bo.filetype == "rebase" then
            return
        end
        if vim.wo.diff then
            return
        end
        vim.cmd.normal([[g`"]])
    end,
}

autocmd_vimrc("VimEnter") {
    desc = [[.init.lua.local に対してエラーを返す]],
    callback = function()
        local cwd = vim.fn.getcwd()
        local init_lua_local = ("%s/.init.lua.local"):format(cwd)

        -- 無けりゃあ用はないぜ
        if not to_bool(vim.fn.filereadable(init_lua_local)) then
            return
        end

        vim.notify(".init.lua.local はもう使えません‥。", vim.log.levels.ERROR, {})
    end,
}

-- §§1 editor の機能

autocmd_vimrc("InsertLeave") {
    desc = "挿入モードを抜けたら paste モードを off にする",
    callback = function()
        vim.o.paste = false
    end,
}

local function auto_mkdir()
    local dir = vim.fn.expand("<afile>:p:h", nil, nil)
    local is_empty = vim.fn.empty(dir) == 1
    local is_url = vim.fn.match(dir, [[\v^(\w|-)+://]]) >= 0
    local is_directory = vim.fn.isdirectory(dir) == 1
    if is_empty or is_url or is_directory then
        return
    end
    if to_bool(vim.v.cmdbang) then
        vim.fn.mkdir(dir, "p")
        return
    end

    vim.fn.inputsave()
    vim.cmd([[echohl Question]])
    local result = vim.ui.input({
        prompt = ([=["%s" does not exist. Create? [y/N]]=]):format(dir),
        -- highlight = "Question",
        default = "",
    }, function(result)
        if result == "y" then
            vim.fn.mkdir(dir, "p")
        end
    end)
    vim.fn.inputrestore()
end

autocmd_vimrc("BufWritePre") {
    desc = "保存時に必要があれば自動で mkdir する",
    callback = auto_mkdir,
}

local ignore_indent = false
vim.keymap.set({ "n", "x" }, "<Space>y", function()
    ignore_indent = true
    return "y"
end, { expr = true })

local function remove_common_indent(s)
    local lines = vim.split(s, "\n")
    if #lines <= 1 then
        return s
    end
    local n_common_indent = 1000000
    for _, line in ipairs(lines) do
        local blank_line = line:find([[^%s*$]])
        if not blank_line then
            local _, n_indent = line:find([[^%s*]])
            if n_indent ~= nil and n_common_indent > n_indent then
                n_common_indent = n_indent
            end
        end
    end

    local new_lines = {}
    for _, line in ipairs(lines) do
        local blank_line = line:find([[^%s*$]])
        if blank_line then
            new_lines[#new_lines + 1] = ""
        else
            new_lines[#new_lines + 1] = line:sub(n_common_indent + 1)
        end
    end

    return table.concat(new_lines, "\n")
end

autocmd_vimrc("TextYankPost") {
    desc = "無名レジスタへの yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）",
    callback = function()
        local event = vim.v.event

        if event.regname ~= "" then
            return
        end
        if event.operator == "d" then
            vim.fn.setreg("d", vim.fn.getreg('"', nil, nil))
        end
        if event.operator == "c" then
            vim.fn.setreg("c", vim.fn.getreg('"', nil, nil))
        end
        if event.operator == "y" then
            local old_clipboard_content = vim.fn.getreg("+", nil, nil)
            local content = vim.fn.getreg('"', nil, nil)
            if ignore_indent then
                content = remove_common_indent(content)
                ignore_indent = false
            end
            vim.fn.setreg("p", old_clipboard_content)
            vim.fn.setreg("y", content)
            vim.fn.setreg("+", content)
        end
    end,
}

autocmd_vimrc("VimEnter") {
    desc = "マクロ用のレジスタを消去",
    callback = function()
        vim.fn.setreg("q", "")
    end,
}

autocmd_vimrc("QuickfixCmdPost") {
    desc = "Quickfix のコマンドが実行された Quickfix window を開く (locationlist 版)",
    pattern = { "l*" },
    command = "lwin",
}

autocmd_vimrc("QuickfixCmdPost") {
    desc = "Quickfix のコマンドが実行された Quickfix window を開く",
    pattern = { "[^l]*" },
    command = "cwin",
}

autocmd_vimrc("CmdwinEnter") {
    desc = "cmdwin 用の調整",
    callback = function(meta)
        local buf = meta.buf
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        mapset_local.n("<C-f>") { "<C-f>" }
        mapset_local.n("<C-u>") { "<C-u>" }
        mapset_local.n("<C-b>") { "<C-b>" }
        mapset_local.n("<C-d>") { "<C-d>" }
        mapset_local.n("<Esc>") { ":q<CR>" }
        mapset_local.n("<CR>") { "<CR>", nowait = true }
    end,
}

-- ESC 時に英数キーを送るのは Karabiner でできるが、検索コマンドからの離脱時にも送りたい
-- https://rcmdnk.com/blog/2017/03/10/computer-mac-vim/
autocmd_vimrc("CmdlineLeave") {
    pattern = "/",
    callback = function()
        -- 102: EISU
        vim.fn.system([[
            osascript -e "tell application \"System Events\" to key code 102"
        ]])
    end,
}

local visual_match_ids = {}

local function free_visual_match()
    for winid, matchid in pairs(visual_match_ids) do
        pcall(vim.fn.matchdelete, matchid, winid)
    end
    visual_match_ids = {}
end

local function visual_match()
    free_visual_match()
    local in_visual_mode = vim.fn.index({ "v", "" }, vim.fn.mode(0)) ~= -1
    local selects_one_line = vim.fn.line("v") == vim.fn.line(".")
    if in_visual_mode and selects_one_line then
        local len_of_char_of_v = vim.fn.strlen(vim.fn.matchstr(vim.fn.getline("v"), ".", vim.fn.col("v") - 1))
        local len_of_char_of_dot = vim.fn.strlen(vim.fn.matchstr(vim.fn.getline("."), ".", vim.fn.col(".") - 1))
        local first = vim.fn.min { vim.fn.col("v") - 1, vim.fn.col(".") - 1 }
        local last = vim.fn.max {
            vim.fn.col("v") - 2 + len_of_char_of_v,
            vim.fn.col(".") - 2 + len_of_char_of_dot,
        }
        local visible_winids = vim.iter(vim.fn.winlayout())
            :flatten(math.huge)
            :filter(function(s)
                return type(s) == "number"
            end)
            :totable()
        for _, winid in ipairs(visible_winids) do
            local visual_match_id = vim.fn.matchadd(
                "VisualMatch",
                ([[\C\V%s]]):format(vim.fn.escape(vim.fn.getline("."):sub(first + 1, last + 1), [[\]])),
                10, --default
                -1, --default
                { window = winid }
            )
            visual_match_ids[winid] = visual_match_id
        end
    end
end

autocmd_vimrc("WinLeave") {
    desc = "Free instant visual highlight",
    callback = free_visual_match,
}

autocmd_vimrc { "CursorMoved", "CursorHold" } {
    desc = "Instant visual highlight",
    callback = visual_match,
}

vim.keymap.set({ "x", "s" }, "<Esc>", function()
    free_visual_match()
    return "<Esc>"
end, { expr = true })

autocmd_vimrc { "BufRead" } {
    desc = "foldlevel が 0（全てたたむ）のときは、カーソル周辺だけ fold 解除",
    callback = function()
        if vim.opt_local.foldlevel:get() == 0 then
            vim.cmd.normal("zv")
        end
    end,
}

-- §§1 保存時のコマンド実行

---@param callback fun(): nil
local function keep_cursor(callback)
    local curwin_id = vim.fn.win_getid()
    local view = vim.fn.winsaveview()
    local _, _ = pcall(callback)
    if vim.fn.win_getid() == curwin_id then
        vim.fn.winrestview(view)
    end
end

-- autocmd_vimrc("BufWritePost") {
--     pattern = { "*.lua", ".init.lua.local" },
--     callback = function()
--         -- fold の状態を保持するために mkview と loadview を入れた
--         vim.cmd([[mkview]])
--         keep_cursor(function()
--             vim.fn.system([[stylua --search-parent-directories ]] .. vim.fn.expand("%:p"))
--             vim.cmd([[edit]])
--         end)
--         vim.cmd([[loadview]])
--     end,
--     desc = "execute stylua",
-- }

-- autocmd "BufWritePost" {
--     pattern = { "*.typ" },
--     callback = function()
--         keep_cursor(function()
--             vim.fn.system([[typstfmt ]] .. vim.fn.expand "%:p")
--             vim.cmd [[edit]]
--         end)
--     end,
--     desc = "execute typstfmt",
-- }

-- auto repeatable macro （ドットリピートや通常マクロのほうが直感的なのでボツ）

-- local auto_repeatable = false
-- autocmd "VimEnter" {
--     pattern = "*",
--     callback = function()
--         vim.fn.setreg("p", "")
--         vim.keymap.set("n", ";", function()
--             -- if auto_repeatable then
--             --     if vim.fn.reg_recording() == "p" then
--             --         local preg = vim.fn.getreg "p"
--             --         vim.api.nvim_feedkeys("q", "n", true)
--             --         vim.fn.setreg("p", preg)
--             --         vim.print { "stop", vim.fn.getreg "p", prev_macro_content }
--             --     end
--             --     vim.api.nvim_feedkeys("@p", "n", true)
--             -- end
--             if auto_repeatable then
--                 local s = ""
--                 if vim.fn.reg_recording() == "p" then
--                     s = s .. "q"
--                 end
--                 s = s .. "@z"
--                 return s
--             end
--             return ""
--         end, { expr = true })
--         vim.api.nvim_feedkeys("qp", "n", true)
--     end,
--     desc = "execute text_changed",
-- }
--
-- autocmd "TextChanged" {
--     pattern = "*",
--     callback = function()
--         if vim.fn.reg_recording() == "p" then
--             vim.api.nvim_feedkeys("q", "n", true)
--             local current_macro_content = vim.fn.getreg "p"
--             auto_repeatable = vim.endswith(vim.fn.getreg "z", current_macro_content)
--             vim.fn.setreg("z", current_macro_content)
--         end
--         vim.print { vim.fn.getreg "p", auto_repeatable }
--         vim.api.nvim_feedkeys("qp", "n", true)
--     end,
--     desc = "execute text_changed",
-- }

-- local function node_range_in_cursor(range, curpos)
--     local r_s, c_s, r_e, c_e = unpack(range)
--     local _, r_cur, c_cur, _, _ = unpack(curpos)
--     r_cur = r_cur - 1
--     c_cur = c_cur - 1
--     -- range が単一行にある場合
--     if r_s == r_e then
--         return r_s == r_cur and c_s <= c_cur and c_cur < c_e
--     end
--     -- 行またぎの range かつあきらかに中にある場合
--     if r_s < r_cur and r_cur < r_e then
--         return true
--     end
--     -- 行またぎの range かつ境界の場合
--     if r_cur == r_s then
--         return c_s <= c_cur
--     end
--     if r_cur == r_e then
--         return c_cur < c_e
--     end
--     return false
-- end
--
-- local query = require "vim.treesitter.query"
-- local function cursor_at(match, _, source, predicate)
--     local node = match[predicate[2]]
--     if not node then
--         return true
--     end
--     return node_range_in_cursor({ node:range() }, vim.fn.getcurpos())
-- end
--
-- query.add_predicate("cursor-at?", cursor_at, false)
--
-- query.add_predicate("cursor-not-at?", function(match, a, source, predicate)
--     return not cursor_at(match, a, source, predicate)
-- end, false)
--
-- autocmd "CursorMoved" {
--     command = "redraw!",
-- }

local query = require("vim.treesitter.query")
local function bufname_vim_match(match, _, source, predicate)
    local regex = vim.regex(predicate[2])
    local foo = regex:match_str(vim.fn.bufname(source)) ~= nil
    return foo
end

query.add_predicate("bufname-vim-match?", bufname_vim_match, false)

-- §§1 Terminal

-- autocmd("TermOpen") {
--     pattern = "*",
--     callback = function(meta)
--         if not vim.endswith(meta.file, "fish") then
--             vim.cmd.startinsert()
--         end
--     end,
-- }

-- autocmd_vimrc("TermClose") {
--     pattern = "*",
--     callback = function()
--         pcall(vim.cmd.bdelete, { bang = true, args = { vim.fn.expand("<abuf>") } })
--     end,
-- }

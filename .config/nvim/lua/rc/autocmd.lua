-- vim:fdm=marker:fmr=§§,■■

local util = require("rc.util")

-- §§1 表示設定

util.autocmd_vimrc("StdinReadPost") {
    command = "set nomodified",
}

util.autocmd_vimrc { "WinLeave", "FocusLost", "InsertEnter" } {
    desc = "temporal attention の設定初期化",
    callback = function()
        vim.opt_local.cursorline = false
        vim.opt_local.cursorcolumn = false
        vim.opt_local.relativenumber = false
    end,
}

util.autocmd_vimrc("Syntax") {
    desc = "minlines と maxlines の設定",
    command = "syn sync minlines=500 maxlines=1000",
}

util.autocmd_vimrc { "VimEnter", "WinEnter" } {
    desc = "全角スペースハイライト (https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776)",
    command = [[
        highlight link UnicodeSpaces Error
        match UnicodeSpaces /[\u180E\u2000-\u200A\u2028\u2029\u202F\u205F\u3000]/
    ]],
}
util.autocmd_vimrc("ColorScheme") {
    desc = "UnicodeSpaces を Error 色にハイライトする",
    command = "highlight link UnicodeSpaces Error",
}

util.autocmd_vimrc("VimResized") {
    desc = "ウィンドウの画面幅を揃える",
    command = [[Normal! <C-w>=]],
}

-- autocmd BufRead * autocmd FileType <buffer> ++once
--   \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
util.autocmd_vimrc("BufRead") {
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

-- §§1 .init.lua.local
---@class LocalrcList
local LocalrcList = {
    -- 実行しても安全なディレクトリパスを保存しておくところ。
    whitelist = vim.fn.stdpath("data") .. "/localrc/whitelist",
    blacklist = vim.fn.stdpath("data") .. "/localrc/blacklist",

    create_root = function()
        if vim.fn.filewritable(vim.fn.stdpath("data") .. "/localrc") ~= 2 then
            vim.fn.mkdir(vim.fn.stdpath("data") .. "/localrc", "p")
        end
    end,

    ---保存されたパスの一覧を取得する。
    ---@param self LocalrcList
    ---@return string[]
    get_whitelist = function(self)
        if util.to_bool(vim.fn.filereadable(self.whitelist)) then
            return vim.fn.readfile(self.whitelist)
        end
        return {}
    end,

    ---保存されたパスの一覧を取得する。
    ---@param self LocalrcList
    ---@return string[]
    get_blacklist = function(self)
        if util.to_bool(vim.fn.filereadable(self.blacklist)) then
            return vim.fn.readfile(self.blacklist)
        end
        return {}
    end,

    ---安全なパスを追加する。
    ---@param self LocalrcList
    ---@param dir string
    append_whitelist = function(self, dir)
        local fullpath = vim.fn.fnamemodify(dir, ":p")
        self:create_root()
        vim.fn.writefile({ fullpath }, self.whitelist, "a")
    end,

    ---危険なパスを追加する。
    ---@param self LocalrcList
    ---@param dir string
    append_blacklist = function(self, dir)
        local fullpath = vim.fn.fnamemodify(dir, ":p")
        self:create_root()
        vim.fn.writefile({ fullpath }, self.blacklist, "a")
    end,

    ---与えられたパスがホワイトリストに登録されていれば true を返す。
    ---@param self LocalrcList
    ---@param path string
    ---@return boolean | nil
    is_safe = function(self, path)
        local fullpath = vim.fn.fnamemodify(path, ":p")
        local black_dirs = self:get_blacklist()
        for _, dir in ipairs(black_dirs) do
            if dir == fullpath then
                return false
            end
        end
        local white_dirs = self:get_whitelist()
        for _, dir in ipairs(white_dirs) do
            if dir == fullpath then
                return true
            end
        end
        return nil
    end,
}

local localrc_list = setmetatable({}, { __index = LocalrcList })

local function try_eval_init_lua_local()
    local cwd = vim.fn.getcwd()
    local init_lua_local = ("%s/.init.lua.local"):format(cwd)

    -- 無けりゃあ用はないぜ
    if not util.to_bool(vim.fn.filereadable(init_lua_local)) then
        return
    end

    vim.deprecate(".init.lua.local", ".nvim.lua", "0.11.0")

    if localrc_list:is_safe(cwd) then
        vim.cmd(([[luafile %s]]):format(init_lua_local))
        return
    end

    if localrc_list:is_safe(cwd) == false then
        util.print_error("This directory may contain malicious .init.lua.local file. Deleting the file is recommended.")
        return
    end

    vim.ui.select(
        {
            "Don't want to decide now (default)",
            "Add to whitelist and execute .init.lua.local immediately",
            "Add to whitelist but not execute .init.lua.local this time",
            "Add to BLACKLIST",
        },
        {
            prompt = ".init.lua.local file is found. How do you handle this?",
        },
        ---@param item string
        ---@param idx integer
        function(item, idx)
            if idx == 1 then
                return
            elseif idx == 2 then
                localrc_list:append_whitelist(cwd)
                vim.cmd(([[luafile %s]]):format(init_lua_local))
            elseif idx == 3 then
                localrc_list:append_whitelist(cwd)
            elseif idx == 4 then
                localrc_list:append_blacklist(cwd)
            else
                return
            end
        end
    )
end

util.autocmd_vimrc("VimEnter") {
    callback = try_eval_init_lua_local,
}

-- §§1 editor の機能

util.autocmd_vimrc("InsertLeave") {
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
    if util.to_bool(vim.v.cmdbang) then
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

util.autocmd_vimrc("BufWritePre") {
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

util.autocmd_vimrc("TextYankPost") {
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
            local content = vim.fn.getreg('"', nil, nil)
            if ignore_indent then
                content = remove_common_indent(content)
                ignore_indent = false
            end
            vim.fn.setreg("y", content)
            vim.fn.setreg("+", content)
        end
    end,
}

util.autocmd_vimrc("VimEnter") {
    desc = "マクロ用のレジスタを消去",
    callback = function()
        vim.fn.setreg("q", "")
    end,
}

-- util.autocmd_vimrc "VimEnter" {
--     desc = ".todome が cwd にあればそれを開く",
--     callback = function()
--         if #vim.v.argv > 2 then
--             -- Workaround: nvim を引数付きで開いた場合は後続処理を行わない。
--             -- 引数無しで開けば vim.v.argv は
--             -- {"nvim への絶対パス", "--embed"} みたいな配列になるため、
--             -- それ以外を弾く形。
--             return
--         end
--         if util.to_bool(vim.fn.filereadable ".todome") then
--             vim.cmd.edit ".todome"
--             vim.cmd.setfiletype "todome"
--             -- なぜか BufRead が発火しない
--             vim.cmd.normal [[g`"]]
--         end
--     end,
-- }

util.autocmd_vimrc("QuickfixCmdPost") {
    pattern = { "l*" },
    command = "lwin",
}

util.autocmd_vimrc("QuickfixCmdPost") {
    pattern = { "[^l]*" },
    command = "cwin",
}

util.autocmd_vimrc("CmdwinEnter") {
    callback = function(meta)
        local buf = meta.buf
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.foldcolumn = "0"
        vim.api.nvim_buf_set_keymap(buf, "n", "<C-f>", "<C-f>", {})
        vim.api.nvim_buf_set_keymap(buf, "n", "<C-u>", "<C-u>", {})
        vim.api.nvim_buf_set_keymap(buf, "n", "<C-b>", "<C-b>", {})
        vim.api.nvim_buf_set_keymap(buf, "n", "<C-d>", "<C-d>", {})
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", {})
        vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<CR>", { nowait = true })
    end,
}

-- ESC 時に英数キーを送るのは Karabiner でできるが、検索コマンドからの離脱時にも送りたい
-- https://rcmdnk.com/blog/2017/03/10/computer-mac-vim/
util.autocmd_vimrc("CmdlineLeave") {
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
        local visible_winids = vim.tbl_filter(function(s)
            return type(s) == "number"
        end, vim.tbl_flatten(vim.fn.winlayout()))
        for _, winid in ipairs(visible_winids) do
            local visual_match_id = vim.fn.matchadd(
                "VisualBlue",
                ([[\C\V%s]]):format(vim.fn.escape(vim.fn.getline("."):sub(first + 1, last + 1), [[\]])),
                10, --default
                -1, --default
                { window = winid }
            )
            visual_match_ids[winid] = visual_match_id
        end
    end
end

util.autocmd_vimrc("WinLeave") {
    desc = "Free instant visual highlight",
    callback = free_visual_match,
}

util.autocmd_vimrc { "CursorMoved", "CursorHold" } {
    desc = "Free instant visual highlight",
    callback = visual_match,
}

vim.keymap.set({ "x", "s" }, "<Esc>", function()
    free_visual_match()
    return "<Esc>"
end, { expr = true })

-- §§1 保存時のコマンド実行

---comment
---@param callback fun(): nil
local function keep_cursor(callback)
    local curwin_id = vim.fn.win_getid()
    local view = vim.fn.winsaveview()
    local _, _ = pcall(callback)
    if vim.fn.win_getid() == curwin_id then
        vim.fn.winrestview(view)
    end
end

util.autocmd_vimrc("BufWritePost") {
    pattern = { "*.lua", ".init.lua.local" },
    callback = function()
        -- fold の状態を保持するために mkview と loadview を入れた
        -- vim.cmd [[mkview]]
        -- vim.fn.system([[stylua --search-parent-directories ]] .. vim.fn.expand "%:p")
        -- vim.cmd [[edit]]
        -- vim.cmd [[loadview]]
        keep_cursor(function()
            vim.fn.system([[stylua --search-parent-directories ]] .. vim.fn.expand("%:p"))
            vim.cmd([[edit]])
        end)
    end,
    desc = "execute stylua",
}

-- util.autocmd_vimrc "BufWritePost" {
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
-- util.autocmd_vimrc "VimEnter" {
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
-- util.autocmd_vimrc "TextChanged" {
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
-- util.autocmd_vimrc "CursorMoved" {
--     command = "redraw!",
-- }

local query = require("vim.treesitter.query")
local function bufname_vim_match(match, _, source, predicate)
    local regex = vim.regex(predicate[2])
    local foo = regex:match_str(vim.fn.bufname(source)) ~= nil
    return foo
end

query.add_predicate("bufname-vim-match?", bufname_vim_match, false)

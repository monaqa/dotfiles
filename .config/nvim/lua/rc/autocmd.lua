-- vim:fdm=marker:fmr=§§,■■

local util = require "rc.util"

-- §§1 表示設定

util.autocmd_vimrc "StdinReadPost" {
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

util.autocmd_vimrc "Syntax" {
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
util.autocmd_vimrc "ColorScheme" {
    desc = "UnicodeSpaces を Error 色にハイライトする",
    command = "highlight link UnicodeSpaces Error",
}

util.autocmd_vimrc "VimResized" {
    desc = "ウィンドウの画面幅を揃える",
    command = [[Normal! <C-w>=]],
}

-- §§1 .init.lua.local
---@class LocalrcList
local LocalrcList = {
    -- 実行しても安全なディレクトリパスを保存しておくところ。
    whitelist = vim.fn.stdpath "data" .. "/localrc/whitelist",
    blacklist = vim.fn.stdpath "data" .. "/localrc/blacklist",

    create_root = function()
        if vim.fn.filewritable(vim.fn.stdpath "data" .. "/localrc") ~= 2 then
            vim.fn.mkdir(vim.fn.stdpath "data" .. "/localrc", "p")
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

    if localrc_list:is_safe(cwd) then
        vim.cmd(([[luafile %s]]):format(init_lua_local))
        return
    end

    if localrc_list:is_safe(cwd) == false then
        util.print_error "This directory may contain malicious .init.lua.local file. Deleting the file is recommended."
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

util.autocmd_vimrc "VimEnter" {
    callback = try_eval_init_lua_local,
}

-- §§1 editor の機能

util.autocmd_vimrc "InsertLeave" {
    desc = "挿入モードを抜けたら paste モードを off にする",
    callback = function()
        vim.o.paste = false
    end,
}

local function auto_mkdir()
    local dir = vim.fn.expand("<afile>:p:h", nil, nil)
    local is_empty = vim.fn.empty(dir) == 1
    local is_url = vim.fn.match(dir, [[^\w\+://]]) >= 0
    local is_directory = vim.fn.isdirectory(dir) == 1
    if is_empty or is_url or is_directory then
        return
    end
    if util.to_bool(vim.v.cmdbang) then
        vim.fn.mkdir(dir, "p")
        return
    end

    vim.fn.inputsave()
    vim.cmd [[echohl Question]]
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

util.autocmd_vimrc "BufWritePre" {
    desc = "保存時に必要があれば自動で mkdir する",
    callback = auto_mkdir,
}

util.autocmd_vimrc "TextYankPost" {
    desc = "無名レジスタへの yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）",
    callback = function()
        local event = vim.v.event
        if event.operator == "y" and event.regname == "" then
            vim.fn.setreg("+", vim.fn.getreg('"', nil, nil))
        end
    end,
}

util.autocmd_vimrc "VimEnter" {
    desc = "マクロ用のレジスタを消去",
    callback = function()
        vim.fn.setreg("q", "")
    end,
}

util.autocmd_vimrc "QuickfixCmdPost" {
    pattern = { "l*" },
    command = "lwin",
}

util.autocmd_vimrc "QuickfixCmdPost" {
    pattern = { "[^l]*" },
    command = "cwin",
}

util.autocmd_vimrc "CmdwinEnter" {
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
util.autocmd_vimrc "CmdlineLeave" {
    pattern = "/",
    callback = function()
        -- 102: EISU
        vim.fn.system [[
            osascript -e "tell application \"System Events\" to key code 102"
        ]]
    end,
}

local visual_match_ids = {}

local function free_visual_match()
    -- if util.to_bool(vim.fn.exists "w:visual_match_id") then
    --     vim.fn.matchdelete(vim.w.visual_match_id)
    --     vim.api.nvim_win_del_var(0, "visual_match_id")
    -- end

    for winid, matchid in pairs(visual_match_ids) do
        pcall(vim.fn.matchdelete, matchid, winid)
    end
    visual_match_ids = {}
end

local function visual_match()
    free_visual_match()
    local in_visual_mode = vim.fn.index({ "v", "" }, vim.fn.mode(0)) ~= -1
    local selects_one_line = vim.fn.line "v" == vim.fn.line "."
    if in_visual_mode and selects_one_line then
        local len_of_char_of_v = vim.fn.strlen(vim.fn.matchstr(vim.fn.getline "v", ".", vim.fn.col "v" - 1))
        local len_of_char_of_dot = vim.fn.strlen(vim.fn.matchstr(vim.fn.getline ".", ".", vim.fn.col "." - 1))
        local first = vim.fn.min { vim.fn.col "v" - 1, vim.fn.col "." - 1 }
        local last = vim.fn.max {
            vim.fn.col "v" - 2 + len_of_char_of_v,
            vim.fn.col "." - 2 + len_of_char_of_dot,
        }
        -- vim.w.visual_match_id = vim.fn.matchadd(
        --     "VisualBlue",
        --     ([[\C\V%s]]):format(vim.fn.escape(vim.fn.getline("."):sub(first + 1, last + 1), [[\]]))
        -- )
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

util.autocmd_vimrc "WinLeave" {
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

util.autocmd_vimrc "BufWritePost" {
    pattern = { "*.lua", ".init.lua.local" },
    callback = function()
        -- fold の状態を保持するために mkview と loadview を入れた
        vim.cmd [[mkview]]
        vim.fn.system([[stylua --search-parent-directories ]] .. vim.fn.expand "%:p")
        vim.cmd [[edit]]
        vim.cmd [[loadview]]
    end,
    desc = "execute stylua",
}

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
--             --         vim.pretty_print { "stop", vim.fn.getreg "p", prev_macro_content }
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
--         vim.pretty_print { vim.fn.getreg "p", auto_repeatable }
--         vim.api.nvim_feedkeys("qp", "n", true)
--     end,
--     desc = "execute text_changed",
-- }

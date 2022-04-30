-- vim:fdm=marker:fmr=§§,■■

-- §§1 表示設定
local function register_autocmd(event)
    return function (opts)
        opts["group"] = "vimrc"
        vim.api.nvim_create_autocmd(event, opts)
    end
end

register_autocmd("StdinReadPost"){
    command = "set nomodified",
}

register_autocmd{"BufLeave", "FocusLost", "InsertEnter"}{
    desc = "temporal attention の設定初期化",
    callback = function ()
        vim.wo.cursorline = false
        vim.wo.cursorcolumn = false
        vim.wo.relativenumber = false
    end
}

register_autocmd("Syntax"){
    desc = "minlines と maxlines の設定",
    command = "syn sync minlines=500 maxlines=1000"
}

register_autocmd{"VimEnter", "WinEnter"}{
    desc = "全角スペースハイライト (https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776)",
    command = [[
        highlight link UnicodeSpaces Error
        match UnicodeSpaces /[\u180E\u2000-\u200A\u2028\u2029\u202F\u205F\u3000]/
    ]]
}
register_autocmd("ColorScheme"){
    desc = "UnicodeSpaces を Error 色にハイライトする",
    command = "highlight link UnicodeSpaces Error"
}

register_autocmd("VimResized"){
    desc = "ウィンドウの画面幅を揃える",
    command = [[normal \<c-w>=]]
}

-- §§1 .vimrc.local
local function eval_vimrc_local()
    local cwd = vim.fn.getcwd()
    local vimrc_local = ("%s/.vimrc.local"):format(cwd)
    local init_lua_local = ("%s/.init.lua.local"):format(cwd)
    if vim.fn.filereadable(vimrc_local) == 1 then
        vim.cmd(([[source %s]]):format(vimrc_local))
    end
    if vim.fn.filereadable(init_lua_local)  == 1 then
        vim.cmd(([[luafile %s]]):format(init_lua_local))
    end
end

register_autocmd("VimEnter"){
    callback = eval_vimrc_local
}

-- §§1 editor の機能

register_autocmd("InsertLeave"){
    desc = "挿入モードを抜けたら paste モードを off にする",
    callback = function ()
        vim.o.paste = false
    end
}

local function auto_mkdir()
    local dir = vim.fn.expand("<afile>:p:h", nil, nil)
    local is_empty = vim.fn.empty(dir) == 1
    local is_url = vim.fn.match(dir, [[^\w\+://]]) >= 0
    local is_directory = vim.fn.isdirectory(dir) == 1
    if is_empty or is_url or is_directory then
        return
    end
    if vim.v.cmdbang == 1 then
        vim.fn.mkdir(dir, "p")
        return
    end

    vim.fn.inputsave()
    vim.cmd([[echohl Question]])
    local result = vim.ui.input({
        prompt = ([=["%s" does not exist. Create? [y/N]]=]):format(dir),
        -- highlight = "Question",
        default = "",
    }, function (result)
        if result == "y" then
            vim.fn.mkdir(dir, "p")
        end
    end)
    vim.fn.inputrestore()
end

register_autocmd("BufWritePre"){
    desc = "保存時に必要があれば自動で mkdir する",
    callback = auto_mkdir
}

register_autocmd("TextYankPost"){
    desc = "無名レジスタへの yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）",
    callback = function ()
        local event = vim.v.event
        if event.operator == "y" and event.regname == "" then
            vim.fn.setreg("+", vim.fn.getreg("+", nil, nil))
        end
    end
}

register_autocmd("VimEnter"){
    desc = "マクロ用のレジスタを消去",
    callback = function ()
        vim.fn.setreg("q", "")
    end
}

register_autocmd("QuickfixCmdPost"){
    pattern = {"l*"},
    command = "lwin"
}

register_autocmd("QuickfixCmdPost"){
    pattern = {"[^l]*"},
    command = "cwin"
}

register_autocmd("CmdwinEnter"){
    callback = function (meta)
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
        vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<CR>", {nowait = true})
    end
}

local function free_visual_match()
    if vim.fn.exists("w:visual_match_id") == 1 then
        vim.fn.matchdelete(vim.w.visual_match_id)
        vim.api.nvim_win_del_var(0, "visual_match_id")
    end
end

local function visual_match()
    free_visual_match()
    local in_visual_mode = vim.fn.index({"v", ""}, vim.fn.mode(0)) ~= -1
    local selects_one_line = vim.fn.line("v") == vim.fn.line(".")
    if in_visual_mode and selects_one_line then
        local len_of_char_of_v = vim.fn.strlen(vim.fn.matchstr(
            vim.fn.getline("v"), ".", vim.fn.col("v") - 1
        ))
        local len_of_char_of_dot = vim.fn.strlen(vim.fn.matchstr(
            vim.fn.getline("."), ".", vim.fn.col(".") - 1
        ))
        local first = vim.fn.min({ vim.fn.col("v") - 1, vim.fn.col(".") - 1 })
        local last = vim.fn.max({
            vim.fn.col("v") - 2 + len_of_char_of_v,
            vim.fn.col(".") - 2 + len_of_char_of_dot,
        })
        vim.w.visual_match_id = vim.fn.matchadd(
            "VisualBlue",
            ([[\C\V%s]]):format(vim.fn.escape(vim.fn.getline("."):sub(first + 1, last + 1), [[\]]))
        )
    end
end

register_autocmd("WinLeave"){
    desc = "Free instant visual highlight",
    callback = free_visual_match
}

register_autocmd{"CursorMoved", "CursorHold"}{
    desc = "Free instant visual highlight",
    callback = visual_match
}

vim.keymap.set({"x", "s"}, "<Esc>", function ()
    free_visual_match()
    return "<Esc>"
end, { expr = true })

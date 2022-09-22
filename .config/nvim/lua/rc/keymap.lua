-- vim:fdm=marker:fmr=§§,■■
-- キーマッピング関連。
-- そのキーマップが適切に動くようにするための関数や autocmd もここに載せる。

local M = {}

local util = require("rc.util")

vim.keymap.set("c", "<C-c>", "<C-f>")

-- §§1 changing display

-- Z を signcolumn/foldcolumn の toggle に使う
vim.keymap.set("n", "ZZ", "<Nop>")
vim.keymap.set("n", "ZQ", "<Nop>")

-- local function toggle_column()
--     if vim.opt_local.signcolumn == "yes:2" and vim.opt_local.foldcolumn == "0" then
--         vim.opt_local.foldcolumn = "4"
--         vim.opt_local.signcolumn = "no"
--     else
--         vim.opt_local.foldcolumn = "0"
--         vim.opt_local.signcolumn = "yes:2"
--     end
-- end
-- 
-- vim.keymap.set("n", "Z", toggle_column, { silent = true, nowait = true })

local function toggle_wrap()
    vim.o.wrap = not vim.o.wrap
end

vim.keymap.set("n", "Z", toggle_wrap, { silent = true, nowait = true })

vim.api.nvim_create_augroup("vimrc_temporal", {clear = true})

function M.temporal_attention()
    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
    vim.api.nvim_create_autocmd("CursorMoved", {
        once = true,
        group = "vimrc_temporal",
        callback = function ()
            vim.opt_local.cursorline = false
            vim.opt_local.cursorcolumn = false
        end
    })
end

function M.temporal_relnum()
    vim.opt_local.relativenumber = true
    vim.api.nvim_create_autocmd("CursorMoved", {
        once = true,
        group = "vimrc_temporal",
        callback = function ()
            vim.opt_local.relativenumber = false
        end
    })
end

function M.expr_temporal_attention()
    M.temporal_attention()
    M.temporal_relnum()
    return ""
end

vim.keymap.set({"n", "o", "x"}, "+", M.expr_temporal_attention, {expr = true})

-- §§1 fold

-- 自分のいない level が 1 の fold だけたたむ
-- vim.keymap.set("n", "<Space>z", "zMzA", {})
vim.keymap.set("n", "<Space>z", "zx", {})

-- §§1 search

vim.keymap.set("n", "<C-l>", ":<C-u>nohlsearch<CR><C-l>", {})

-- 検索 with temporal attention
vim.keymap.set("n", "n", util.trim[[
    'Nn'[v:searchforward] .. '<Cmd>lua require("rc.keymap").temporal_attention()<CR>'
]], {expr = true})

vim.keymap.set("n", "N", util.trim[[
    'nN'[v:searchforward] .. '<Cmd>lua require("rc.keymap").temporal_attention()<CR>'
]], {expr = true})

-- VISUAL モードから簡単に検索
-- http://vim.wikia.com/wiki/Search_for_visually_selected_text
vim.keymap.set("x", "*", table.concat{
    -- 選択範囲を検索クエリに用いるため、m レジスタに格納。
    -- ビジュアルモードはここで抜ける。
    [["my]],
    -- "m レジスタの中身を検索。
    -- ただし必要な文字はエスケープした上で、空白に関しては伸び縮み可能とする
    [[/\V<C-R><C-R>=substitute(escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>]],
    -- 先ほど検索した範囲にカーソルが移るように、手前に戻す
    [[N]],
}, {})
vim.keymap.set("x", "R", table.concat{
    -- 選択範囲を置換後のクエリに用いるため、m レジスタに格納。
    -- ビジュアルモードはここで抜ける。
    [["my]],
    -- やっぱり置換対象へのハイライトはあったほうがいいよねってことで
    [[:set hlsearch<CR>]],
    -- 前回検索した場所を、"m レジスタの中身に置換する。
    -- ただし置換対象ならではの特殊文字はエスケープしておく。
    -- 現在の位置から置換を行う。次のコマンドに <Bar> でつなぐ。
    [[:,$s//<C-R><C-R>=escape(@m, '/\&~')<CR>/gce<Bar>]],
    -- 上と同様の置換を、ファイル先頭に戻って再度カーソルの位置まで行う。
    [[1,''-&&<CR>]],
}, {})

-- §§2 QuickFix search
vim.keymap.set("n", "g/", function ()
    local query = vim.fn.input("g/")
    vim.fn.setreg("/", [[\v]] .. query)
    -- hlsearch の有効化
    vim.o.hlsearch = vim.o.hlsearch

    return [[:\<C-u>silent grep ]] .. vim.fn.string(query) .. [[ .]]
end, {expr = true} )

vim.keymap.set("n", "gj", util.cmdcr"cnext" .. "zz", {})
vim.keymap.set("n", "gk", util.cmdcr"cprevious" .. "zz", {})

-- https://qiita.com/lighttiger2505/items/166a4705f852e8d7cd0d
-- Toggle QuickFix
local function toggle_quickfix()
    local nr1 = vim.fn.winnr('$')
    vim.cmd[[cwindow]]
    local nr2 = vim.fn.winnr('$')
    if nr1 == nr2 then
        vim.cmd[[cclose]]
    end
end
vim.keymap.set("n", "q", toggle_quickfix, {script = true, silent = true})

-- §§1 terminal

vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], {})

local function terminal_init()
    vim.keymap.set("n", "<CR>", [[i<CR><C-\><C-n>]], {buffer = true})
    vim.keymap.set("n", "sw", [[:<C-u>bd!<CR>]], {buffer = true})
    vim.keymap.set("n", "t", [[:<C-u>let g:current_terminal_job_id = b:terminal_job_id<CR>]], {buffer = true})
    vim.keymap.set("n", "dd", [[i<C-u><C-\><C-n>]], {buffer = true})
    vim.keymap.set("n", "A", [[i<C-e>]], {buffer = true})
    vim.keymap.set("n", "p", [[pi]], {buffer = true})
    vim.keymap.set("n", "<C-]>", [[<Nop>]], {buffer = true})

    -- vim.keymap.set("n", "I",
    --     [["i\<C-a>" .. repeat("\<Right>", <SID>calc_cursor_right_num())]],
    --     {buffer = true, expr = true}
    -- )

    vim.keymap.set("n", "u",
        [["i" .. repeat("<Up>", v:count1) .. "<C-\><C-n>"]],
        {buffer = true, expr = true}
    )
    vim.keymap.set("n", "<C-r>",
        [["i" .. repeat("<Down>", v:count1) .. "<C-\><C-n>"]],
        {buffer = true, expr = true}
    )

    -- vim.opt_local.wrap = true
    -- vim.opt_local.number = false
    -- vim.opt_local.signcolumn = "no"
    -- vim.opt_local.foldcolumn = "0"
    vim.opt_local.wrap = true
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
end

util.autocmd_vimrc("TermOpen"){
    callback = terminal_init,
    -- buffer = true
}

local function open_terminal()
    util.split_window()
    vim.cmd[[terminal fish]]
    vim.g.current_terminal_job_id = vim.b.terminal_job_id
end

local function open_term_window()
    if vim.fn.bufname("term://") == "" then
        open_terminal()
        return
    end

    util.split_window()
    vim.cmd[[buffer term://]]
end

vim.keymap.set("n", "st", open_term_window, {})

-- §§2 send string to terminal buffer

---ペースト時に bracketed paste mode を有効にする。
---@type boolean
_G.vimrc.bracketed_paste_mode = true
_G.vimrc.wezterm_bracketed_paste_mode = true

vim.api.nvim_create_user_command("ToggleBracketedPasteMode", function ()
    _G.vimrc.bracketed_paste_mode = not _G.vimrc.bracketed_paste_mode
    if _G.vimrc.bracketed_paste_mode then
        vim.api.nvim_echo({{"bracketed_paste_mode: on", "Normal"}}, true, {})
    else
        vim.api.nvim_echo({{"bracketed_paste_mode: off", "Normal"}}, true, {})
    end
end, {})

local function reformat_cmdstring(str)
    str = util.trim(str)
    if _G.vimrc.bracketed_paste_mode then
        return util.esc"[200~" .. str .. "\n" .. util.esc"[201~\n"
    else
        return str .. "\n"
    end
end

function _G.vimrc.op.send_terminal(type)
    local sel_save = vim.o.selection
    vim.o.selection = "inclusive"
    local m_reg = vim.fn.getreg("m", nil, nil)

    local visual_range
    if type == "line" then
        visual_range = "'[V']"
    else
        visual_range = "`[V`]"
    end
    vim.cmd("normal! " .. visual_range .. '"my')
    local content = vim.fn.getreg("m", nil, nil)
    vim.fn.chansend(vim.g.current_terminal_job_id, reformat_cmdstring(content))

    vim.o.selection = sel_save
    vim.fn.setreg("m", m_reg, nil)
end

vim.keymap.set({"n", "x"}, "S", function ()
    vim.o.operatorfunc = "v:lua.vimrc.op.send_terminal"
    return "g@"
end, {expr = true})

vim.keymap.set({"n"}, "SS", function ()
    vim.o.operatorfunc = "v:lua.vimrc.op.send_terminal"
    return "g@_"
end, {expr = true, nowait = true})

vim.api.nvim_create_user_command("WeztermNewPane", function ()
    _G.vimrc.wezterm_terminal_pane_id = vim.fn.system("wezterm cli split-pane --horizontal", nil)
end, {})
vim.api.nvim_create_user_command("WeztermNewWindow", function ()
    _G.vimrc.wezterm_terminal_pane_id = vim.fn.system("wezterm cli spawn --new-window --cwd " .. vim.fn.getcwd(nil, nil), nil)
end, {})
vim.api.nvim_create_user_command("WeztermUnlinkPane", function ()
    _G.vimrc.wezterm_terminal_pane_id = nil
end, {})

vim.keymap.set({"n", "x"}, "T", function ()
    vim.o.operatorfunc = "v:lua.vimrc.op.send_wezterm"
    return "g@"
end, {expr = true})

vim.keymap.set({"n"}, "TT", function ()
    vim.o.operatorfunc = "v:lua.vimrc.op.send_wezterm"
    return "g@_"
end, {expr = true, nowait = true})

local function reformat_cmdstring_wezterm(str)
    str = util.trim(str)
    if _G.vimrc.bracketed_paste_mode then
        return str .. util.esc"[201~" .. "\n" .. util.esc"[200~\n"
    else
        return str .. "\n"
    end
end

local function send_wezterm(text)
    local command = "wezterm cli send-text --pane-id " .. _G.vimrc.wezterm_terminal_pane_id
    vim.fn.system(command, reformat_cmdstring_wezterm(text))
end

function _G.vimrc.op.send_wezterm(type)
    if _G.vimrc.wezterm_terminal_pane_id == nil then
        vim.api.nvim_echo({{"There is no active wezterm pane to send. execute :WeztermNewPane to spawn new pane.", "Error"}}, true, {})
        return
    end

    local sel_save = vim.o.selection
    vim.o.selection = "inclusive"
    local m_reg = vim.fn.getreg("m", nil, nil)

    local visual_range
    if type == "line" then
        visual_range = "'[V']"
    else
        visual_range = "`[V`]"
    end
    vim.cmd("normal! " .. visual_range .. '"my')
    local content = vim.fn.getreg("m", nil, nil)
    send_wezterm(content)

    vim.o.selection = sel_save
    vim.fn.setreg("m", m_reg, nil)
end

-- §§1 input Japanese character

vim.keymap.set({"n", "x", "o"}, "fj", "f<C-k>j", {})
vim.keymap.set({"n", "x", "o"}, "tj", "t<C-k>j", {})
vim.keymap.set({"n", "x", "o"}, "Fj", "F<C-k>j", {})
vim.keymap.set({"n", "x", "o"}, "Tj", "T<C-k>j", {})

---digraph を登録する。
---@param key_pair string
---@param char string
local function register_digraph(key_pair, char)
    vim.cmd(("digraphs %s %s"):format(key_pair, vim.fn.char2nr(char, nil)))
end

-- これを設定することで， fjj を本来の fj と同じ効果にできる．
register_digraph('jj', 'j')

-- カッコ
register_digraph('j(', '（')
register_digraph('j)', '）')
register_digraph('j[', '「')
register_digraph('j]', '」')
register_digraph('j{', '『')
register_digraph('j}', '』')
register_digraph('j<', '【')
register_digraph('j>', '】')

-- 句読点
register_digraph('j,', '、')
register_digraph('j.', '。')
register_digraph('j!', '！')
register_digraph('j?', '？')
register_digraph('j:', '：')

-- その他の記号
register_digraph('j~', '〜')
register_digraph('j/', '・')
register_digraph('js',  '␣')
register_digraph('j ',  '　')
register_digraph('zs',  '​')

-- §§1 window/buffer

vim.keymap.set("n", "s", "<Nop>", {})

vim.keymap.set("n", "ss", util.split_window, {})

vim.keymap.set("n", "s_", util.cmdcr"split", {})
vim.keymap.set("n", "s<Bar>", util.cmdcr"vsplit", {})
vim.keymap.set("n", "sv", util.cmdcr"vsplit", {})
vim.keymap.set("n", "sq", util.cmdcr"close", {})

for _, char in ipairs{
    "h", "j", "k", "l",
    "H", "J", "K", "L",
    "=",
} do
    vim.keymap.set("n", "s" .. char, "<C-w>" .. char, {})
end

vim.keymap.set("n", "sT", util.cmdcr"tabnew %")
vim.keymap.set("n", "sQ", util.cmdcr"tabclose")
vim.keymap.set("n", "s:", "q:G")
vim.keymap.set("n", "s?", "q?G")
vim.keymap.set("n", "s/", "q/G")
vim.keymap.set("n", "-", "<C-^>")

vim.keymap.set("n", "srb", "<Nop>", {nowait = true})

-- §§1 operator/text editing

-- どうせ空行1行なんて put するようなもんじゃないし、空行で上書きされるの嫌よね
vim.keymap.set("n", "dd", function ()
    if vim.v.count1 == 1 and vim.v.register == [["]] and vim.fn.getline(".") == "" then
        return [["_dd]]
    else
        return "dd"
    end
end, {expr = true})

vim.keymap.set("i", "<C-r><C-r>", [[<C-g>u<C-r>"]], {})
-- vim.keymap.set({"i"}, "<C-r><C-r>", function ()
--     vim.pretty_print(vim.fn.pumvisible())
--     if vim.fn.pumvisible() ~= 0 then
--         return "<C-e>"
--     else
--         return [[<C-g>u<C-r>"]]
--     end
-- end, {expr = true})

vim.keymap.set("i", "<C-r><CR>", [[<C-g>u<C-r>0]], {})
vim.keymap.set("i", "<C-r><Space>", [[<C-g>u<C-r>+]], {})
vim.keymap.set("c", "<C-r><C-r>", [[<C-r>"]], {})
vim.keymap.set("c", "<C-r><CR>", [[<C-r>0]], {})
vim.keymap.set("c", "<C-r><Space>", [[<C-r>+]], {})

vim.keymap.set("n", "<Space>p", util.cmdcr"put +", {})
vim.keymap.set("n", "<Space>P", util.cmdcr"put! +", {})

local function visual_replace(register)
    return function ()
        local reg_body = vim.fn.getreg(register, nil, nil)
        vim.cmd([[normal! "]] .. register .. "p")
        vim.fn.setreg(register, reg_body)
    end
end

vim.keymap.set("x", "<Space>p", visual_replace("+"), {})
-- TODO: v:register を渡せる visual_replace
vim.keymap.set("x", "p", visual_replace('"'), {})

vim.keymap.set("n", "R", "gR", {})

vim.keymap.set("n", "<Space><CR>", "a<CR><Esc>")

-- 改行だけを入力する dot-repeatable なマッピング
local function append_new_lines(offset_line)
    return require("peridot").repeatable_edit(function (ctx)
        local curpos = vim.fn.line(".")
        local pos_line = curpos + offset_line
        local n_lines = ctx.count1
        local lines = util.rep_elem("", n_lines)
        vim.fn.append(pos_line, lines)
    end)
end
vim.keymap.set("n", "<Space>o", append_new_lines(0), {expr = true})
vim.keymap.set("n", "<Space>O", append_new_lines(-1), {expr = true})

local function increment_char(forward)
    return require("peridot").repeatable_edit(function(ctx)
        local direction = util.ifexpr(forward, 1, -1)
        vim.cmd[[normal! v"my]]
        local char = vim.fn.getreg("m", nil, nil)
        local num = vim.fn.char2nr(char)
        vim.fn.setreg("m", vim.fn.nr2char(num + direction * ctx.count1))
        vim.cmd[[normal! gv"mp]]
    end)
end
vim.keymap.set("n", "<Space>a", increment_char(1), {expr = true})
vim.keymap.set("n", "<Space>x", increment_char(-1), {expr = true})

-- local function increment_char(direction)
--     return function()
--         vim.cmd[[normal! v"my]]
--         local char = vim.fn.getreg("m", nil, nil)
--         local num = vim.fn.char2nr(char)
--         vim.fn.setreg("m", vim.fn.nr2char(num + direction * vim.v.count1))
--         vim.cmd[[normal! gv"mp]]
--     end
-- end
-- vim.keymap.set("n", "<Space>a", increment_char(1))
-- vim.keymap.set("n", "<Space>x", increment_char(-1))

-- §§1 motion/text object

-- §§2 charwise motion

vim.keymap.set("i", "<C-b>", "<C-g>U<Left>")
vim.keymap.set("i", "<C-f>", "<C-g>U<Right>")
vim.keymap.set("i", "<C-Space>", "<Space>")

vim.keymap.set("i", "<C-Space>", "<Space>")

-- smart home/end
vim.keymap.set( {"n", "x"} , "<Space>h", function ()
    local str_before_cursor = vim.fn.strpart(vim.fn.getline("."), 0, vim.fn.col(".") - 1)
    local move_cmd
    -- カーソル前がインデントしかないかどうかでコマンドを変える
    if vim.regex([[^\s*$]]):match_str(str_before_cursor) then
        move_cmd = '0'
    else
        move_cmd = '^'
    end

    local col_before = vim.fn.col(".")
    -- まずは表示行の範囲で行頭移動
    vim.cmd("normal! g" .. move_cmd)
    -- 移動前後でカーソル位置が変わらなかったら再度やり直す
    local col_after = vim.fn.col(".")
    if col_before == col_after then
        vim.cmd("normal! " .. move_cmd)
    end
end)
vim.keymap.set("o", "<Space>h", "^")

-- smart end
vim.keymap.set( "n" , "<Space>l", function ()
    local col_before = vim.fn.col(".")
    -- まずは表示行の範囲で行頭移動
    vim.cmd"normal! g$"
    -- 移動前後でカーソル位置が変わらなかったら再度やり直す
    local col_after = vim.fn.col(".")
    if col_before == col_after then
        vim.cmd"normal! $"
    end
end)
vim.keymap.set("x", "<Space>l", "$h")
-- vim.keymap.set("o", "<Space>l", "$")
-- vim.keymap.set("o", "<Space>l", function ()
--     vim.cmd"normal! m["
--     vim.cmd"normal! $"
--     if vim.v.count == vim.v.count1 then
--         vim.cmd(("normal! %sh"):format(vim.v.count))
--     end
--     vim.cmd"normal! m]"
-- end)
vim.keymap.set("o", "<Space>l",
    require("peridot").repeatable_textobj(function(ctx)
        vim.cmd"normal! v$h"
        if ctx.set_count then
            vim.cmd(("normal! %sh"):format(ctx.count))
        end
    end),
    {expr = true}
)

vim.keymap.set("o", "u", "t_")
vim.keymap.set("o", "U", function ()
    for _ = 1, vim.v.count1, 1 do
        vim.fn.search("[A-Z]", "", vim.fn.line("."))
    end
end)

vim.keymap.set({"n", "x", "o"}, "m)", "])")
vim.keymap.set({"n", "x", "o"}, "m}", "]}")
vim.keymap.set("x", "m]", "i]o``")
vim.keymap.set("x", "m(", "i)``")
vim.keymap.set("x", "m{", "i}``")
vim.keymap.set("x", "m[", "i]``")

vim.keymap.set("n", "dm]", "vi]o``d")
vim.keymap.set("n", "dm(", "vi)``d")
vim.keymap.set("n", "dm{", "vi}``d")
vim.keymap.set("n", "dm[", "vi]``d")

vim.keymap.set("n", "cm]", "vi]o``c")
vim.keymap.set("n", "cm(", "vi)``c")
vim.keymap.set("n", "cm{", "vi}``c")
vim.keymap.set("n", "cm[", "vi]``c")

vim.keymap.set({"x", "o"}, [[a']], [[2i']])
vim.keymap.set({"x", "o"}, [[a"]], [[2i"]])
vim.keymap.set({"x", "o"}, [[a`]], [[2i`]])
vim.keymap.set({"x", "o"}, [[m']], [[a']])
vim.keymap.set({"x", "o"}, [[m"]], [[a"]])
vim.keymap.set({"x", "o"}, [[m`]], [[a`]])

-- Command mode mapping

vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<Up>", "<C-p>")
vim.keymap.set("c", "<Down>", "<C-n>")


-- §§2 linewise motion

vim.keymap.set("n", "j", function () if vim.v.count == 0 then return "gj" else return "j" end end, {expr = true})
vim.keymap.set("n", "k", function () if vim.v.count == 0 then return "gk" else return "k" end end, {expr = true})
vim.keymap.set("x", "j", function () if vim.v.count == 0 and vim.fn.mode(0) == "v" then return "gj" else return "j" end end, {expr = true})
vim.keymap.set("x", "k", function () if vim.v.count == 0 and vim.fn.mode(0) == "v" then return "gk" else return "k" end end, {expr = true})

-- Vertical WORD (vWORD) 単位での移動
_G.vimrc.par_motion_continuous = false
util.autocmd_vimrc("CursorMoved"){
    callback = function ()
        _G.vimrc.par_motion_continuous = false
    end
}

function _G.vimrc.smart_par_motion(forward)
    vim.cmd(table.concat{
        util.ifexpr(_G.vimrc.par_motion_continuous, "keepjumps ", ""),
        "normal! ",
        tostring(vim.v.count1),
        util.ifexpr(forward, "}", "{"),
    })
end

vim.keymap.set({"n", "x", "o"}, "<C-j>",
    util.cmdcr"call v:lua.vimrc.smart_par_motion(v:true)"
    .. util.cmdcr"lua _G.vimrc.par_motion_continuous = true"
)
vim.keymap.set({"n", "x", "o"}, "<C-k>",
    util.cmdcr"call v:lua.vimrc.smart_par_motion(v:false)"
    .. util.cmdcr"lua _G.vimrc.par_motion_continuous = true"
)

-- vertical f motion
local vertical_f_char
local vertical_f_pattern

local function vertical_f(ctx, forward)
    local pattern
    if forward then
        pattern = [[^\%>.l\s*\zs]]
    else
        pattern = [[^\%<.l\s*\zs]]
    end

    local visual_match_id = vim.fn.matchadd("VisualBlue", pattern .. ".")
    vim.opt_local.cursorline = true
    vim.cmd"redraw"
    local char
    if ctx.repeated then
        char = vertical_f_char
    else
        char = vim.fn.nr2char(vim.fn.getchar())
        vertical_f_char = char
    end
    vertical_f_pattern = pattern .. [[\V]] .. vim.fn.escape(char, [[\/]])
    vim.fn.matchdelete(visual_match_id)
    vim.opt_local.cursorline = false
    local flag = "W"
    if not forward then
        flag = flag .. "b"
    end
    for _ = 1, ctx.count1, 1 do
        vim.fn.search(vertical_f_pattern, flag)
    end
end

local function get_initial_ctx()
    return {
        repeated = false,
        count = vim.v.count,
        count1 = vim.v.count1,
        set_count = vim.v.count == vim.v.count1,
    }
end

vim.keymap.set({"n", "x"}, "<Space>f", function() vertical_f(get_initial_ctx(), true) end)
vim.keymap.set(
    "o", "<Space>f",
    require("peridot").repeatable_textobj(function(ctx) vertical_f(ctx, true) end),
    {expr = true}
)

vim.keymap.set({"n", "x"}, "<Space>F", function() vertical_f(get_initial_ctx(), false) end)
vim.keymap.set(
    "o", "<Space>F",
    require("peridot").repeatable_textobj(function(ctx) vertical_f(ctx, false) end),
    {expr = true}
)

-- vim.keymap.set({"n", "x"}, "<Space>F", vertical_f(false), {expr = true})

-- §§1 Macros

-- マクロの記録レジスタは "aq のような一般のレジスタを指定するのと同様の
-- インターフェースで変更するようにし、デフォルトの記録レジスタを q とする。
-- マクロの自己再帰呼出しによるループや、マクロの中でマクロを呼び出すことは簡単にはできないようにしている。
-- （もちろんレジスタを直接書き換えれば可能）
-- デフォルトのレジスタ @q は Vim の開始ごとに初期化される。

local function keymap_toggle_macro()
    if util.to_bool(vim.fn.reg_recording()) then
        -- 既に記録中の時は止める
        return "q"
    end
    -- 無名レジスタには格納できないようにする & デフォルトを q にする

    local register = vim.v.register
    if register == [["]] then
        register = "q"
    end
    return "q" .. register
end

_G.vimrc.last_played_macro_register = "q"

local function keymap_play_macro()
    -- 無名レジスタには格納できないようにする
    -- & デフォルトを前回再生したマクロにする
    local register = vim.v.register
    if register == [["]] then
        register = _G.vimrc.last_played_macro_register
    end
    _G.vimrc.last_played_macro_register = register
    if vim.fn.getreg(register, nil, nil) == "" then
        vim.api.nvim_echo({{("Register @%s is empty."):format(register), "Error"}}, true, {})
        return ""
    end

    vim.api.nvim_echo({{("Playing macro: @%s"):format(register), "Error"}}, false, {})
    return "@" .. register
end

local function keymap_cancel_macro()
    local register = vim.fn.reg_recording()
    if register == "" then
        return ""
    end
    return table.concat{
        -- 現在のレジスタに入っているコマンド列を一旦 reg_content に退避
        util.cmdcr(("let reg_content = @%s"):format(register)),
        -- マクロの記録を停止
        'q',
        -- 対象としていたレジスタの中身を先程退避したものに入れ替える
        util.cmdcr(("let @%s = reg_content"):format(register)),
        -- キャンセルした旨を表示
        util.cmdcr(("echo 'Recording cancelled: @%s'"):format(register)),
    }
end

vim.keymap.set("n", "Q", keymap_toggle_macro, {expr = true})
vim.keymap.set("n", "<C-q>", function ()
    if vim.fn.reg_recording() == "" then
        return keymap_play_macro()
    else
        return keymap_cancel_macro()
    end
end, {expr = true})
vim.keymap.set("n", "@", "<Nop>")
vim.keymap.set("n", "@:", "@:")

-- §§1 特殊キー
for i = 1, 12, 1 do
    vim.keymap.set({"n", "x", "o"}, ("<F%s>"):format(i), "<Nop>")
end
vim.keymap.set({"n", "x", "o", "i", "c", "s"}, "<M-F1>", "<Nop>")
vim.keymap.set({"i", "c", "s"}, "<F1>", "<Nop>")
vim.keymap.set({"n", "x", "o"}, "<Space>", "<Nop>")
vim.keymap.set({"n", "x", "o"}, "<CR>", "<Nop>")

-- §§1 その他
vim.keymap.set("n", "<C-h>", "g;")
vim.keymap.set("n", "<C-g>", "g,")

-- <C-x> 絶妙に押しづらいから…
vim.keymap.set("i", "<C-g>", "<C-x>")

vim.keymap.set("v", "<C-a>", "<C-a>gv")
vim.keymap.set("v", "<C-x>", "<C-x>gv")

vim.keymap.set("n", "gf", "gF")

vim.keymap.set({"i", "c"}, "<C-v>u", "<C-r>=nr2char(0x)<Left>")

-- https://github.com/ompugao/vim-bundle/blob/074e7b22320ad4bfba4da5516e53b498ace35a89/vimrc
vim.keymap.set("v", "I", function () return util.ifexpr(vim.fn.mode(0) == "V", "<C-v>0o$I", "I") end, {expr = true})
vim.keymap.set("v", "A", function () return util.ifexpr(vim.fn.mode(0) == "V", "<C-v>0o$A", "A") end, {expr = true})

return M

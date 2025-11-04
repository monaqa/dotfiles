-- vim:fdm=marker:fmr=--\ Section,■■
-- キーマッピング関連。
-- そのキーマップが適切に動くようにするための関数や autocmd もここに載せる。

local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset
local create_cmd = monaqa.shorthand.create_cmd
local autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
local logic = monaqa.logic
local window = monaqa.window
local submode = require("rc.submode")

-- Section1 changing display

-- Z を表示の toggle に使う
mapset.n("ZZ") { "<Nop>", desc = [[Z を表示の toggle に使うため無効化]] }
mapset.n("ZQ") { "<Nop>", desc = [[Z を表示の toggle に使うため無効化]] }
mapset.n("Z") {
    desc = [[wrap の toggle]],
    function()
        vim.opt_local.wrap = not vim.opt_local.wrap:get()
    end,
    silent = true,
    nowait = true,
}

mapset.nxo("+") {
    desc = [[temporal attention]],
    function()
        vim.opt_local.relativenumber = true
        vim.opt_local.cursorline = true
        vim.opt_local.cursorcolumn = true
        autocmd_vimrc("CursorMoved") {
            once = true,
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.cursorline = false
                vim.opt_local.cursorcolumn = false
            end,
        }
    end,
}

-- Section1 fold
mapset.n("<Space>z") { "zMzv", desc = [[自分のいない fold だけたたむ]] }

-- Section1 search
mapset.n("<C-l>") {
    desc = [[redraw 時に nohlsearch もついでにやる]],
    "<Cmd>nohlsearch<CR><C-l>",
}

mapset.n("n") { expr = true, "'Nn'[v:searchforward]", desc = [[v:searchforward によらず一定にする]] }
mapset.n("N") { expr = true, "'nN'[v:searchforward]", desc = [[v:searchforward によらず一定にする]] }

-- http://vim.wikia.com/wiki/Search_for_visually_selected_text
mapset.x("*") {
    desc = [[VISUAL モードから検索]],
    table.concat {
        -- 選択範囲を検索クエリに用いるため、m レジスタに格納。
        -- ビジュアルモードはここで抜ける。
        [["my]],
        -- "m レジスタの中身を検索。
        -- ただし必要な文字はエスケープした上で、空白に関しては伸び縮み可能とする
        [[/\V<C-R><C-R>=substitute(escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>]],
        -- 先ほど検索した範囲にカーソルが移るように、手前に戻す
        [[N]],
    },
}

mapset.x("R") {
    desc = [[VISUAL モードから置換]],
    table.concat {
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
    },
}

mapset.n("_") { "/", desc = "`/` は modesearch 用に潰すため" }

-- Section2 QuickFix search
mapset.n("<C-n>") { "<Cmd>cnext<CR>zz", desc = [[QuickFix next + focus center]] }
mapset.n("<C-p>") { "<Cmd>cprevious<CR>zz", desc = [[QuickFix prev + focus center]] }

-- https://qiita.com/lighttiger2505/items/166a4705f852e8d7cd0d
mapset.n("q") {
    desc = [[toggle QuickFix window]],
    silent = true,
    function()
        local aerial = require("aerial")
        if #vim.fn.getqflist() == 0 and aerial.num_symbols(0) > 0 then
            aerial.toggle { focus = false }
            return
        end

        local nr1 = vim.fn.winnr("$")
        vim.cmd.cwindow()
        local nr2 = vim.fn.winnr("$")
        if nr1 == nr2 then
            vim.cmd.cclose()
        end
    end,
}

-- Section1 terminal
mapset.t("<C-]>") { [[<C-\><C-n>]], desc = [[<C-]> で terminal mode を抜けられるように]] }
mapset.t([[<C-\><C-n>]]) { "<C-]>", desc = [[もしターミナル内で <C-]> を打ちたくなったら ]] }

autocmd_vimrc("TermOpen") {
    callback = function()
        local mapset = monaqa.shorthand.mapset_local

        mapset.n("<CR>") { [[i<CR><C-\><C-n>]] }
        mapset.n("sw") { [[<Cmd>bdelete!<CR>]] }
        mapset.n("t") { [[<Cmd>let g:current_terminal_job_id = b:terminal_job_id<CR>]] }
        mapset.n("dd") { [[i<C-u><C-\><C-n>]] }
        mapset.n("A") { [[i<C-e>]] }
        mapset.n("p") { [[pi]] }
        mapset.n("<C-]>") { [[<Nop>]] }

        mapset.x("gb") {
            desc = [[選択範囲の改行を取っ払って URL として開く]],
            function()
                local region = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
                local url = table.concat(region, "")
                vim.ui.open(url)
            end,
        }

        mapset.n("u") {
            desc = [[REPL の履歴を1つ上に戻す]],
            expr = true,
            replace_keycodes = false,
            [["i" .. repeat("<Up>", v:count1) .. "<C-\><C-n>"]],
        }
        mapset.n("<C-r>") {
            desc = [[REPL の履歴を1つ下に戻す]],
            expr = true,
            replace_keycodes = false,
            [["i" .. repeat("<Down>", v:count1) .. "<C-\><C-n>"]],
        }

        vim.opt_local.wrap = true
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
    end,
}

vim.g.current_terminal_bufid = -1

mapset.n("st") {
    desc = [[terminal window を開く]],
    function()
        window.wise_split()
        if vim.g.current_terminal_bufid > 0 and logic.to_bool(vim.fn.bufexists(vim.g.current_terminal_bufid)) then
            vim.cmd.buffer { vim.g.current_terminal_bufid }
        else
            vim.cmd.terminal("fish")
            vim.g.current_terminal_job_id = vim.b.terminal_job_id
            vim.g.current_terminal_bufid = vim.fn.bufnr()
        end
    end,
}

-- Section2 send string to terminal buffer
---@type boolean
local bracketed_paste_mode = true

create_cmd("ToggleBracketedPasteMode") {
    desc = [[ペースト時に bracketed paste mode を有効にする。]],
    function()
        bracketed_paste_mode = not bracketed_paste_mode
        vim.notify("bracketed_paste_mode: " .. logic.ifexpr(bracketed_paste_mode, "on", "off"))
    end,
}

local shell_prompts = {
    "❯",
    "✗",
    "$",
}

local function reformat_cmdstring(body)
    body = body:gsub("(.-)(\r?\n)", function(line, eol)
        for _, char in ipairs(shell_prompts) do
            line = line:gsub("^%s*" .. char .. " ", "")
        end
        return line .. eol
    end)
    body = vim.trim(body)
    if bracketed_paste_mode then
        return monaqa.str.esc("[200~") .. body .. monaqa.str.esc("[201~\n")
    else
        return body .. "\n"
    end
end

function _G.vimrc.op.send_terminal(type)
    monaqa.edit.with_opt { selection = "inclusive" }(function()
        monaqa.edit.borrow_register { "m" }(function()
            local visual_range
            if type == "line" then
                visual_range = "'[V']"
            else
                visual_range = "`[V`]"
            end
            vim.cmd("normal! " .. visual_range .. '"my')
            local content = vim.fn.getreg("m", false)
            vim.fn.chansend(vim.g.current_terminal_job_id, reformat_cmdstring(content))
        end)
    end)
end

mapset.nx("S") {
    desc = [[send-terminal operator]],
    expr = true,
    function()
        vim.o.operatorfunc = "v:lua.vimrc.op.send_terminal"
        return "g@"
    end,
}

mapset.n("SS") {
    desc = [[send-terminal line]],
    expr = true,
    nowait = true,
    function()
        vim.o.operatorfunc = "v:lua.vimrc.op.send_terminal"
        return "g@_"
    end,
}

-- Section1 input Japanese character

mapset.nxo("fj") { "f<C-k>j" }
mapset.nxo("Fj") { "F<C-k>j" }
mapset.xo("tj") { "t<C-k>j" }
mapset.xo("Tj") { "T<C-k>j" }

vim.fn.digraph_setlist {
    -- これを設定することで， fjj を本来の fj と同じ効果にできる．
    { "jj", "j" },

    -- カッコ
    { "j(", "（" },
    { "j)", "）" },
    { "j[", "「" },
    { "j]", "」" },
    { "j{", "『" },
    { "j}", "』" },
    { "j<", "【" },
    { "j>", "】" },

    -- 句読点
    { "j,", "、" },
    { "j.", "。" },
    { "j!", "！" },
    { "j?", "？" },
    { "j:", "：" },

    -- その他の記号
    { "j~", "〜" },
    { "j/", "・" },
    { "js", "␣" },
    { "j ", "　" },
    { "zs", "​" },
}

-- Section1 window/buffer

mapset.n("s") { "<Nop>", desc = [[window/buffer 操作の prefix にする]] }

-- window を増やす、減らす
mapset.n("s_") { "<Cmd>split<CR>" }
mapset.n("s<Bar>") { "<Cmd>vsplit<CR>" }
mapset.n("sv") { "<Cmd>vsplit<CR>" }
mapset.n("sq") { "<Cmd>close<CR>" }
mapset.n("sw") { "<Cmd>bp | bd #<CR>" }

-- <C-w> による window 操作のショートカット
-- 面倒がらずにちゃんと <C-w> 使おうよ…と思ったがやっぱり面倒くさい
for _, char in ipairs {
    "x", -- exchange! 知らなかった
    "h",
    "j",
    "k",
    "l",
    "H",
    "J",
    "K",
    "L",
    "=",
} do
    mapset.n("s" .. char) { "<C-w>" .. char }
end

-- タブページ
mapset.n("sT") { "<Cmd>tabnew %<CR>" }
mapset.n("sQ") { "<Cmd>tabclose<CR>" }
mapset.n("sN") { "<Cmd>tabnext<CR>" }
mapset.n("sP") { "<Cmd>tabprevious<CR>" }

-- 特殊な window
mapset.n("s:") { "q:G" }
mapset.n("s?") { "q?G" }
mapset.n("s/") { "q/G" }

-- buffer 切り替え
mapset.n("-") { "<C-^>" }

local mode_bufmove = submode.create_mode("bufmove", "s")
mode_bufmove.register_mapping("n", "<Cmd>bn<CR>")
mode_bufmove.register_mapping("p", "<Cmd>bp<CR>")

local mode_winresize = submode.create_mode("winresize", "s")
mode_winresize.register_mapping("+", "<C-w>+")
mode_winresize.register_mapping("-", "<C-w>-")
mode_winresize.register_mapping(">", "<C-w>>")
mode_winresize.register_mapping("<", "<C-w><")

local favorite_buffer = nil
mapset.n("s*") {
    desc = [[Register favorite buffer]],
    function()
        favorite_buffer = vim.fn.bufnr()
        vim.notify("Saved as favorite buffer: " .. vim.fn.bufname(favorite_buffer))
    end,
}
mapset.n("s<Space>") {
    desc = [[Set the favorite buffer if exists]],
    function()
        if favorite_buffer ~= nil then
            vim.cmd.buffer(favorite_buffer)
        end
    end,
}

-- Section1 operator/text editing

-- Section2 general
mapset.n("<Space><CR>") { "a<CR><Esc>" }

-- 改行だけを入力する dot-repeatable なマッピング
local function append_new_lines(offset_line)
    return require("peridot").repeatable_edit(function(ctx)
        local curpos = vim.fn.line(".")
        local pos_line = curpos + offset_line
        local n_lines = ctx.count1
        local lines = vim.fn["repeat"]({ "" }, n_lines)
        vim.fn.append(pos_line, lines)
    end)
end

mapset.n("<Space>o") {
    desc = [[直後の行に空行を挿入]],
    expr = true,
    append_new_lines(0),
}
mapset.n("<Space>O") {
    desc = [[直前の行に空行を挿入]],
    expr = true,
    append_new_lines(-1),
}

local function increment_char(direction)
    return require("peridot").repeatable_edit(function(ctx)
        vim.cmd([[normal! v"my]])
        local char = vim.fn.getreg("m", nil, nil)
        local num = vim.fn.char2nr(char)
        vim.fn.setreg("m", vim.fn.nr2char(num + direction * ctx.count1))
        vim.cmd([[normal! gv"mp]])
    end)
end

mapset.n("<Space>a") {
    desc = [[カーソル下の文字の Unicode codepoint を 1 増やす]],
    expr = true,
    increment_char(1),
}
mapset.n("<Space>x") {
    desc = [[カーソル下の文字の Unicode codepoint を 1 減らす]],
    expr = true,
    increment_char(-1),
}

-- Section2 cut / put / replace
mapset.n("dd") {
    desc = [[wiser dd]],
    expr = true,
    function()
        -- どうせ空行1行なんて put するようなもんじゃないし、空行で上書きされるの嫌よね
        if vim.v.count1 == 1 and vim.v.register == [["]] and vim.fn.getline(".") == "" then
            return [["_dd]]
        else
            return "dd"
        end
    end,
}
mapset.i("<C-r><C-r>") { [[<C-g>u<C-r>"]] }
mapset.i("<C-r><CR>") { "<C-g>u<C-r>0" }
mapset.i("<C-r><Space>") { "<C-g>u<C-r>+" }
mapset.c("<C-r><C-r>") { [[<C-r>"]] }
mapset.c("<C-r><CR>") { "<C-r>0" }
mapset.c("<C-r><Space>") { "<C-r>+" }
mapset.n("@p") { "<Cmd>put +<CR>" }
mapset.n("@P") { "<Cmd>put! +<CR>" }

local function current_doctype()
    local ft = vim.bo.filetype
    if ft == "markdown" then
        ft = "gfm"
    end

    if vim.list_contains({ "typst", "gfm" }, ft) then
        return ft
    end
end

local function put_clipboard_image(doctype)
    local fn_image_path = function(name)
        local current_file_dir = vim.fn.expand("%:h")
        local dir = current_file_dir .. "/image/"
        if name == nil or name == "" then
            name = vim.fn.strftime("%Y-%m-%d-%H-%M-%S")
        end
        return dir .. name .. ".png"
    end
    local fn_markup_string
    if doctype == "typst" then
        fn_markup_string = function(name, path)
            local fname = vim.fn.fnamemodify(path, ":t:r")
            return {
                "#align(center)[",
                ([[  #image("image/%s.png", width: 85%%)]]):format(fname),
                "]",
            }
        end
    else
        fn_markup_string = function(name, path)
            return "![](" .. path .. ")"
        end
    end
    require("rc.clipboard").command_put_clipboard_image {
        fn_image_path = fn_image_path,
        fn_markup_string = fn_markup_string,
    } {}
end

local function put_richtext_with_convert(doctype)
    local text = require("rc.clipboard").put_html_from_clipboard(doctype)

    vim.notify("Converted from Rich Text Format to " .. doctype .. ".", vim.log.levels.INFO)

    require("monaqa.edit").borrow_register { "m" }(function()
        vim.fn.setreg("m", text, "V")
        vim.cmd([[put m]])
    end)
end

mapset.n("<Plug>(vimrc-put-image)") {
    desc = [[画像を貼り付ける]],
    function()
        put_clipboard_image(vim.bo.filetype)
    end,
}

mapset.n("<Plug>(vimrc-put-richtext)") {
    desc = [[リッチテキストを現在の文書に合わせて貼り付ける]],
    function()
        put_richtext_with_convert(current_doctype())
    end,
}

mapset.n("p") {
    desc = [[レジスタ名が i, r のとき、クリップボードを選択して貼り付ける]],
    expr = true,
    function()
        if vim.v.register == "i" then
            return "<Plug>(vimrc-put-image)"
        end
        if vim.v.register == "r" then
            return "<Plug>(vimrc-put-richtext)"
        end
        return "p"
    end,
}

mapset.n("<Space>p") {
    desc = [[クリップボードのリッチテキストや画像を現在の filetype に変換して貼り付ける]],
    function()
        local clipboard = require("rc.clipboard")
        local types = clipboard.detect_clipboard_type()
        if types == nil then
            return
        end

        local doctype = current_doctype()
        if doctype == nil then
            vim.cmd([[put +]])
            return
        end

        if vim.list_contains(types, "PNGf") then
            put_clipboard_image(doctype)
            return
        end

        if vim.list_contains(types, "HTML") then
            put_richtext_with_convert(doctype)
            return
        end

        vim.notify("Rich putting not available. clipboard types: " .. table.concat(types, ", "), vim.log.levels.DEBUG)

        vim.cmd([[put +]])
    end,
}

-- TODO: v:register を渡せる visual_replace
local function visual_replace(register)
    return function()
        local reg_body = vim.fn.getreg(register, nil, nil)
        vim.cmd([[normal! "]] .. register .. "p")
        vim.fn.setreg(register, reg_body)
    end
end

mapset.x("<Space>p") { visual_replace("+"), desc = [[replace with '+' register]] }
mapset.x("p") { visual_replace('"'), desc = [[replace with unnamed register]] }

-- Section2 :normal command alternative
local ns_id = vim.api.nvim_create_namespace("vimrc")

-- 一時的に特定のマッピングを上書き適用する。上書きしたぶんを unmap する関数を返す。
local function temporal_cmap()
    local maps = {
        -- <C-m> は <CR> と同じなのでちゃんと `<CR>` できることを保証しておく
        ["<C-m>"] = "<C-m>",

        -- <C-c> はキャンセル用でいいのではないか
        ["<C-c>"] = "<Esc>",

        -- <C-v> は特殊文字を入力する最後の砦なので残しておこうかな
        ["<C-v>"] = "<C-v>",

        -- <C-n> <C-p> だけは履歴の行き来に必要
        ["<C-a>"] = "<C-v><C-a>",
        ["<C-b>"] = "<C-v><C-b>",
        ["<C-d>"] = "<C-v><C-d>",
        ["<C-e>"] = "<C-v><C-e>",
        ["<C-f>"] = "<C-v><C-f>",
        ["<C-g>"] = "<C-v><C-g>",
        ["<C-h>"] = "<C-v><C-h>",
        ["<C-i>"] = "<C-v><C-i>",
        ["<C-j>"] = "<C-v><C-j>",
        ["<C-k>"] = "<C-v><C-k>",
        ["<C-l>"] = "<C-v><C-l>",
        -- ["<C-n>"] = "<C-v><C-n>",
        ["<C-o>"] = "<C-v><C-o>",
        -- ["<C-p>"] = "<C-v><C-p>",
        ["<C-q>"] = "<C-v><C-q>",
        ["<C-r>"] = "<C-v><C-r>",
        ["<C-s>"] = "<C-v><C-s>",
        ["<C-t>"] = "<C-v><C-t>",
        ["<C-u>"] = "<C-v><C-u>",
        ["<C-w>"] = "<C-v><C-w>",
        ["<C-x>"] = "<C-v><C-x>",
        ["<C-y>"] = "<C-v><C-y>",
        ["<C-z>"] = "<C-v><C-z>",
    }

    -- save default c-keymaps
    local maplist = vim.iter(vim.fn.maplist())
        :filter(function(m)
            return m.mode == "c"
        end)
        :totable()

    for k, v in pairs(maps) do
        mapset.c(k) { v, nowait = true }
    end
    mapset.c("<Esc>") {
        desc = [[明らかなキャンセル以外は <Esc> 文字をそのまま出力]],
        expr = true,
        function()
            if vim.fn.getcmdline() == "" then
                return "<Esc>"
            else
                return "<C-v><Esc>"
            end
        end,
    }

    -- 後片付け関数
    return function()
        for k, _ in pairs(maps) do
            vim.keymap.del("c", k)
        end
        vim.keymap.del("c", "<Esc>")

        -- restore default c-keymaps
        vim.iter(maplist):each(function(m)
            vim.fn.mapset(m)
        end)
    end
end

mapset.x("C") {
    desc = [[:normal の改善版]],
    function()
        local cursor_line = vim.fn.line(".")
        local other_line = vim.fn.line("v")
        local start_line = logic.ifexpr(cursor_line < other_line, cursor_line, other_line)
        local end_line = logic.ifexpr(cursor_line < other_line, other_line, cursor_line)

        local mark_id = vim.api.nvim_buf_set_extmark(0, ns_id, start_line - 1, 0, {
            end_row = end_line,
            end_col = 0,
            hl_group = "Visual",
        })
        local finished = false

        -- 何もしない normal コマンドを実行して VISUAL mode から抜ける。これ以外良い方法が思いつかない
        vim.cmd.normal { args = { "A" }, bang = true }
        vim.cmd.redraw { bang = true }

        local unmap = temporal_cmap()
        while not finished do
            local cmd = vim.fn.input { prompt = ":'<,'>normal " }
            if cmd == nil or cmd == "" then
                finished = true
            else
                -- 1回の編集ごとに undo が戻るようにする
                vim.cmd.normal { args = { monaqa.str.term("i<C-g>u") }, bang = true }
                vim.cmd.normal {
                    args = { cmd },
                    range = { start_line, end_line },
                }
                vim.cmd.redraw { bang = true }
            end
        end
        unmap()

        vim.api.nvim_buf_del_extmark(0, ns_id, mark_id)

        -- `gv` で再選択できるよう選択領域を restore
        vim.cmd(tostring(start_line))
        vim.cmd.normal([[V]])
        vim.cmd(tostring(end_line))
        vim.cmd.normal([[V]])
    end,
}

-- Section1 motion/text object

-- Section2 charwise motion
mapset.i("<C-Space>") { "<Space>", desc = "誤爆を防ぐため" }

mapset.i("<C-b>") { "<C-g>U<Left>" }
mapset.i("<C-f>") { "<C-g>U<Right>" }
mapset.i("<C-a>") { "<C-g>U<Home>" }

-- inner-word motion
mapset.o("u") { "t_" }
mapset.o("U") {
    desc = [[camelCase の次の大文字の手前までを選択する]],
    function()
        for _ = 1, vim.v.count1, 1 do
            vim.fn.search("[A-Z]", "", vim.fn.line("."))
        end
    end,
}

mapset.nxo("m)") { "])" }
mapset.nxo("m}") { "]}" }
mapset.x("m]") { "i]o``", desc = "対応する角カッコの終了手前までを選択" }
mapset.n("dm]") { "vi]o``d", desc = "対応する角カッコの終了手前までを削除" }
mapset.n("cm]") { "vi]o``c", desc = "対応する角カッコの終了手前までを置換" }

mapset.x("m(") { "i)``" }
mapset.x("m{") { "i}``" }
mapset.x("m[") { "i]``" }
mapset.n("dm(") { "vi)``d" }
mapset.n("dm{") { "vi}``d" }
mapset.n("dm[") { "vi]``d" }
mapset.n("cm(") { "vi)``c" }
mapset.n("cm{") { "vi}``c" }
mapset.n("cm[") { "vi]``c" }

for _, quote in ipairs { '"', "'", "`" } do
    vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
    vim.keymap.set({ "x", "o" }, "m" .. quote, "a" .. quote)
end

-- Command mode mapping

mapset.c("<C-a>") { "<Home>" }
mapset.c("<C-b>") { "<Left>" }
mapset.c("<C-f>") { "<Right>" }
mapset.c("<C-p>") { "<Up>" }
mapset.c("<C-n>") { "<Down>" }
mapset.c("<Up>") { "<C-p>" }
mapset.c("<Down>") { "<C-n>" }

-- f motion を n/N で繰り返せるようにする submode 案

-- vim.keymap.set({ "n", "x" }, "f", function()
--     local char = vim.fn.nr2char(vim.fn.getchar())
--     return "f" .. char .. "<Plug>(submode-f)"
-- end, { expr = true })
--
-- vim.keymap.set({ "n", "x" }, "F", function()
--     local char = vim.fn.nr2char(vim.fn.getchar())
--     return "F" .. char .. "<Plug>(submode-F)"
-- end, { expr = true })
--
-- vim.keymap.set({ "n", "x" }, "<Plug>(submode-f)n", ";<Plug>(submode-f)")
-- vim.keymap.set({ "n", "x" }, "<Plug>(submode-F)n", ",<Plug>(submode-F)")
-- vim.keymap.set({ "n", "x" }, "<Plug>(submode-f)N", ",<Plug>(submode-f)")
-- vim.keymap.set({ "n", "x" }, "<Plug>(submode-F)N", ";<Plug>(submode-F)")

-- Section 3 smart <Home>
mapset.nx("<Space>h") {
    desc = [[smart <Home>]],
    function()
        local str_before_cursor = vim.fn.strpart(vim.fn.getline("."), 0, vim.fn.col(".") - 1)
        local move_cmd = logic.ifexpr(vim.regex([[^\s*$]]):match_str(str_before_cursor) ~= nil, "0", "^")

        monaqa.edit.motion_autoselect {
            function()
                vim.cmd("normal! g" .. move_cmd)
            end,
            function()
                vim.cmd("normal! " .. move_cmd)
            end,
        }
    end,
}
mapset.o("<Space>h") { "^" }

-- Section 3 smart <End>
mapset.n("<Space>l") {
    desc = [[smart <End>]],
    function()
        monaqa.edit.motion_autoselect {
            function()
                vim.cmd("normal! g$")
            end,
            function()
                vim.cmd("normal! $")
            end,
        }
    end,
}

mapset.x("<Space>l") {
    desc = [[矩形選択時かつカーソルが既に行末にある時に限り、選択した行範囲にあるすべての行末を覆えるような長方形とする。]],
    function()
        local cursor = vim.fn.getcurpos()
        local lnum_cursor = cursor[2]
        local col_cursor = cursor[3]
        local line_cursor = vim.fn.getline(lnum_cursor)

        -- 行末移動
        vim.fn.cursor { lnum_cursor, #line_cursor }
        local new_col_cursor = vim.fn.getcurpos()[3]
        -- 行末移動によりカーソルの位置が変わっていたらそこで処理を終了する
        if col_cursor ~= new_col_cursor then
            return
        end

        -- 矩形選択、かつすでにカーソルが既に行末にある場合
        if vim.fn.mode(1) == "\u{16}" then
            local other_end = vim.fn.getpos("v")
            local lnum_other = other_end[2]
            local lnum_start = logic.ifexpr(lnum_cursor > lnum_other, lnum_other, lnum_cursor)
            local lnum_end = logic.ifexpr(lnum_cursor > lnum_other, lnum_cursor, lnum_other)
            local lines = vim.fn.getline(lnum_start, lnum_end)
            local dispwidth_max = 0
            for _, line in ipairs(lines) do
                local dispwidth = vim.fn.strdisplaywidth(line)
                if dispwidth_max < dispwidth then
                    dispwidth_max = dispwidth
                end
            end
            local dispwidth_cursor = vim.fn.strdisplaywidth(vim.fn.getline(lnum_cursor))
            if dispwidth_max > dispwidth_cursor then
                vim.fn.cursor { lnum_cursor, #line_cursor, dispwidth_max - dispwidth_cursor, dispwidth_max }
            end
        end
    end,
}

mapset.o("<Space>l") {
    desc = [[カウントを指定すると、その分だけ行末から文字を削った範囲を対象とする]],
    expr = true,
    require("peridot").repeatable_textobj(function(ctx)
        vim.cmd("normal! v$h")
        if ctx.set_count then
            vim.cmd(("normal! %sh"):format(ctx.count))
        end
    end),
}

-- Section2 linewise motion
mapset.n("j") {
    desc = [[smart j]],
    expr = true,
    function()
        return logic.ifexpr(vim.v.count == 0, "gj", "j")
    end,
}
mapset.n("k") {
    desc = [[smart k]],
    expr = true,
    function()
        return logic.ifexpr(vim.v.count == 0, "gk", "k")
    end,
}

mapset.x("j") {
    desc = [[smart j]],
    expr = true,
    function()
        return logic.ifexpr(vim.v.count == 0 and vim.fn.mode(0) == "v", "gj", "j")
    end,
}
mapset.x("k") {
    desc = [[smart k]],
    expr = true,
    function()
        return logic.ifexpr(vim.v.count == 0 and vim.fn.mode(0) == "v", "gk", "k")
    end,
}

-- Vertical WORD (vWORD) 単位での移動
_G.vimrc.state.par_motion_continuous = false
autocmd_vimrc("CursorMoved") {
    desc = [[paragraph motion の continuous フラグを切る]],
    callback = function()
        _G.vimrc.state.par_motion_continuous = false
    end,
}

-- <C-j>/<C-k> は基本的に `{` / `}` モーションと同じだが、
-- 連続した <C-j>/<C-k> による移動では jumplist が更新されない
function _G.vimrc.motion.smart_par(motion)
    vim.cmd.normal {
        args = { tostring(vim.v.count1) .. motion },
        bang = true,
        mods = {
            keepjumps = _G.vimrc.state.par_motion_continuous,
        },
    }
end

mapset.nxo("<C-j>") {
    desc = [[smart paragraph motion (down)]],
    "<Cmd>call v:lua.vimrc.motion.smart_par('}')<CR>" .. "<Cmd>lua _G.vimrc.state.par_motion_continuous = true<CR>",
}

mapset.nxo("<C-k>") {
    desc = [[smart paragraph motion (up)]],
    "<Cmd>call v:lua.vimrc.motion.smart_par('{')<CR>" .. "<Cmd>lua _G.vimrc.state.par_motion_continuous = true<CR>",
}

-- vertical f motion
-- TODO: プラグイン化したくなってきたのう
local vertical_f_char
local vertical_f_pattern

local ns_id = vim.api.nvim_create_namespace("verticalf")

local function vertical_f(ctx, forward)
    local pattern
    if forward then
        pattern = [[^\%>.l\s*\zs]]
    else
        pattern = [[^\%<.l\s*\zs]]
    end

    local delta = logic.ifexpr(forward, 1, -1)
    local start_line = vim.fn.line(".") + delta
    local end_line = vim.fn.line(logic.ifexpr(forward, "w$", "w0"))
    local chars = {}
    for line = start_line, end_line, delta do
        ---@type string
        local linestr = vim.fn.getline(line)
        if #linestr ~= 0 then
            local _, e = linestr:find("^%s*")
            local char = linestr:sub(e + 1, e + 1)

            if chars[char] == nil then
                chars[char] = 1
            else
                chars[char] = chars[char] + 1
            end
            if chars[char] == ctx.count1 then
                -- FIXME: vim.hl.range() で書き直す
                vim.api.nvim_buf_add_highlight(0, ns_id, "VisualMatch", line - 1, e, e + 1)
            end
        end
    end

    vim.opt_local.cursorline = true
    vim.cmd("redraw")
    local char
    if ctx.repeated then
        char = vertical_f_char
    else
        char = vim.fn.nr2char(vim.fn.getchar())
        vertical_f_char = char
    end

    vertical_f_pattern = pattern .. [[\V]] .. vim.fn.escape(char, [[\/]])

    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
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

mapset.nx("<Space>f") {
    desc = [[Vertical f motion]],
    function()
        vertical_f(get_initial_ctx(), true)
    end,
}
mapset.o("<Space>f") {
    desc = [[Vertical f motion]],
    expr = true,
    require("peridot").repeatable_textobj(function(ctx)
        vertical_f(ctx, true)
    end),
}

mapset.nx("<Space>F") {
    desc = [[Vertical f motion]],
    function()
        vertical_f(get_initial_ctx(), false)
    end,
}
mapset.o("<Space>F") {
    desc = [[Vertical f motion]],
    expr = true,
    require("peridot").repeatable_textobj(function(ctx)
        vertical_f(ctx, false)
    end),
}

-- Section1 Macros

-- マクロの記録レジスタは "aq のような一般のレジスタを指定するのと同様の
-- インターフェースで変更するようにし、デフォルトレジスタを q とする。
-- マクロ自己再帰呼出しによるループや、マクロの中でマクロを呼び出すことは簡単にはできないようにしてある。
-- （もちろんレジスタを直に書き換えれば可能）
-- デフォルトのレジスタ @q は Vim の開始ごとに初期化される。

local function keymap_toggle_macro()
    if logic.to_bool(vim.fn.reg_recording()) then
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

_G.vimrc.state.last_played_macro_register = "q"

local function keymap_play_macro()
    -- 無名レジスタには格納できないようにする
    -- & デフォルトを前回再生したマクロにする
    local register = vim.v.register
    if register == [["]] then
        register = _G.vimrc.state.last_played_macro_register
    end
    _G.vimrc.state.last_played_macro_register = register
    if vim.fn.getreg(register, nil, nil) == "" then
        vim.api.nvim_echo({ { ("Register @%s is empty."):format(register), "Error" } }, true, {})
        return ""
    end

    vim.api.nvim_echo({ { ("Playing macro: @%s"):format(register), "Error" } }, false, {})
    return "@" .. register
end

local function keymap_cancel_macro()
    local register = vim.fn.reg_recording()
    if register == "" then
        return ""
    end
    return table.concat {
        -- 現在のレジスタに入っているコマンド列を一旦 reg_content に退避
        ("<Cmd>let reg_content = @%s<CR>"):format(register),
        -- マクロの記録を停止
        "q",
        -- 対象としていたレジスタの中身を先程退避したものに入れ替える
        ("<Cmd>let @%s = reg_content<CR>"):format(register),
        -- キャンセルした旨を表示
        ("<Cmd>echo 'Recording cancelled: @%s'<CR>"):format(register),
    }
end

mapset.n("Q") { keymap_toggle_macro, expr = true }
mapset.n("<C-q>") {
    desc = [[Play / Cancel Macro]],
    expr = true,
    function()
        if vim.fn.reg_recording() == "" then
            return keymap_play_macro()
        else
            return keymap_cancel_macro()
        end
    end,
}

mapset.n("@") { "Nop" }
mapset.n("@:") { "@:" }

-- Section1 command-line mappings
mapset.c("<C-c>") { "<C-f>", desc = [[<C-c> でコマンドラインモードに入る]] }

-- Section1 特殊キー
for i = 1, 12, 1 do
    mapset.nxo(("<F%s>"):format(i)) { "<Nop>" }
end
mapset.with_mode { "n", "x", "o", "i", "c", "s" }("<M-F1>") { "<Nop>" }
mapset.with_mode { "i", "c", "s" }("<F1>") { "<Nop>" }
mapset.with_mode { "n", "x", "o" }("<Space>") { "<Nop>" }
mapset.with_mode { "n", "x", "o" }("<CR>") { "<Nop>" }

-- Section1 その他

-- Changelist
mapset.n("<C-h>") { "g;" }
mapset.n("<C-g>") { "g," }

-- <C-x> 絶妙に押しづらいから…
mapset.i("<C-g>") { "<C-x>" }

-- 直前の単語を full uppercase にする。
-- vimrc 読書会より。
-- thanks to thinca
-- mapset.i("<C-l>") { "<Esc>gUvbgi" }
-- mapset.i("<C-l>") {
--     [[<C-r>="<C-v><C-w>" .. toupper("<C-r><C-w>")<CR>]],
-- }
mapset.i("<C-l>") {
    expr = true,
    function()
        local line = vim.fn.getline(".")
        local col = vim.fn.getpos(".")[3]
        local substring = line:sub(1, col - 1)
        -- TODO: 正規表現が仰々しい。実際には /[a-zA-Z0-9_]*$/ 程度で十分と思われる
        -- CJK などの keyword 文字とアルファベットが連続して並んだときを考慮し、ややこしい表現になっている
        local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
        return "<C-w>" .. result:upper()
    end,
}

mapset.n("gf") { "gF" }
mapset.ic("<C-v>u") { "<C-r>=nr2char(0x)<Left>" }

-- https://github.com/ompugao/vim-bundle/blob/074e7b22320ad4bfba4da5516e53b498ace35a89/vimrc
mapset.x("I") {
    desc = [[行選択モードでも複数行に挿入できる I]],
    expr = true,
    function()
        return logic.ifexpr(vim.fn.mode(0) == "V", "<C-v>0o$I", "I")
    end,
}
mapset.x("A") {
    desc = [[行選択モードでも複数行に挿入できる A]],
    expr = true,
    function()
        return logic.ifexpr(vim.fn.mode(0) == "V", "<C-v>0o$A", "A")
    end,
}

-- mapset.n("ts") { "<Cmd>Inspect<CR>" }
mapset.n("gF") {
    desc = "外部の open コマンドを用いてパスを開く",
    "<Cmd>!open <cfile><CR>",
}

-- mapset.n("<LeftMouse>") {
--     function() end,
-- }
--
-- mapset.n("<LeftRelease>") {
--     function() end,
-- }

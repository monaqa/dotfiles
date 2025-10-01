local uv = vim.uv
local monaqa = require("monaqa")
local tree = monaqa.tree
local mapset = monaqa.shorthand.mapset_local
local create_cmd = monaqa.shorthand.create_cmd_local
local autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
local opt = vim.opt_local

require("lazy").load { plugins = { "snacks.nvim" } }

-- これを読み込むと snacks 内部で使われる namespace が create される
-- ここで読み込んでおかないと
-- 非同期で vim.notify を実行するとき E5560 エラーが起きてしまう
require("snacks.notifier")

opt.shiftwidth = 2
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.commentstring = "// %s"
opt.formatoptions:append("r")
opt.formatoptions:remove("o")

opt.comments = {
    "b:- #TODO",
    "b:-",
    "b:+",
    "b:1.",
}

mapset.n("zM") { "zMzr", desc = [[foldlevel を 0 ではなく 1 にする]] }
mapset.n("<Space>z") { "zMzrzv", desc = [[foldlevel を 0 ではなく 1 にしたバージョン]] }
mapset.ia("]") {
    expr = true,
    [[(getline('.') =~# '\s*- ]') ? '#TODO' : ']']],
}

---@class modeline
---@field target? string
---@field root? string
---@field nightly? boolean

---@return modeline
local function get_modeline()
    ---@type string
    local line = vim.fn.getline(1)
    if vim.startswith(line, "//!{") then
        return vim.json.decode(line:sub(4))
    end
    if vim.startswith(line, "//! target:") then
        local _, _, file = line:find([[^//! target:%s*(%S+)$]])
        return { target = file }
    end
    return {}
end

---@param modeline modeline
---@return string
local function resolve_target(modeline)
    if modeline.target == nil then
        return vim.fn.resolve(vim.fn.expand("%"))
    end
    return vim.fn.resolve(vim.fn.expand("%:h") .. "/" .. modeline.target)
end

---@param modeline modeline
---@return string
local function compile_cmdname(modeline)
    if modeline.nightly then
        return "typst-nightly"
    end
    return "typst"
end

---@param modeline modeline
---@return string[]
local function compile_cmdargs(modeline)
    local v = {
        compile_cmdname(modeline),
        "compile",
        "--features",
        "html",
        "--input",
        "typscrap_root=/Users/monaqa/Documents/typscrap-contents/content/",
        resolve_target(modeline),
    }
    if modeline.root ~= nil then
        v[#v + 1] = "--root"
        v[#v + 1] = vim.fn.resolve(vim.fn.expand("%:h") .. "/" .. modeline.root)
    end
    return v
end

mapset.n("@o") {
    desc = [[PDF を開く]],
    function()
        local modeline = get_modeline()
        local objective = resolve_target(modeline)
        local target = vim.fn.fnamemodify(objective, ":r") .. ".pdf"
        vim.cmd([[!open ]] .. target)
    end,
}
mapset.n("@t") { "<Cmd>TypstPreview<CR>" }
mapset.n("@h") {
    expr = true,
    function()
        local modeline = get_modeline()
        return "<Cmd>vert term " .. compile_cmdname(modeline) .. " watch --features html -f html %<CR>"
    end,
}

mapset.n("@q") {
    desc = [[typst compile を実行]],
    function()
        local modeline = get_modeline()
        local result = vim.system(compile_cmdargs(modeline), {}):wait()
        if result.code ~= 0 then
            vim.notify(result.stderr, vim.log.levels.ERROR)
        else
            vim.notify("Compile success!")
        end
    end,
}

autocmd_vimrc("BufWritePost") {
    key = "typst-compile-on-save",
    desc = [[保存時に自動で typst compile を実行する]],
    buffer = 0,
    callback = function()
        local modeline = get_modeline()
        vim.system(compile_cmdargs(modeline), {}, function(result)
            if result.code ~= 0 then
                vim.notify(result.stderr, vim.log.levels.ERROR)
            end
        end)
    end,
}

mapset.x("L") {
    desc = [[クリップボードの URL で選択範囲をリンク化]],
    [["lc#link("<C-r>=substitute(getreg("+"), '\n', '', 'g')<CR>")[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>]<Esc>]],
}

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
        fn_markup_string = function(_, path)
            local fname = vim.fn.fnamemodify(path, ":t:r")
            -- local prev_dir = vim.fn.chdir(vim.fn.expand "%:h")
            -- local relpath = vim.fn.fnamemodify(path, ":.")
            -- vim.fn.chdir(prev_dir)
            return {
                "#align(center)[",
                ([[  #image("image/%s.png", width: 85%%)]]):format(fname),
                "]",
            }
        end,
    },
}
mapset.n("@p") { "<Cmd>PutClipboardImage<CR>" }

create_cmd("CorrectLinks") {
    desc = [[Markdown 形式のリンクを Typst 形式に直す]],
    range = "%",
    function(meta)
        vim.cmd.substitute {
            [[/\v\[(.*)\]\((.*)\)/#link("\2")[\1]/g]],
            range = { meta.line1, meta.line2 },
            mods = { keeppatterns = true },
        }
    end,
}

local function apply_typstyle()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("typstyle", s)
    end)()
end

mapset.n("g=") {
    desc = [[]],
    function() end,
}

mapset.n("g=") {
    desc = [[選択範囲に typstfmt を適用する]],
    expr = true,
    function()
        -- 強制的に行指向 motion / text object にするための "V"
        return apply_typstyle() .. "V"
    end,
}
mapset.n("g==") {
    desc = [[選択行に typstfmt を適用する]],
    expr = true,
    function()
        return apply_typstyle() .. "_"
    end,
}
mapset.x("g=") { expr = true, apply_typstyle, desc = [[選択範囲に typstfmt を適用する]] }

mapset.nx("gy") {
    desc = [[Typst から他の形式に変換してヤンクする]],
    expr = true,
    require("general_converter").operator_convert("typst-pandoc"),
}

create_cmd("IncrementHeading") {
    range = "%",
    desc = "範囲内の見出しレベルを1上げる",
    function(meta)
        tree.replace_buf([[ (heading) @- ]], function(text)
            return "=" .. text
        end, {
            start = meta.line1 - 1,
            stop = meta.line2,
        })
    end,
}

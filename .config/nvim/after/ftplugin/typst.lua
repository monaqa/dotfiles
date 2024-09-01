local uv = vim.uv
local monaqa = require("monaqa")
local mapset = monaqa.shorthand.mapset_local
local create_cmd = monaqa.shorthand.create_cmd_local

vim.opt_local.shiftwidth = 2
vim.opt_local.foldmethod = "manual"
vim.opt_local.commentstring = "// %s"
vim.opt_local.formatoptions:append("r")

vim.opt_local.comments = {
    "b:-",
    "b:+",
    "b:1.",
}

local function resolve_target()
    local line = vim.fn.getline(1)
    local _, _, file = line:find([[^//! target:%s*(%S+)$]])
    if file ~= nil then
        return vim.fn.resolve(vim.fn.expand("%:h") .. "/" .. file)
    else
        return vim.fn.resolve(vim.fn.expand("%"))
    end
end

mapset.n("@o") {
    desc = [[PDF を開く]],
    function()
        local objective = resolve_target()
        local target = vim.fn.fnamemodify(objective, ":r") .. ".pdf"
        vim.cmd([[!open ]] .. target)
    end,
}

mapset.n("@q") {
    desc = [[typst compile を実行]],
    function()
        local objective = resolve_target()
        vim.cmd(
            [[!typst compile --input typscrap_root=/Users/monaqa/ghq/github.com/monaqa/typscrap-contents/content/ ]]
                .. objective
        )
    end,
}

vim.api.nvim_create_augroup("vimrc_typst", { clear = true })
vim.api.nvim_clear_autocmds { group = "vimrc_typst" }
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "vimrc_typst",
    pattern = "*.typ",
    callback = function()
        local objective = resolve_target()
        -- vim.fn.system { "typst", "compile", objective }
        uv.spawn("typst", {
            args = {
                "compile",
                "--input",
                "typscrap_root=/Users/monaqa/ghq/github.com/monaqa/typscrap-contents/content/",
                objective,
            },
        }, function() end)
    end,
})

vim.keymap.set(
    "x",
    "L",
    [["lc#link("<C-r>=substitute(getreg("+"), '\n', '', 'g')<CR>")[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>]<Esc>]],
    {
        buffer = true,
    }
)

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

local function apply_typstfmt()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("typstfmt", s)
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
        return apply_typstfmt() .. "V"
    end,
}
mapset.n("g==") {
    desc = [[選択行に typstfmt を適用する]],
    expr = true,
    function()
        return apply_typstfmt() .. "_"
    end,
}
mapset.x("g=") { expr = true, apply_typstfmt, desc = [[選択範囲に typstfmt を適用する]] }

mapset.nx("gy") {
    desc = [[Typst から他の形式に変換してヤンクする]],
    expr = true,
    require("general_converter").operator_convert("typst-pandoc"),
}

vim.keymap.set({ "n", "x" }, "gy", require("general_converter").operator_convert("typst-pandoc"), { expr = true })

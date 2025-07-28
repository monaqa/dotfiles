local mapset = require("monaqa").shorthand.mapset_local

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"

local function apply_stylua()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("stylua -", s)
    end)()
end

mapset.n("g=") {
    desc = [[選択範囲に stylua を適用する]],
    expr = true,
    function()
        -- 強制的に行指向 motion / text object にするための "V"
        return apply_stylua() .. "V"
    end,
}
mapset.n("g==") {
    desc = [[選択行に stylua を適用する]],
    expr = true,
    function()
        return apply_stylua() .. "_"
    end,
}
mapset.x("g=") { expr = true, apply_stylua, desc = [[選択範囲に stylua を適用する]] }

mapset.ia("!=") { "~=" }
mapset.ia("let") { "local" }

-- snippet file ならばその言語名を返す。
local function get_snippet_ft()
    return nil
end

local function highlight_snippet_file(snippet_ft)
    vim.treesitter.query.set(
        "lua",
        "injections",
        [[
    ;;extends

    (
    (string_content) @injection.content
    (#set! injection.language "python"))
    ]]
    )
end

local snippet_ft = get_snippet_ft()
if snippet_ft ~= nil then
    highlight_snippet_file(snippet_ft)
end

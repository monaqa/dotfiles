local uv = vim.uv
require("lazy").load { plugins = { "dial.nvim", "general-converter.nvim" } }

vim.b.did_ftplugin = 1
-- vim.opt_local.runtimepath:append {
--     "/opt/homebrew/share/lilypond/2.24.1/vim",
-- }

vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "@q", "<Cmd>!cd %:h; lilypond %:t<CR>", { buffer = true })
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })

vim.api.nvim_create_augroup("vimrc_lilypond", { clear = true })
vim.api.nvim_clear_autocmds { group = "vimrc_lilypond" }
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "vimrc_lilypond",
    pattern = "*.ly",
    callback = function()
        local target = vim.fn.expand("%:t")
        local cwd = vim.fn.expand("%:h")
        uv.spawn("lilypond", { args = { target }, cwd = cwd }, function() end)
    end,
})

vim.opt_local.commentstring = "% %s"

vim.keymap.set("n", "<Up>", function()
    require("dial.map").manipulate("increment", "normal", "lilypond_note")
end)

vim.keymap.set("n", "<Down>", function()
    require("dial.map").manipulate("decrement", "normal", "lilypond_note")
end)

vim.keymap.set("n", "gc", function()
    require("dial.map").manipulate("increment", "normal", "lilypond_ises")
end, { buffer = true })

vim.keymap.set(
    { "n", "x" },
    "@r",
    require("general_converter").operator_convert(require("general_converter.util").linewise_converter(function(text)
        local elems = vim.split(text, " ")
        local results = {}
        for index, value in ipairs(elems) do
            local new_value = ({
                [""] = "",
                ["1"] = "16",
                ["2"] = "8",
                ["3"] = "8.",
                ["4"] = "4",
                ["5"] = "4~16",
                ["6"] = "4.",
                ["7"] = "4~8.",
                ["8"] = "2",
                ["9"] = "2~16",
                ["10"] = "2~8",
                ["11"] = "2~8.",
                ["12"] = "2.",
                ["13"] = "2~4~16",
                ["14"] = "2~4.",
                ["15"] = "2~4~8.",
                ["16"] = "1",
                ["r1"] = "r16",
                ["r2"] = "r8",
                ["r3"] = "r8.",
                ["r4"] = "r4",
                ["r5"] = "r4~16",
                ["r6"] = "r4.",
                ["r7"] = "r4~8.",
                ["r8"] = "r2",
                ["r9"] = "r2~16",
                ["r10"] = "r2~8",
                ["r11"] = "r2~8.",
                ["r12"] = "r2.",
                ["r13"] = "r2~4~16",
                ["r14"] = "r2~4.",
                ["r15"] = "r2~4~8.",
                ["r16"] = "r1",
                ["x1"] = [[\xNote 16]],
                ["x2"] = [[\xNote 8]],
                ["x3"] = [[\xNote 8.]],
                ["x4"] = [[\xNote 4]],
                ["x5"] = [[\xNote 4~16]],
                ["x6"] = [[\xNote 4.]],
                ["x7"] = [[\xNote 4~8.]],
                ["x8"] = [[\xNote 2]],
                ["x9"] = [[\xNote 2~16]],
                ["x10"] = [[\xNote 2~8]],
                ["x11"] = [[\xNote 2~8.]],
                ["x12"] = [[\xNote 2.]],
                ["x13"] = [[\xNote 2~4~16]],
                ["x14"] = [[\xNote 2~4.]],
                ["x15"] = [[\xNote 2~4~8.]],
                ["x16"] = [[\xNote 1]],
            })[value]
            results[#results + 1] = new_value
        end
        return table.concat(results, " ")
    end)),
    { expr = true, buffer = true, desc = "リズム生成用" }
)

vim.keymap.set(
    { "n", "x" },
    "@c",
    require("general_converter").operator_convert(require("general_converter.util").linewise_converter(function(text)
        local elems = vim.split(text, " ")
        local results = {}
        for index, value in ipairs(elems) do
            local new_value = ({
                ["0"] = "c",
                ["1"] = "cis",
                ["2"] = "d",
                ["3"] = "dis",
                ["4"] = "e",
                ["5"] = "f",
                ["6"] = "fis",
                ["7"] = "g",
                ["8"] = "gis",
                ["9"] = "a",
                ["a"] = "ais",
                ["b"] = "b",
            })[value]
            if new_value == nil then
                results[#results + 1] = value
            else
                results[#results + 1] = new_value
            end
        end
        return table.concat(results, " ")
    end)),
    { expr = true, buffer = true, desc = "コード生成用" }
)

--- query とキャプチャ名を与えて、マッチする node 、value の列を返す。
local function find_matches(query, capture_name, root)
    local q = vim.treesitter.query.parse("lilypond", query)
    return vim.iter(q:iter_captures(root, 0))
        :filter(function(id, node, metadata, match)
            return q.captures[id] == capture_name
        end)
        :map(function(id, node, metadata, match)
            local sr, sc, er, ec = node:range()
            local lines = vim.fn.getregion({ 0, sr + 1, sc + 1, 0 }, { 0, er + 1, ec, 0 })
            return { node = node, region = { s = { sr + 1, sc + 1 }, e = { er + 1, ec } }, lines = lines }
        end)
        :totable()
end

local parser = vim.treesitter.get_parser(0, "lilypond")
local node = parser:parse()[1]:root()

local parse = vim.treesitter.query.parse

local query_key = vim.treesitter.query.parse(
    "lilypond",
    [[
    (
     (command) @_cmd_key
     .
     (note_item) @note
     .
     (command) @major_minor
     (#eq? @_cmd_key "\\key")
     )
    ]]
)

local query_pitch = vim.treesitter.query.parse(
    "lilypond",
    [[
        (pitch) @pitch
    ]]
)

local matches = vim.iter(query_key:iter_captures(node, 0))
    :map(function(id, node, metadata, match)
        local sr, sc, er, ec = node:range()
        local value = vim.fn.getregion({ 0, sr + 1, sc + 1, 0 }, { 0, er + 1, ec, 0 })[1]
        return { id = query_key.captures[id], value = value }
    end)
    :totable()

local matches = find_matches([[(pitch) @pitch]])
vim.print(matches)

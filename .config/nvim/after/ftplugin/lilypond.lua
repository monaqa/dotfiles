local uv = vim.uv
require("lazy").load { plugins = { "dial.nvim", "general-converter.nvim" } }
-- vim.b.did_ftplugin = 1
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

local fg = require("colorimetry.palette").fg
local bg = require("colorimetry.palette").bg

vim.api.nvim_set_hl(0, "LilypondAccidental", { fg = fg.r2 })

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
---@param query vim.treesitter.Query
local function find_matches(query, root, start, stop)
    return vim.iter(query:iter_matches(root, 0, start, stop))
        :map(
            ---@param match table<integer, TSNode>
            function(_, match, _)
                local m = vim.iter(match)
                    :enumerate()
                    :map(function(id, node)
                        local capture_name = query.captures[id]
                        if vim.startswith(capture_name, "_") then
                            return capture_name
                        end
                        local sr, sc, er, ec = node:range()
                        local text =
                            table.concat(vim.fn.getregion({ 0, sr + 1, sc + 1, 0 }, { 0, er + 1, ec, 0 }), "\n")
                        return capture_name,
                            {
                                node = node,
                                text = text,
                                region = { s = { sr + 1, sc + 1 }, e = { er + 1, ec } },
                            }
                    end)
                    :fold({}, function(acc, k, v)
                        acc[k] = v
                        return acc
                    end)
                return m
            end
        )
        :totable()
end

local all_notes = {
    "c",
    "cis",
    "ces",
    "d",
    "dis",
    "des",
    "e",
    "eis",
    "ees",
    "f",
    "fis",
    "fes",
    "g",
    "gis",
    "ges",
    "a",
    "ais",
    "aes",
    "b",
    "bis",
    "bes",
}

local key_to_scale_notes = {
    ["c\\major"] = { "c", "d", "e", "f", "g", "a", "b" },
    ["a\\minor"] = { "c", "d", "e", "f", "g", "a", "b" },

    ["des\\major"] = { "des", "ees", "f", "ges", "aes", "bes", "c" },
    ["bes\\minor"] = { "des", "ees", "f", "ges", "aes", "bes", "c" },

    ["d\\major"] = { "d", "e", "fis", "g", "a", "b", "cis" },
    ["b\\minor"] = { "d", "e", "fis", "g", "a", "b", "cis" },

    ["ees\\major"] = { "ees", "f", "g", "aes", "bes", "c", "d" },
    ["c\\minor"] = { "ees", "f", "g", "aes", "bes", "c", "d" },

    ["e\\major"] = { "e", "fis", "gis", "a", "b", "cis", "dis" },
    ["cis\\minor"] = { "e", "fis", "gis", "a", "b", "cis", "dis" },

    ["f\\major"] = { "f", "g", "a", "bes", "c", "d", "e" },
    ["d\\minor"] = { "f", "g", "a", "bes", "c", "d", "e" },

    ["ges\\major"] = { "ges", "aes", "bes", "b", "des", "ees", "f" },
    ["ees\\minor"] = { "ges", "aes", "bes", "b", "des", "ees", "f" },

    ["g\\major"] = { "g", "a", "b", "c", "d", "e", "fis" },
    ["e\\minor"] = { "g", "a", "b", "c", "d", "e", "fis" },

    ["aes\\major"] = { "aes", "bes", "c", "des", "ees", "f", "g" },
    ["f\\minor"] = { "aes", "bes", "c", "des", "ees", "f", "g" },

    ["a\\major"] = { "a", "b", "cis", "d", "e", "fis", "gis" },
    ["fis\\minor"] = { "a", "b", "cis", "d", "e", "fis", "gis" },

    ["bes\\major"] = { "bes", "c", "d", "ees", "f", "g", "a" },
    ["g\\minor"] = { "bes", "c", "d", "ees", "f", "g", "a" },

    ["b\\major"] = { "b", "cis", "dis", "e", "fis", "gis", "ais" },
    ["gis\\minor"] = { "b", "cis", "dis", "e", "fis", "gis", "ais" },
}

local function create_query_str(scale_notes)
    local s = vim.iter(all_notes)
        :filter(function(note)
            if scale_notes == nil then
                return true
            end
            return not vim.tbl_contains(scale_notes, note)
        end)
        :map(function(note)
            return ("(pitch_%s)"):format(note)
        end)
        :join(" ")
    return vim.treesitter.query.parse("lilypond", ("(pitch [%s]) @pitch"):format(s))
end

local ns = vim.api.nvim_create_namespace("lilypond_no_scale_note")

local function highlight_non_scale_note()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    local parser = vim.treesitter.get_parser(0, "lilypond")
    local root = parser:parse()[1]:root()

    local key_specifiers = find_matches(
        vim.treesitter.query.parse(
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
        ),
        root
    )

    local key_regions = {}
    local prev_key = nil
    for _, match in ipairs(key_specifiers) do
        local note_name = match.note.text
        local major_minor = match.major_minor.text
        local start_pos = match.note.region.e[1]
        if prev_key ~= nil then
            key_regions[#key_regions + 1] =
                { key = { prev_key.note_name, prev_key.major_minor }, line = { prev_key.start_pos + 1, start_pos } }
        end
        prev_key = { note_name = note_name, major_minor = major_minor, start_pos = start_pos }
    end
    if prev_key ~= nil then
        key_regions[#key_regions + 1] =
            { key = { prev_key.note_name, prev_key.major_minor }, line = { prev_key.start_pos + 1, -1 } }
    end

    vim.iter(key_regions)
        :map(function(t)
            local notes = key_to_scale_notes[t.key[1] .. t.key[2]]
            local matches = find_matches(create_query_str(notes), root, t.line[1], t.line[2])
            return matches
        end)
        :flatten(1)
        :each(function(matches)
            local pitch = matches.pitch
            ---@type {s : [integer, integer], e : [integer, integer]}
            local region = pitch.region

            vim.api.nvim_buf_add_highlight(0, ns, "LilypondAccidental", region.s[1] - 1, region.s[2] - 1, region.e[2])
            -- vim.api.nvim_buf_set_extmark(0, ns, region.s[1] - 1, region.s[2] - 1, {
            --     end_row = region.e[1] - 1,
            --     end_col = region.e[2],
            --     hl_group = "Special",
            -- })
        end)
end

highlight_non_scale_note()

if not vim.b.loaded then
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = 0,
        callback = function()
            highlight_non_scale_note()
        end,
    })
end

vim.b.loaded = true

-- vim.api.nvim_create_autocmd()

--
-- local query_pitch = vim.treesitter.query.parse(
--     "lilypond",
--     [[
--         (pitch) @pitch
--     ]]
-- )
--
-- local matches = vim.iter(query_key:iter_captures(node, 0))
--     :map(function(id, node, metadata, match)
--         local sr, sc, er, ec = node:range()
--         local value = vim.fn.getregion({ 0, sr + 1, sc + 1, 0 }, { 0, er + 1, ec, 0 })[1]
--         return { id = query_key.captures[id], value = value }
--     end)
--     :totable()
--
-- local
-- local pitches = find_matches([[(pitch) @pitch]], node, "pitch")
-- -- vim.print(matches)

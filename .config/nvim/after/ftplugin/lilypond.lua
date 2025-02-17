local uv = vim.uv
local monaqa = require("monaqa")
local create_cmd = monaqa.shorthand.create_cmd_local
local tree = monaqa.tree
local to_bool = monaqa.logic.to_bool
local lilypond = require("rc.lilypond")

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

vim.keymap.set("n", "<Space>s", function()
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
    ["ees\\minor"] = { "ges", "aes", "bes", "ces", "des", "ees", "f" },

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

    ["fis\\major"] = { "fis", "gis", "ais", "b", "cis", "dis", "eis" },
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
    return ("(pitch [%s]) @pitch"):format(s)
end

local ns = vim.api.nvim_create_namespace("lilypond_no_scale_note")

---@return {key: [string, string], line: [integer, integer]}[]
function key_regions()
    local key_specifiers = tree.find_buf_matches([[
        (
         (command) @_cmd_key
         .
         (note_item) @note
         .
         (command) @major_minor
         (#eq? @_cmd_key "\\key")
         )
    ]])

    local regions = {}
    local prev_key = nil
    for _, match in ipairs(key_specifiers) do
        local note_name = match.note.text
        local major_minor = match.major_minor.text
        local start_pos = match.note.region.e[1]
        if prev_key ~= nil then
            regions[#regions + 1] =
                { key = { prev_key.note_name, prev_key.major_minor }, line = { prev_key.start_pos + 1, start_pos } }
        end
        prev_key = { note_name = note_name, major_minor = major_minor, start_pos = start_pos }
    end
    if prev_key ~= nil then
        regions[#regions + 1] =
            { key = { prev_key.note_name, prev_key.major_minor }, line = { prev_key.start_pos + 1, -1 } }
    end
    return regions
end

function get_matches()
    return vim.iter(key_regions())
        :map(function(t)
            local notes = key_to_scale_notes[t.key[1] .. t.key[2]]
            return { t = t, matches = tree.find_buf_matches(create_query_str(notes)) }
        end)
        :totable()
end

local function highlight_non_scale_note()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    vim.iter(key_regions())
        :map(function(t)
            local notes = key_to_scale_notes[t.key[1] .. t.key[2]]
            return tree.find_buf_matches(create_query_str(notes), { start = t.line[1], stop = t.line[2] })
        end)
        :flatten(1)
        :each(function(matches)
            local pitch = matches.pitch
            local region = pitch.region

            vim.api.nvim_buf_add_highlight(0, ns, "LilypondAccidental", region.s[1] - 1, region.s[2] - 1, region.e[2])
        end)
end

highlight_non_scale_note()

local len_dict = {
    ["16"] = 1,
    ["8"] = 2,
    ["8."] = 3,
    ["4"] = 4,
    ["4."] = 6,
    ["4.."] = 7,
    ["2"] = 8,
    ["2."] = 12,
    ["2.."] = 14,
    ["1"] = 16,
}

local ns = vim.api.nvim_create_namespace("lilypond_cursor_line_note")
local function show_cursor_line_note_length()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    local cur = vim.fn.getcurpos()
    local matches = tree.find_buf_matches(
        [[
        ((note_item (len)? @len) @note)
        ((rest_item (len)? @len) @rest)
        ]],
        { start = cur[2] - 1, stop = cur[2] }
    )
    local sum = 0
    local current_len = nil
    for _, match in ipairs(matches) do
        if match.len ~= nil then
            local len = len_dict[match.len.text]
            sum = sum + len
            current_len = len
        elseif current_len ~= nil then
            sum = sum + current_len
        end
    end

    if sum > 0 then
        local hl = "Comment"
        if sum ~= 16 then
            hl = "WarningMsg"
        end
        vim.api.nvim_buf_set_extmark(0, ns, cur[2] - 1, cur[3] - 1, {
            virt_text = { { "SUM: " .. tostring(sum), hl } },
            virt_text_pos = "right_align",
        })
    end
end

if not vim.b.loaded then
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = 0,
        callback = function()
            highlight_non_scale_note()

            -- local cursor = vim.fn.getcurpos()
            -- local matches = tree.find_buf_matches(
            --     [[
            --         (note_item) @item
            --     ]],
            --     { start = cursor[2], stop = cursor[2] + 1 }
            -- )
            -- vim.print { matches = matches }
        end,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        buffer = 0,
        callback = function()
            show_cursor_line_note_length()
        end,
    })
end

vim.b.loaded = true

local cmds = {
    "acciaccatura",
    "appoggiatura",
    "grace",
    "slashedGrace",
    "partialLine",
    "break",
    "line",
    "remark",
    "longRest",
}

vim.opt_local.omnifunc = "v:lua.vimrc.omnifunc.lilypond"
function _G.vimrc.omnifunc.lilypond(findstart, base)
    if to_bool(findstart) then
        ---@type string
        local line = vim.fn.getline(".")
        local start = vim.fn.col(".")
        vim.print { line = line, start = start, sub = line:sub(start, start) }
        while start > 0 do
            start = start - 1
            if line:sub(start, start) == "\\" then
                return start
            end
        end
        return vim.fn.col(".") - 1
    end

    ---@type string[]
    return vim.iter(cmds)
        :filter(function(s)
            return vim.regex("^" .. base):match_str(s) ~= nil
        end)
        :totable()
end

-- local key_to_scale_map = {
--     ["c\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["a\\minor"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--
--     ["des\\major"] = { ees = "es", cis = "des", eis = "f", fis = "ges", gis = "aes", ais = "bes", bis = "c" },
--     ["bes\\minor"] = { ees = "es", cis = "des", eis = "f", fis = "ges", gis = "aes", ais = "bes", bis = "c" },
--
--     ["d\\major"] = { ces = "b", fes = "e", ges = "fis", des = "cis" },
--     ["b\\minor"] = { ces = "b", fes = "e", ges = "fis", des = "cis" },
--
--     ["ees\\major"] = { ees = "es", eis = "f", bis = "c", gis = "aes", ais = "bes" },
--     ["c\\minor"] = { ees = "es", eis = "f", bis = "c", gis = "aes", ais = "bes" },
--
--     ["e\\major"] = { ees = "dis", fes = "e", ces = "b", ges = "fis", aes = "gis", des = "cis", es = "dis" },
--     ["cis\\minor"] = { ees = "dis", fes = "e", ces = "b", ges = "fis", aes = "gis", des = "cis", es = "dis" },
--
--     ["f\\major"] = { eis = "f", bis = "c", fes = "e", ais = "bes" },
--     ["d\\minor"] = { "f", "g", "a", "bes", "c", "d", "e" },
--
--     ["ges\\major"] = {},
--     ["es\\minor"] = { "ges", "aes", "bes", "ces", "des", "ees", "f" },
--
--     ["g\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["e\\minor"] = { "g", "a", "b", "c", "d", "e", "fis" },
--
--     ["aes\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["f\\minor"] = { "aes", "bes", "c", "des", "ees", "f", "g" },
--
--     ["a\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["fis\\minor"] = { "a", "b", "cis", "d", "e", "fis", "gis" },
--
--     ["bes\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["g\\minor"] = { "bes", "c", "d", "ees", "f", "g", "a" },
--
--     ["b\\major"] = { bis = "c", ces = "b", eis = "f", fes = "e" },
--     ["gis\\minor"] = { "b", "cis", "dis", "e", "fis", "gis", "ais" },
--
--     ["fis\\major"] = { "fis", "gis", "ais", "b", "cis", "dis", "eis" },
-- }

create_cmd("LilypondNoteNormalize") {
    range = "%",
    nargs = 1,
    function(meta)
        local key = meta.args
        tree.replace_buf("(pitch) @-", function(text)
            return lilypond.normalize_note(text, key)
        end, {
            start = meta.line1 - 1,
            stop = meta.line2,
        })
    end,
}

create_cmd("LilypondNoteIncrement") {
    range = "%",
    nargs = 1,
    function(meta)
        local key = meta.args
        tree.replace_buf("(pitch) @-", function(text)
            return lilypond.increment_note(text, key, 1)
        end, {
            start = meta.line1 - 1,
            stop = meta.line2,
        })
    end,
}

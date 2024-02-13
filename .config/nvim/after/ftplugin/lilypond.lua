require("lazy").load { plugins = { "dial.nvim", "general-converter.nvim" } }

vim.b.did_ftplugin = 1
vim.opt_local.runtimepath:append {
    "/opt/homebrew/share/lilypond/2.24.1/vim",
}

vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "@q", "<Cmd>!cd %:h; lilypond %:t<CR>", { buffer = true })
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })

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

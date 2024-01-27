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
            })[value]
            results[#results + 1] = new_value
        end
        return table.concat(results, " ")
    end)),
    { expr = true, buffer = true }
)

vim.keymap.set(
    { "n", "x" },
    "@f",
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
            })[value]
            results[#results + 1] = new_value
        end
        return table.concat(results, " ")
    end)),
    { expr = true, buffer = true }
)

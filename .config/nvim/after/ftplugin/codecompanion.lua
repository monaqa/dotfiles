local mapset = require("monaqa.shorthand").mapset_local
local create_cmd = require("monaqa.shorthand").create_cmd_local

local Path = require("plenary.path")
local data_path = vim.fn.stdpath("data")
local save_folder = Path:new(data_path, "cc_saves")

-- thanks to https://gist.github.com/itsfrank/942780f88472a14c9cbb3169012a3328
-- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
create_cmd("CodeCompanionSave") {
    nargs = "*",
    function(opts)
        local codecompanion = require("codecompanion")
        local success, chat = pcall(function()
            return codecompanion.buf_get_chat(0)
        end)
        if not success or chat == nil then
            vim.notify("CodeCompanionSave should only be called from CodeCompanion chat buffers", vim.log.levels.ERROR)
            return
        end

        if #opts.fargs == 0 then
            vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
        end
        local save_name = table.concat(opts.fargs, "-") .. ".md"
        local save_path = Path:new(save_folder, save_name)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        save_path:write(table.concat(lines, "\n"), "w")
    end,
}

mapset.ca("w") {
    expr = true,
    function()
        if vim.b.codecompanion_filename == nil then
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            local datetime = vim.fn.strftime("%Y-%m-%d-%H-%M")
            vim.b.codecompanion_filename = cwd .. "-" .. datetime .. ".md"
        end
        return "CodeCompanionSave " .. vim.b.codecompanion_filename
    end,
}

local monaqa = require("monaqa")
local autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
local mapset = monaqa.shorthand.mapset_local

vim.opt_local.commentstring = "%% %s"

local function get_format()
    local line = vim.fn.getline(1)
    local format = string.match(line, "^%%%% autocompile: (%w+)")
    return format
end

autocmd_vimrc("BufWritePost") {
    key = "mermaid-compile-on-save",
    desc = [[保存時に自動で mermaid compiler (mmdc) を実行する]],
    pattern = "*.mmd",
    callback = function(args)
        local line = vim.fn.getline(1)
        local format = get_format()

        if format then
            local supported_formats = { svg = true, png = true, pdf = true }
            if supported_formats[format] then
                local command = {
                    "mmdc",
                    "-i",
                    vim.fn.expand("%"),
                    "-o",
                    vim.fn.expand("%:r") .. "." .. format,
                }
                if format == "pdf" then
                    table.insert(command, "--pdfFit")
                end
                vim.system(command)
            end
        end
    end,
}

mapset.n("@o") {
    desc = [[PDF などを開く]],
    function()
        local format = get_format()
        local objective = vim.fn.resolve(vim.fn.expand("%"))
        local target = vim.fn.fnamemodify(objective, ":r") .. "." .. format
        vim.cmd([[!open ]] .. target)
    end,
}

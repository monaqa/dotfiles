local autocmd_vimrc = require("monaqa").shorthand.autocmd_vimrc

vim.opt_local.commentstring = "%% %s"

autocmd_vimrc("BufWritePost") {
    key = "mermaid-compile-on-save",
    desc = [[保存時に自動で mermaid compiler (mmdc) を実行する]],
    pattern = "*.mmd",
    callback = function(args)
        if vim.fn.getline(1) == "%% autocompile: svg" then
            vim.system {
                "mmdc",
                "-i",
                vim.fn.expand("%"),
                "-o",
                vim.fn.expand("%:r") .. ".svg",
            }
        end
    end,
}

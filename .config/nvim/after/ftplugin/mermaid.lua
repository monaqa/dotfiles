local autocmd_vimrc = require("monaqa").shorthand.autocmd_vimrc

vim.opt_local.commentstring = "%% %s"

autocmd_vimrc("BufWritePost") {
    buffer = 0,
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

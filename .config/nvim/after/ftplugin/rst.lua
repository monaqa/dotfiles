local function rest_title(punc)
    return function()
        local line = vim.fn.getline(".")

        vim.fn.append(".", { string.rep(punc, vim.fn.strdisplaywidth(line)), "" })
    end
end

vim.opt_local.suffixesadd:append(".rst")
vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "<Space>s0", rest_title("#"), { buffer = true })
vim.keymap.set("n", "<Space>s1", rest_title("="), { buffer = true })
vim.keymap.set("n", "<Space>s2", rest_title("-"), { buffer = true })
vim.keymap.set("n", "<Space>s3", rest_title("~"), { buffer = true })
vim.keymap.set("n", "<Space>s4", rest_title([["]]), { buffer = true })
vim.keymap.set("n", "<Space>s5", rest_title("'"), { buffer = true })

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"

vim.keymap.set({ "n" }, "g=", function()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("stylua -", s)
    end)() .. "V"
end, { expr = true, buffer = true })

vim.keymap.set("n", "g==", function()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("stylua -", s)
    end)() .. "_"
end, { expr = true, buffer = true })

vim.keymap.set("ia", "!=", "~=")

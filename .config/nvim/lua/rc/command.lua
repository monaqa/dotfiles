vim.api.nvim_create_user_command("HighlightGroup", function ()
    print(
    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)), "name")
    )
end, {})

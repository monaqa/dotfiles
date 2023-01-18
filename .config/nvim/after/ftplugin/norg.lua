vim.opt_local.conceallevel = 1

vim.api.nvim_buf_create_user_command(0, "CorrectLink", function(meta)
    vim.cmd(([[keeppatterns %s,%ssubstitute/\v\[(.*)\]\((.*)\)/{\2}[\1]/g]]):format(meta.line1, meta.line2))
end, { range = "%" })

vim.api.nvim_buf_create_user_command(0, "ExportMarkdown", function()
    local fname = (vim.fn.expand "%:r") .. ".md"
    vim.cmd["Neorg"] { "export", "to-file", fname }
    vim.cmd.vsplit { fname }
end, {})

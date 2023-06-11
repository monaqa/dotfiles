if not vim.o.readonly then
    vim.print "not readonly"
    vim.opt_local.conceallevel = 0
end

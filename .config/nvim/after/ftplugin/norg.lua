local util = require("rc.util")
vim.opt_local.conceallevel = 1
vim.opt_local.shiftwidth = 2
vim.opt_local.comments = {
    "nb:>",
    "b:- (x)",
    "b:- ( )",
    "b:-",
    "b:--",
    "b:---",
    "b:----",
}
vim.opt_local.formatoptions:remove("c")
vim.opt_local.formatoptions:append { "j", "r" }
vim.opt_local.wrap = false
vim.opt_local.foldlevel = 4

vim.keymap.set("n", "Z", function()
    -- conceallevel の toggle を入れると何故か toggle-concealer がバグる
    vim.opt_local.wrap = not vim.opt_local.wrap:get()
    vim.cmd([[Neorg toggle-concealer]])
end, { buffer = true, nowait = true })

vim.keymap.set(
    "x",
    "L",
    [["lc{<C-r>=substitute(getreg("+"), '\n', '', 'g')<CR>}[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>]<Esc>]],
    { buffer = true }
)

vim.api.nvim_buf_create_user_command(0, "CorrectLink", function(meta)
    vim.cmd(([[keeppatterns %s,%ssubstitute/\v\[(.*)\]\((.*)\)/{\2}[\1]/g]]):format(meta.line1, meta.line2))
end, { range = "%" })

vim.api.nvim_buf_create_user_command(0, "ExportMarkdown", function()
    local fname = (vim.fn.expand("%:r")) .. ".md"
    vim.cmd["Neorg"] { "export", "to-file", fname }
    vim.cmd.vsplit { fname }
end, {})

_G.vimrc.fn.norg_indentexpr = function()
    local bufnr = 0
    local line = vim.v.lnum - 1
    local neorg_treesitter = neorg.modules.get_module("core.integrations.treesitter")
    -- preserve indent of code block
    local node = neorg_treesitter.get_first_node_on_line(bufnr, line)
    local parent_verbatim_tag = neorg_treesitter.find_parent(node:parent(), { "ranged_verbatim_tag" })
    if parent_verbatim_tag ~= nil and node:type() ~= "ranged_verbatim_tag_end" then
        return -1
    end

    return neorg.modules.get_module("core.norg.esupports.indent").indentexpr(bufnr)
end

util.autocmd_vimrc("BufEnter") {
    pattern = "*.norg",
    callback = function()
        vim.opt_local.indentexpr = "v:lua.vimrc.fn.norg_indentexpr()"
    end,
}

vim.cmd([[
    inoreabbrev <buffer><expr> ) (getline('.') =~# '\s*- )') ? '( )' : ')'
]])

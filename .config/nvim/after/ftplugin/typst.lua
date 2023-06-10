vim.opt_local.shiftwidth = 2

vim.opt_local.commentstring = "// %s"
vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })

vim.keymap.set(
    "x",
    "L",
    [["lc#link("<C-r>=substitute(getreg("+"), '\n', '', 'g')<CR>")[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>]<Esc>]],
    {
        buffer = true,
    }
)

vim.opt_local.comments = {
    "nb:>",
    "b:-",
    "b:1. ",
}

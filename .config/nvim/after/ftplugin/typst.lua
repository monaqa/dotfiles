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

vim.api.nvim_buf_create_user_command(
    0,
    "PutClipboardImage",
    require("rc.clipboard").command_put_clipboard_image {
        fn_image_path = function(name)
            local current_file_dir = vim.fn.expand "%:h"
            local dir = current_file_dir .. "/image/"
            if name == nil or name == "" then
                name = vim.fn.strftime "%Y-%m-%d-%H-%M-%S"
            end
            return dir .. name .. ".png"
        end,
        fn_markup_string = function(name, path)
            local prev_dir = vim.fn.chdir(vim.fn.expand "%:h")
            local relpath = vim.fn.fnamemodify(path, ":.")
            vim.fn.chdir(prev_dir)
            return {
                "#align(center)[",
                ([[  #imag("%s", width: 85%%)]]):format(relpath),
                "]",
            }
        end,
    },
    { nargs = "*" }
)

vim.keymap.set("n", "@p", "<Cmd>PutClipboardImage<CR>", { buffer = true })

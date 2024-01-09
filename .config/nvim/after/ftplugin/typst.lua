local uv = vim.loop
local diary = require "rc.diary"
local util = require "rc.util"

vim.opt_local.shiftwidth = 2
vim.opt_local.foldmethod = "manual"
vim.opt_local.commentstring = "// %s"

-- vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })
vim.keymap.set("n", "@o", function()
    vim.cmd [[!open %:r.pdf]]
end, { buffer = true })

vim.keymap.set("n", "@q", function()
    vim.cmd [[!typst compile %]]
end, { buffer = true })

-- util.autocmd_vimrc "BufWritePost" {
--     buffer = 0,
--     callback = function()
--         if diary.is_diary_file() then
--             diary.compile(diary.preview_file())
--         end
--     end,
-- }

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
        fn_markup_string = function(_, path)
            local fname = vim.fn.fnamemodify(path, ":t:r")
            -- local prev_dir = vim.fn.chdir(vim.fn.expand "%:h")
            -- local relpath = vim.fn.fnamemodify(path, ":.")
            -- vim.fn.chdir(prev_dir)
            return {
                "#align(center)[",
                ([[  #image("image/%s.png", width: 85%%)]]):format(fname),
                "]",
            }
        end,
    },
    { nargs = "*" }
)

vim.keymap.set("n", "@p", "<Cmd>PutClipboardImage<CR>", { buffer = true })

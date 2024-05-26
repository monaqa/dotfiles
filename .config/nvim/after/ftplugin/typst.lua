local uv = vim.uv
local diary = require("rc.diary")
local util = require("rc.util")

vim.opt_local.shiftwidth = 2
vim.opt_local.foldmethod = "manual"
vim.opt_local.commentstring = "// %s"
vim.opt_local.formatoptions:append("r")

vim.opt_local.comments = {
    "b:- ",
    "b:+ ",
}

local function resolve_target()
    local line = vim.fn.getline(1)
    local _, _, file = line:find([[^//! target:%s*(%S+)$]])
    if file ~= nil then
        return vim.fn.resolve(vim.fn.expand("%:h") .. "/" .. file)
    else
        return vim.fn.resolve(vim.fn.expand("%"))
    end
end

-- vim.keymap.set("n", "@o", ":!open %:r.pdf<CR>", { buffer = true })
vim.keymap.set("n", "@o", function()
    local objective = resolve_target()
    local target = vim.fn.fnamemodify(objective, ":r") .. ".pdf"
    vim.cmd([[!open ]] .. target)
end, { buffer = true })

vim.keymap.set("n", "@q", function()
    local objective = resolve_target()
    vim.cmd([[!typst compile ]] .. objective)
end, { buffer = true })

vim.api.nvim_create_augroup("vimrc_typst", { clear = true })
vim.api.nvim_clear_autocmds { group = "vimrc_typst" }
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "vimrc_typst",
    pattern = "*.typ",
    callback = function()
        local objective = resolve_target()
        -- vim.fn.system { "typst", "compile", objective }
        uv.spawn("typst", { args = { "compile", objective } }, function() end)
    end,
})

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
            local current_file_dir = vim.fn.expand("%:h")
            local dir = current_file_dir .. "/image/"
            if name == nil or name == "" then
                name = vim.fn.strftime("%Y-%m-%d-%H-%M-%S")
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

-- vim.keymap.set("n", "<Space>p", function()
--     local reg = vim.fn.getreg("+")
--     local after = vim.fn.substitute(reg, [[\v\[(.*)\]\((.*)\)]], [=[#link("\2")[\1]]=], "g")
--     vim.fn.setreg("+", after)
--     vim.cmd([[put +]])
-- end, { buffer = true })

vim.api.nvim_buf_create_user_command(0, "CorrectLinks", function(meta)
    vim.cmd(([=[
        keeppatterns %s,%ss/\v\[(.*)\]\((.*)\)/#link("\2")[\1]/g
    ]=]):format(meta.line1, meta.line2))
end, {
    range = "%",
})

vim.keymap.set("n", "g=", function()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("typstfmt", s)
    end)() .. "V"
end, { expr = true, buffer = true })

vim.keymap.set("x", "g=", function()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("typstfmt", s)
    end)()
end, { expr = true, buffer = true })

vim.keymap.set("n", "g==", function()
    return require("general_converter").operator_convert(function(s)
        return vim.fn.system("typstfmt", s)
    end)() .. "_"
end, { expr = true, buffer = true })

vim.keymap.set({ "n", "x" }, "gy", require("general_converter").operator_convert("pandoc"), { expr = true })

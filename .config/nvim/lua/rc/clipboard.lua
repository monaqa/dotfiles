-- Clipboard の image をいい感じに貼り付けるためのスクリプト。

local util = require("rc.util")

local M = {}

-- AppleScript を用いて指定したパスにクリップボードの画像を保存する。
local function save_cliboard_image(filepath)
    local out = vim.fn.system {
        "osascript",
        vim.fn.stdpath("config") .. "/resource/save_clipboard_image.applescript",
        vim.fn.fnamemodify(filepath, ":p"),
    }
    if vim.startswith(out, "ERROR") then
        error(out)
    end
end

---@param image_path string
---@param markup_string string | string[]
function M.put_clipboard_image(image_path, markup_string)
    local parent_dir = vim.fn.fnamemodify(image_path, ":p:h")
    if not util.to_bool(vim.fn.isdirectory(parent_dir)) then
        vim.fn.mkdir(parent_dir, "p")
        vim.notify("Created new directory: " .. parent_dir)
    end
    save_cliboard_image(image_path)
    vim.fn.append(".", markup_string)
end

---@alias f_image_path fun(name: string): string
---@alias f_markup_string fun(name: string, path: string): string | string[]

--- fn_image_path を使って保存先のファイルパスを決定
--- fn_markup_string を使って挿入する文字列を決定
---@param t {fn_image_path: f_image_path, fn_markup_string: f_markup_string}
function M.command_put_clipboard_image(t)
    return function(meta)
        local image_path = t.fn_image_path(meta.args)
        local markup_string = t.fn_markup_string(meta.args, image_path)
        M.put_clipboard_image(image_path, markup_string)
    end
end
return M

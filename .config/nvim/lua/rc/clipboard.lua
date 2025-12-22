-- Clipboard をいい感じに管理するためのスクリプト。

local monaqa = require("monaqa")
local logic = monaqa.logic

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
    if not logic.to_bool(vim.fn.isdirectory(parent_dir)) then
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

---@param html string
---@return string
local function html_to_apple_hex(html)
    local utf8_bytes = {}
    for i = 1, string.len(html) do
        utf8_bytes[i] = html:byte(i)
    end
    local hex = ""
    for _, b in ipairs(utf8_bytes) do
        hex = hex .. string.format("%02X", b)
    end
    return hex
end

---@param text string
---@param filetype? string
function M.copy_html_to_clipboard(text, filetype)
    if filetype == nil then
        filetype = "markdown"
    end

    local result = vim.system({ "pandoc", "-f", filetype, "-t", "html", "--wrap=none" }, { stdin = text }):wait()
    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return
    end
    local html = result.stdout or ""
    local hex = html_to_apple_hex(html)
    local escaped_text = text:gsub([[\]], [[\\]]):gsub('"', [[\"]]):gsub("\n", [[\n]])

    local script = "set the clipboard to { «class HTML»:«data HTML" .. hex .. '», string:"' .. escaped_text .. '"}'
    result = vim.system({ "osascript", "-e", script }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return
    end

    vim.notify("Both HTML and plain text have been set to the clipboard.", vim.log.levels.INFO)
end

---@return string[] | nil
function M.detect_clipboard_type()
    local result = vim.system({ "osascript", "-e", "clipboard info" }):wait()
    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return nil
    end
    local output = result.stdout or ""
    local types = {}
    for class in output:gmatch("«class%s+([A-Za-z0-9%s]+)»") do
        class = class:gsub("%s+", "") -- "RTF " のような末尾スペースを削除
        table.insert(types, class)
    end
    return types
end

---@param to_format? string
---@return string|nil
function M.put_html_from_clipboard(to_format)
    to_format = to_format or "gfm"

    local result = vim.system({ "osascript", "-e", "get the clipboard as «class HTML»" }):wait()
    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return nil
    end
    local hex = result.stdout:match("«data HTML([0-9A-F]+)»")
    local bytes = {}
    for byte in hex:gmatch("%x%x") do
        table.insert(bytes, string.char(tonumber(byte, 16)))
    end
    local html = table.concat(bytes)

    local conv = vim.system({ "pandoc", "-f", "html", "-t", to_format }, { stdin = html }):wait()
    if conv.code ~= 0 then
        vim.notify(conv.stderr, vim.log.levels.ERROR)
        return nil
    end

    return conv.stdout
end

return M

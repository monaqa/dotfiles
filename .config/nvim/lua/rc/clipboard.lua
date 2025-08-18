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

--- Convert raw HTML into Apple HTML pasteboard format
--- @param html string Raw HTML fragment (e.g. <p><b>foo</b></p>)
--- @return string payload  Apple HTML clipboard payload
function to_apple_html_clipboard(html)
    -- ラップ用 HTML 全体を組み立てる
    local fragment = "<!--StartFragment-->" .. html .. "<!--EndFragment-->"
    local full_html = "<html><body>\n" .. fragment .. "\n</body></html>"

    -- ヘッダ部分は後でサイズを埋め込む
    local header_template = table.concat({
        "Version:0.9",
        "StartHTML:%010d",
        "EndHTML:%010d",
        "StartFragment:%010d",
        "EndFragment:%010d",
        "", -- 空行で区切る
    }, "\n")

    -- 仮にゼロ埋めしてヘッダ文字列を作る
    local header_dummy = string.format(header_template, 0, 0, 0, 0)

    -- 実際にオフセットを計算（バイト数）
    local start_html = #header_dummy
    local end_html = start_html + #full_html
    local start_fragment = start_html + string.find(full_html, "<!--StartFragment-->", 0, true) - 1
    local end_fragment = start_html + string.find(full_html, "<!--EndFragment-->", 0, true) - 1 + #"<!--EndFragment-->"

    -- 正しい値でヘッダを再構成
    local header = string.format(header_template, start_html, end_html, start_fragment, end_fragment)

    return header .. full_html
end

local function html_to_apple_hex(html)
    local utf8_bytes = { string.byte(html, 1, -1) }
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

    local html = vim.system({ "pandoc", "-f", filetype, "-t", "html", "--wrap=none" }, { stdin = text }):wait().stdout
    html = html:gsub('"', '\\"'):gsub("\n", "")
    local hex = html_to_apple_hex(html)

    local script = "set the clipboard to { «class HTML»:«data HTML" .. hex .. '», string:"' .. text .. '"}'
    vim.system { "osascript", "-e", script }

    vim.notify("Both HTML and plain text have been set to the clipboard.", vim.log.levels.INFO)
end

return M

local obsidian = require "rc.obsidian"

vim.keymap.set("n", "gf", function ()
    local shortcut_link = obsidian.get_cursor_shortcut_link()
    if shortcut_link ~= nil then
        -- [[filename|エイリアス名]] のような記法でも使えるように
        local link_name = vim.split(shortcut_link, "|")[1]
        local note_root = "/Users/monaqa/Documents/obsidian/mogamemo/note/"
        vim.cmd("e " .. note_root .. link_name .. ".md")
    else
        vim.cmd[[normal! gf]]
    end
end, {buffer = true})

function _G.vimrc.omnifunc.obsidian(findstart, base)
    return obsidian.omnifunc(findstart, base)
end
vim.opt_local.omnifunc = "v:lua.vimrc.omnifunc.obsidian"

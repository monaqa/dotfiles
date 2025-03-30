local wezterm = require("wezterm")
local colorimetry = require("colorimetry")

local M = {}

local clr = colorimetry.tab

---@param dir_name string
---@return string
local function stem(dir_name)
    if dir_name:find("/", 1, true) == nil then
        return dir_name
    end
    if dir_name:find("/.worktree/", 1, true) ~= nil then
        local idx = dir_name:find("/.worktree/", 1, true)
        return dir_name:sub(idx + 11)
    end
    local rev_dir = dir_name:reverse()
    return rev_dir:sub(1, rev_dir:find("/", 1, true) - 1):reverse()
end

---@param text string
---@param max_len integer
---@return string
local function trim_middle(text, max_len)
    if #text <= max_len then
        return text
    end
    local len_start = max_len // 2
    local len_end = max_len - len_start - 1
    return text:sub(1, len_start) .. "…" .. text:sub(#text - len_end + 1, #text)
end

local function align_spaces(text, width)
    if #text >= width then
        return "", ""
    end
    local left_n_spaces = (width - #text) // 2
    local left_spaces = (" "):rep(left_n_spaces)
    local right_spaces = (" "):rep(width - #text - left_n_spaces)
    return left_spaces, right_spaces
end

function M.format_tab_title(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local current_ps = stem(pane.foreground_process_name)
    local current_dir = stem(pane.current_working_dir.path)

    local ps_title
    if current_ps == nil or current_ps == "" or current_ps == "fish" then
        ps_title = ""
    elseif current_ps == "nvim" then
        ps_title = " "
    else
        ps_title = ([[(%s) ]]):format(trim_middle(current_ps, 8))
    end

    return {
        { Attribute = { Intensity = "Normal" } },
        { Text = " " },
        { Text = ps_title },
        { Attribute = { Intensity = "Bold" } },
        { Text = current_dir },
        { Text = " " },
        { Attribute = { Intensity = "Normal" } },
    }
end

M.window_frame = {
    -- The font used in the tab bar.
    -- Roboto Bold is the default; this font is bundled
    -- with wezterm.
    -- Whatever font is selected here, it will have the
    -- main font setting appended to it to pick up any
    -- fallback fonts you may have used there.
    font = wezterm.font { family = "CommitMono-height105", weight = "Bold" },

    -- The size of the font in the tab bar.
    -- Default to 10.0 on Windows but 12.0 on other systems
    font_size = 14.0,

    -- The overall background color of the tab bar when
    -- the window is focused
    active_titlebar_bg = clr.titlebar_bg.active,

    -- The overall background color of the tab bar when
    -- the window is not focused
    inactive_titlebar_bg = clr.titlebar_bg.inactive,
}

return M

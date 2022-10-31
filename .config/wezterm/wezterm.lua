local wezterm = require 'wezterm';

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0ba)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b8)

local MAX_TAB_WIDTH = 60

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

---@param home_dir string
---@return string[]
local function path_env(home_dir)
    return {
        "/opt/homebrew/bin",
        "/opt/homebrew/sbin",
        "/usr/local/bin",
        "/usr/bin",
        "/bin",
        "/usr/sbin",
        "/sbin",
        ("%s/.local/bin"):format(home_dir),
        ("%s/.cargo/bin"):format(home_dir),
        ("%s/.deno/bin"):format(home_dir),
    }
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local max_text_width = max_width - 2
    local edge_background = "#3c3836"
    local background = "#504945"
    local foreground = "#948570"
    if tab.is_active then
        background = "#7a7068"
        foreground = "#ebdbb2"
        -- elseif hover then
        --   background = "#3b3052"
        --   foreground = "#909090"
    end
    local edge_foreground = background

    local pane = tab.active_pane
    local current_ps = stem(pane.foreground_process_name)
    local current_dir = stem(pane.current_working_dir)

    local ps_title
    if current_ps == nil or current_ps == "fish" then
        ps_title = ""
    else
        ps_title = ([[(%s) ]]):format(trim_middle(current_ps, 8))
    end
    -- local dir_title = trim_middle(current_dir, MAX_TAB_WIDTH - #ps_title)

    local title_width = max_text_width - #ps_title
    local dir_title = trim_middle(current_dir, title_width)
    local left_spaces, right_spaces = align_spaces(ps_title .. dir_title, max_text_width)

    return {
        {Background={Color=edge_background}},
        {Foreground={Color=edge_foreground}},
        {Text=SOLID_LEFT_ARROW},
        {Background={Color=background}},
        {Foreground={Color=foreground}},
        {Attribute={Intensity="Normal"}},
        {Text=left_spaces},
        {Text=ps_title},
        {Attribute={Intensity="Bold"}},
        {Text=dir_title},
        {Text=right_spaces},
        {Attribute={Intensity="Normal"}},
        {Background={Color=edge_background}},
        {Foreground={Color=edge_foreground}},
        {Text=SOLID_RIGHT_ARROW},
    }
end)

wezterm.on("toggle-bg-opacity", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1.0
    else
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("toggle-mode-screenshare", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.font_size then
        overrides.window_background_opacity = 1.0
        overrides.font_size = 12.0 * 2
        overrides.enable_tab_bar = false
    else
        overrides.window_background_opacity = nil
        overrides.font_size = nil
        overrides.enable_tab_bar = nil
    end
    window:set_config_overrides(overrides)
end)

-- wezterm.on("update-right-status", function(window, pane)
--     local compose = window:composition_status()
--     if compose then
--         compose = "COMPOSING: " .. compose
--     else
--         compose = ""
--     end
--     window:set_right_status(compose)
-- end);

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
    local scrollback = pane:get_logical_lines_as_text(10000)
    local name = os.tmpname()
    local f = io.open(name, "w+")
    f:write(scrollback)
    f:flush()
    f:close()
    window:perform_action(
    wezterm.action{
        SpawnCommandInNewTab = {
            set_environment_variables = { PATH = table.concat(path_env("monaqa"), ":")},
            args = { "nvim", name },
        }
    },
    pane
    )
    wezterm.sleep_ms(1000)
    os.remove(name)
end)

-- color theme
local scheme = wezterm.get_builtin_color_schemes()["Gruvbox Dark"]
scheme.compose_cursor = "gray"

return {
    default_prog = {"/opt/homebrew/bin/fish", "-l"},
    -- font config
    -- /Users/monaqa/Library/Fonts/Hack Regular Nerd Font Complete.ttf, CoreText
    -- font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", italic=false}),
    font = wezterm.font_with_fallback({
        {family="Hack Nerd Font", weight="Regular", stretch="Normal", italic=false},
        -- {family="YuGothic", weight="Regular", stretch="Normal"},
        {family="Noto Sans CJK JP", weight="Regular", stretch="Normal"},
        -- {family="BIZ UDPGothic", weight="Regular", stretch="Normal"},
        -- {family="IBM Plex Sans JP", weight="Regular", stretch="Normal"},
    }),
    font_size = 14.0,
    use_ime = true,
    freetype_load_flags = "NO_HINTING",

    -- colors
    color_schemes = {
        ["Gruvbox-monaqa-oriented"] = scheme,
    },
    color_scheme = "Gruvbox-monaqa-oriented",

    -- tab
    -- window_decolations = "TITLE" | "RESIZE",
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = false,
    tab_max_width = MAX_TAB_WIDTH + 2,
    window_frame = {
        font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", italic=false}),
    },
    -- tab_bar_at_bottom = true,

    -- window
    adjust_window_size_when_changing_font_size = false,
    window_background_opacity = 0.85,
    -- text_background_opacity = 0.85,
    window_padding = {
        left = "1cell",
        right = "1cell",
        -- top = "2.5cell",
        top = "0.3cell",
        bottom = "0cell",
    },
    -- status_update_interval = 1000,
    canonicalize_pasted_newlines = "None",

    -- key mappings
    -- disable_default_key_bindings = true,
    send_composed_key_when_left_alt_is_pressed=false,
    key_map_preference = "Physical",
    -- leader = { key = "s", mods = "CTRL", timeout_milliseconds=1000 },
    keys = {
        {key="Enter", mods="CMD", action="ToggleFullScreen"},
        {key="q", mods="CTRL", action=wezterm.action{SendString="\x11"}},
        {key=" ", mods="CMD", action="HideApplication"},
        -- { key = ";", mods="CMD|SHIFT", action="IncreaseFontSize"},
        -- { key = "-", mods="CMD|SHIFT", action="ResetFontSize"},
        -- { key = "-", mods="CMD|SHIFT", action="ResetFontSize"},
        { key = "raw:27", mods="CMD|SHIFT", action="ResetFontSize"},
        { key = "raw:27", mods="CMD", action="DecreaseFontSize"},
        { key = "raw:41", mods="CMD|SHIFT", action="IncreaseFontSize"},
        { key = "a", mods="CMD|CTRL", action="IncreaseFontSize"},
        { key = "x", mods="CMD|CTRL", action="DecreaseFontSize"},
        { key = "0", mods="CMD|CTRL", action="ResetFontSize"},

        -- タブの生成、移動、削除
        {key = "t", mods="CMD", action=wezterm.action{SpawnCommandInNewTab={cwd = "/Users/monaqa"}}},
        {key = "t", mods="CMD|SHIFT", action=wezterm.action{ActivateTabRelative=1}},
        {key = "n", mods="CMD", action=wezterm.action{ActivateTabRelative=1}},
        {key = "p", mods="CMD", action=wezterm.action{ActivateTabRelative=-1}},
        {key = "n", mods="CMD|SHIFT", action=wezterm.action{MoveTabRelative=1}},
        {key = "p", mods="CMD|SHIFT", action=wezterm.action{MoveTabRelative=-1}},
        {key = "q", mods="CMD", action=wezterm.action{CloseCurrentPane={confirm=false}}},
        {key = "d", mods="CMD", action=wezterm.action{CloseCurrentPane={confirm=false}}},
        {key = "s", mods="CMD", action="ShowTabNavigator"},
        {key = "w", mods="CMD", action="SpawnWindow"},
        {key = "Tab", mods="CTRL", action="DisableDefaultAssignment"},
        {key = "Tab", mods="CTRL|SHIFT", action="DisableDefaultAssignment"},

        -- window の分割、移動
        {key = "_", mods="CMD", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        -- CMD + | で縦分割
        {key = "raw:93", mods="CMD|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key = "h", mods="CMD", action=wezterm.action{ActivatePaneDirection="Left"}},
        {key = "j", mods="CMD", action=wezterm.action{ActivatePaneDirection="Down"}},
        {key = "k", mods="CMD", action=wezterm.action{ActivatePaneDirection="Up"}},
        {key = "l", mods="CMD", action=wezterm.action{ActivatePaneDirection="Right"}},

        {key = "y", mods="CMD", action=wezterm.action{EmitEvent="trigger-nvim-with-scrollback"}},

        {key = "u", mods="CMD", action=wezterm.action{EmitEvent="toggle-bg-opacity"}},
        {key = "z", mods="CMD", action=wezterm.action{EmitEvent="toggle-mode-screenshare"}},
        -- {key = "d", mods="CMD", action="ShowDebugOverlay"},
        -- { key = "z", mods="CMD", action="TogglePaneZoomState"},
    },

}

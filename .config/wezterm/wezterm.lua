local wezterm = require 'wezterm';

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    ---@type string
    local current_ps = pane.foreground_process_name
    local current_dir = pane.current_working_dir
    local ps_name = nil
    if current_ps:find("/", 1, true) ~= nil then
        local rev_ps = current_ps:reverse()
        ps_name = rev_ps:sub(1, rev_ps:find("/", 1, true) - 1):reverse()
    end
    local rev_dir = current_dir:reverse()
    local dir_name = rev_dir:sub(1, rev_dir:find("/", 1, true) - 1):reverse()
    local tab_title
    if ps_name == nil then
        tab_title = ([[@ %s/]]):format(dir_name)
    else
        tab_title = ([[%s @ %s/]]):format(ps_name, dir_name)
    end

    if tab.is_active then
        return {
            {Background={Color="#575757"}},
            {Text=tab_title},
        }
    end
    return tab_title
end)

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
            set_environment_variables = { PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/monaqa/.local/bin:/Users/monaqa/.cargo/bin" },
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
    -- font config
    -- /Users/monaqa/Library/Fonts/Hack Regular Nerd Font Complete.ttf, CoreText
    -- font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", italic=false}),
    font = wezterm.font_with_fallback({
        {family="Hack Nerd Font", weight="Regular", stretch="Normal", italic=false},
        {family="YuGothic", weight="Regular", stretch="Normal"},
        -- {family="Noto Sans Mono CJK JP", weight="Regular", stretch="Normal"},
    }),
    font_size = 11.0,
    use_ime = true,

    -- colors
    color_schemes = {
        ["Gruvbox-monaqa-oriented"] = scheme,
    },
    color_scheme = "Gruvbox-monaqa-oriented",

    -- tab
    -- window_decolations = "TITLE" | "RESIZE",
    hide_tab_bar_if_only_one_tab = false,
    -- use_fancy_tab_bar = false,
    -- tab_max_width = 20,
    window_frame = {
        font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", italic=false}),
        font_size = 11.0,
    },
    -- tab_bar_at_bottom = true,

    -- window
    adjust_window_size_when_changing_font_size = false,
    window_background_opacity = 0.85,
    window_padding = {
        left = "1cell",
        right = "1cell",
        -- top = "2.5cell",
        top = "0.4cell",
        bottom = "0cell",
    },

    -- key mappings
    -- disable_default_key_bindings = true,
    send_composed_key_when_left_alt_is_pressed=false,
    leader = { key = "s", mods = "CTRL", timeout_milliseconds=1000 },
    keys = {
        {key="Enter", mods="CMD", action="ToggleFullScreen"},
        {key=" ", mods="CMD", action="HideApplication"},
        { key = ";", mods="CMD|SHIFT", action="IncreaseFontSize"},
        { key = "-", mods="CMD|SHIFT", action="ResetFontSize"},

        {key="y", mods="LEADER", action=wezterm.action{EmitEvent="trigger-nvim-with-scrollback"}},
        {key="n", mods="LEADER", action=wezterm.action{ActivateTabRelative=1}},
        {key="p", mods="LEADER", action=wezterm.action{ActivateTabRelative=-1}},
        {key="_", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        {key="v", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key="q", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=false}}},
        {key="c", mods="LEADER", action=wezterm.action{SpawnCommandInNewTab={cwd = "/Users/monaqa"}}},
        {key = "h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
        {key = "j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
        {key = "k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
        {key = "l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
        {key = "s", mods="LEADER", action="ShowTabNavigator"},
        {key = "d", mods="LEADER", action="ShowDebugOverlay"},
        -- { key = "z", mods="LEADER", action="TogglePaneZoomState"},
    },

}

local wezterm = require("wezterm")
local tab = require("tab")
local colorimetry = require("colorimetry")

local MAX_TAB_WIDTH = 60

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

wezterm.on("format-tab-title", tab.format_tab_title)

wezterm.on("toggle-bg-opacity", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if overrides.window_background_opacity then
        overrides.window_background_opacity = nil
    else
        overrides.window_background_opacity = 1.0
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("toggle-mode-screenshare", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.font_size then
        overrides.window_background_opacity = 1.0
        overrides.font_size = 22.0
        overrides.enable_tab_bar = false
    else
        overrides.window_background_opacity = colorimetry.opacity.bg
        overrides.font_size = nil
        overrides.enable_tab_bar = nil
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("update-status", function(window, pane)
    local pinfo = pane:get_foreground_process_info()
    window:set_right_status(window:active_workspace())
    -- local overrides = window:get_config_overrides() or {}
    -- if pinfo.name == "nvim" then
    --     overrides.window_background_opacity = 0.0
    -- else
    --     overrides.window_background_opacity = colorimetry.opacity.bg
    -- end
    -- window:set_config_overrides(overrides)
    window:set_left_status(pinfo.name)
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
        wezterm.action {
            SpawnCommandInNewTab = {
                set_environment_variables = { PATH = table.concat(path_env("monaqa"), ":") },
                args = { "nvim", name },
            },
        },
        pane
    )
    wezterm.sleep_ms(1000)
    os.remove(name)
end)

return {
    default_prog = { "/opt/homebrew/bin/fish", "-l" },
    -- default_prog = {"/opt/homebrew/bin/fish", "-c", [[tmux new-session -A -s "default"]]},
    -- font config
    -- /Users/monaqa/Library/Fonts/Hack Regular Nerd Font Complete.ttf, CoreText
    -- font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", italic=false}),
    font = wezterm.font_with_fallback {
        { family = "CommitMono-height105-nokern", weight = 450, stretch = "Normal", style = "Normal" },
        { family = "Hack Nerd Font", weight = "Regular", stretch = "Normal" },
        { family = "Noto Sans CJK JP", weight = "Regular", stretch = "Normal" },
    },

    font_size = 16.0,
    use_ime = true,
    macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",
    freetype_load_flags = "NO_HINTING",

    initial_rows = 58,
    initial_cols = 187,

    -- colors
    color_schemes = {
        ["colorimetry"] = colorimetry.scheme,
    },
    color_scheme = "colorimetry",
    colors = colorimetry.config_colors,

    -- tab
    -- window_decolations = "TITLE" | "RESIZE",
    hide_tab_bar_if_only_one_tab = false,
    -- tab_max_width = MAX_TAB_WIDTH + 2,
    use_fancy_tab_bar = true,
    window_frame = tab.window_frame,
    window_decorations = "RESIZE",
    -- tab_bar_at_bottom = true,

    -- window
    adjust_window_size_when_changing_font_size = false,
    window_background_opacity = colorimetry.opacity.bg,
    text_background_opacity = colorimetry.opacity.fg,
    window_padding = {
        left = "0.5cell",
        right = "0.5cell",
        -- top = "2.5cell",
        top = "0.3cell",
        bottom = "0cell",
    },
    -- status_update_interval = 1000,
    canonicalize_pasted_newlines = "None",

    debug_key_events = true,

    -- key mappings
    -- disable_default_key_bindings = true,
    send_composed_key_when_left_alt_is_pressed = false,
    key_map_preference = "Physical",
    -- leader = { key = "s", mods = "CTRL", timeout_milliseconds=1000 },
    keys = {
        -- works as a hotkey
        { key = "Enter", mods = "CMD", action = "ToggleFullScreen" },
        { key = " ", mods = "CMD", action = "HideApplication" },

        {
            key = "f",
            mods = "CMD",
            action = wezterm.action.SpawnCommandInNewWindow {
                args = { "/opt/homebrew/bin/fish" },
            },
        },

        -- works as default

        { key = "q", mods = "CTRL", action = wezterm.action { SendString = "\x11" } },
        { key = "Tab", mods = "CTRL", action = "DisableDefaultAssignment" },
        { key = "Tab", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },

        -- change font size

        -- { key = "raw:27", mods = "CMD|SHIFT", action = "ResetFontSize" },
        { key = "!", mods = "CMD|SHIFT", action = "ResetFontSize" },
        { key = "raw:27", mods = "CMD", action = "DecreaseFontSize" },
        { key = "raw:41", mods = "CMD|SHIFT", action = "IncreaseFontSize" },
        { key = "0", mods = "CMD|CTRL", action = "ResetFontSize" },

        { key = "u", mods = "CMD|SHIFT", action = wezterm.action.CharSelect {} },

        -- タブの生成、移動、削除
        -- thanks to sankantsu: https://zenn.dev/sankantsu/articles/e713d52825dbbb
        { key = "t", mods = "CMD", action = wezterm.action { SpawnCommandInNewTab = { cwd = "/Users/monaqa" } } },
        {
            key = "t",
            mods = "CMD|SHIFT",
            action = wezterm.action.PromptInputLine {
                description = "(wezterm) Create new workspace:",
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:perform_action(
                            wezterm.action.SwitchToWorkspace {
                                name = line,
                            },
                            pane
                        )
                    end
                end),
            },
        },
        {
            mods = "CMD",
            key = "s",
            action = wezterm.action_callback(function(win, pane)
                -- workspace のリストを作成
                local workspaces = {}
                for i, name in ipairs(wezterm.mux.get_workspace_names()) do
                    table.insert(workspaces, {
                        id = name,
                        label = string.format("%d. %s", i, name),
                    })
                end
                local current = wezterm.mux.get_active_workspace()
                -- 選択メニューを起動
                win:perform_action(
                    wezterm.action.InputSelector {
                        action = wezterm.action_callback(function(_, _, id, label)
                            if not id and not label then
                                wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
                            else
                                win:perform_action(wezterm.action.SwitchToWorkspace { name = id }, pane) -- workspace を移動
                            end
                        end),
                        title = "Select workspace",
                        choices = workspaces,
                        fuzzy = true,
                        -- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
                    },
                    pane
                )
            end),
        },
        { key = "h", mods = "CMD", action = wezterm.action { ActivateTabRelative = -1 } },
        { key = "l", mods = "CMD", action = wezterm.action { ActivateTabRelative = 1 } },
        { key = "j", mods = "CMD", action = wezterm.action.SwitchWorkspaceRelative(1) },
        { key = "k", mods = "CMD", action = wezterm.action.SwitchWorkspaceRelative(-1) },
        { key = "d", mods = "CMD", action = wezterm.action { CloseCurrentPane = { confirm = false } } },

        -- window の分割、移動
        { key = "_", mods = "CMD", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
        -- -- CMD + | で縦分割
        {
            key = "raw:93",
            mods = "CMD|SHIFT",
            action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
        },

        { key = "h", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Left" } },
        { key = "j", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Down" } },
        { key = "k", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Up" } },
        { key = "l", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Right" } },

        { key = "y", mods = "CMD", action = wezterm.action { EmitEvent = "trigger-nvim-with-scrollback" } },

        { key = "u", mods = "CMD", action = wezterm.action { EmitEvent = "toggle-bg-opacity" } },
        { key = "z", mods = "CMD", action = wezterm.action { EmitEvent = "toggle-mode-screenshare" } },
        -- {key = "d", mods="CMD", action="ShowDebugOverlay"},
        -- { key = "z", mods="CMD", action="TogglePaneZoomState"},
    },
}

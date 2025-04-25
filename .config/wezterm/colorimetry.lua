local M = {}

-- §§1 基本色
local fg = {
    w0 = "#e0ded7",
    y0 = "#efde9b",
    g0 = "#cae9b8",
    e0 = "#bbe9e3",
    b0 = "#c4e1ff",
    v0 = "#ddd7ff",
    p0 = "#f5d1f3",
    r0 = "#ffd0d5",
    o0 = "#fdd7ab",
    w1 = "#cac7c0",
    y1 = "#dcc778",
    g1 = "#add59d",
    e1 = "#99d5cf",
    b1 = "#a6cbf5",
    v1 = "#c6befb",
    p1 = "#e3b7e0",
    r1 = "#efb6bd",
    o1 = "#edbd8b",
    w2 = "#b3b1aa",
    y2 = "#c9b054",
    g2 = "#90c183",
    e2 = "#75c1bc",
    b2 = "#88b6e5",
    v2 = "#b0a7ec",
    p2 = "#d19dcd",
    r2 = "#df9ca5",
    o2 = "#dca46c",
    w3 = "#9e9b94",
    y3 = "#b69927",
    g3 = "#73ad69",
    e3 = "#4eada9",
    b3 = "#6aa0d6",
    v3 = "#9a8fdc",
    p3 = "#bf84ba",
    r3 = "#ce828e",
    o3 = "#cb8c4b",
    w4 = "#88867f",
    y4 = "#a38300",
    g4 = "#55994f",
    e4 = "#129997",
    b4 = "#4a8bc7",
    v4 = "#8578cd",
    p4 = "#ad6ba7",
    r4 = "#bd6978",
    o4 = "#ba7325",
    w5 = "#74716b",
    y5 = "#916c00",
    g5 = "#358634",
    e5 = "#008685",
    b5 = "#2676b7",
    v5 = "#7160bd",
    p5 = "#9b5295",
    r5 = "#ac4f62",
    o5 = "#a95a00",
}

local bg = {
    w0 = "#1e212b",
    y0 = "#2d2000",
    g0 = "#002a20",
    b0 = "#00224a",
    p0 = "#251549",
    r0 = "#37141e",
    w1 = "#272a35",
    y1 = "#342909",
    g1 = "#04332b",
    b1 = "#002c51",
    p1 = "#2c2150",
    r1 = "#3f2029",
    w2 = "#30343f",
    y2 = "#3c331b",
    g2 = "#173b36",
    b2 = "#103658",
    p2 = "#352c56",
    r2 = "#462b34",
    w3 = "#3a3d49",
    y3 = "#443d2c",
    g3 = "#274441",
    b3 = "#21405e",
    p3 = "#3d375d",
    r3 = "#4d363f",
    w4 = "#434753",
    y4 = "#4c473c",
    g4 = "#354d4d",
    b4 = "#314a65",
    p4 = "#464364",
    r4 = "#54414b",
}

M.fg = fg
M.bg = bg

M.scheme = {
    -- The default text color
    foreground = fg.w0,
    -- The default background color
    background = bg.w0,

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = fg.w2,
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = bg.w0,
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = fg.w1,

    -- the foreground color of selected text
    selection_fg = fg.p0,
    -- the background color of selected text
    selection_bg = bg.p4,

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#222222",

    -- The color of the split lines between panes
    split = fg.f2,

    ansi = {
        bg.w1,
        fg.r3,
        fg.g2,
        fg.y2,
        fg.b2,
        fg.p3,
        fg.e2,
        fg.w3,
    },
    brights = {
        bg.w4,
        fg.r3,
        fg.g1,
        fg.y1,
        fg.b1,
        fg.p1,
        fg.e1,
        fg.w1,
    },

    -- Arbitrary colors of the palette in the range from 16 to 255
    -- indexed = { [136] = "#af8700" },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = fg.w3,

    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = "#000000" },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = "Black" },
    copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
    copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

    quick_select_label_bg = { Color = "peru" },
    quick_select_label_fg = { Color = "#ffffff" },
    quick_select_match_bg = { AnsiColor = "Navy" },
    quick_select_match_fg = { Color = "#ffffff" },
}

M.config_colors = {
    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        -- background = "#0b0022",

        -- The active tab is the one that has focus in the window
        active_tab = {
            -- The color of the background area for the tab
            bg_color = bg.g4,
            -- The color of the text for the tab
            fg_color = fg.g0,

            -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
            -- label shown for this tab.
            -- The default is "Normal"
            intensity = "Normal",

            -- Specify whether you want "None", "Single" or "Double" underline for
            -- label shown for this tab.
            -- The default is "None"
            underline = "None",

            -- Specify whether you want the text to be italic (true) or not (false)
            -- for this tab.  The default is false.
            italic = false,

            -- Specify whether you want the text to be rendered with strikethrough (true)
            -- or not for this tab.  The default is false.
            strikethrough = false,
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = bg.w4,
            fg_color = fg.w2,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
            bg_color = bg.w2,
            fg_color = fg.w2,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = bg.w4,
            fg_color = fg.w2,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
            bg_color = bg.w2,
            fg_color = fg.w2,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab_hover`.
        },
    },
}

M.opacity = {
    fg = 1.00,
    bg = 0.90,
}

M.tab = {
    titlebar_bg = {
        active = bg.b2,
        inactive = bg.w2,
        inactive_edge = bg.r2,
    },
}

return M

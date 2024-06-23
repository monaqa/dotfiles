-- vim:fdm=marker:fmr=§§,■■

-- §§1 設定
-- if vim.g.colors_name then
--     vim.cmd("hi clear")
-- end
vim.g.colors_name = "colorimetry"
vim.opt.termguicolors = true
vim.opt.background = "dark"

---@param name string
local function sethl(name)
    ---@param val HlSpec
    return function(val)
        vim.api.nvim_set_hl(0, name, val)
    end
end

-- §§1 基本色
local fg = {
    w0 = "#dedede",
    w1 = "#d1d1d1",
    w2 = "#c4c4c4",
    w3 = "#b7b7b7",
    w4 = "#ababab",
    w5 = "#9e9e9e",
    r0 = "#ffcbdc",
    r1 = "#ffbacf",
    r2 = "#fba8c1",
    r3 = "#f597b4",
    r4 = "#ee85a7",
    r5 = "#e7729b",
    o0 = "#ffd0b8",
    o1 = "#ffc0a2",
    o2 = "#fcaf8d",
    o3 = "#f69e77",
    o4 = "#f08e60",
    o5 = "#e97c48",
    y0 = "#f0dda9",
    y1 = "#e7cf8f",
    y2 = "#dec274",
    y3 = "#d5b457",
    y4 = "#cca634",
    y5 = "#c39900",
    g0 = "#cae9bb",
    g1 = "#b9dea5",
    g2 = "#a8d390",
    g3 = "#96c87a",
    g4 = "#85bd64",
    g5 = "#74b24c",
    e0 = "#abeee0",
    e1 = "#8fe4d3",
    e2 = "#71dac7",
    e3 = "#4dd0ba",
    e4 = "#02c6ae",
    e5 = "#00bca2",
    b0 = "#ace9ff",
    b1 = "#91ddfc",
    b2 = "#75d2f6",
    b3 = "#54c7f0",
    b4 = "#22bcea",
    b5 = "#00b0e4",
    v0 = "#ccddff",
    v1 = "#bbcfff",
    v2 = "#aac1ff",
    v3 = "#9ab3ff",
    v4 = "#8aa5ff",
    v5 = "#7a97fb",
    p0 = "#f0d1ff",
    p1 = "#e7c0f8",
    p2 = "#ddb0f2",
    p3 = "#d4a0eb",
    p4 = "#cb90e5",
    p5 = "#c17fde",
}

local bg = {
    w0 = "#161616",
    w1 = "#222222",
    w2 = "#2e2e2e",
    w3 = "#3a3a3a",
    w4 = "#484848",
    r0 = "#4a0000",
    r1 = "#560000",
    r2 = "#600000",
    r3 = "#691d00",
    r4 = "#723311",
    g0 = "#002100",
    g1 = "#002e00",
    g2 = "#003a00",
    g3 = "#1a4700",
    g4 = "#2e5314",
    b0 = "#001651",
    b1 = "#002759",
    b2 = "#003661",
    b3 = "#004469",
    b4 = "#005170",
    v0 = "#0e0065",
    v1 = "#0e036c",
    v2 = "#162072",
    v3 = "#233278",
    v4 = "#33437d",
    p0 = "#31004b",
    p1 = "#3c0054",
    p2 = "#47065c",
    p3 = "#512164",
    p4 = "#5c356c",
}

vim.g.terminal_color_0 = bg.w1
vim.g.terminal_color_1 = fg.r4
vim.g.terminal_color_2 = fg.g4
vim.g.terminal_color_3 = fg.y4
vim.g.terminal_color_4 = fg.b3
vim.g.terminal_color_5 = fg.p4
vim.g.terminal_color_6 = fg.e3
vim.g.terminal_color_7 = fg.w4
vim.g.terminal_color_8 = bg.w4
vim.g.terminal_color_9 = fg.r4
vim.g.terminal_color_10 = fg.g1
vim.g.terminal_color_11 = fg.y1
vim.g.terminal_color_12 = fg.b1
vim.g.terminal_color_13 = fg.p1
vim.g.terminal_color_14 = fg.e1
vim.g.terminal_color_15 = fg.w1

-- §§1 defaults
sethl("Normal") { fg = fg.w0, bg = bg.w1 }

sethl("ColorColumn") { bg = bg.w2 }
sethl("Conceal") { fg = fg.w5 }
sethl("CurSearch") { bg = bg.b1 }
sethl("Cursor") { reverse = true }
sethl("CursorColumn") { bg = bg.w3 }
sethl("CursorLine") { link = "CursorColumn" }
sethl("Directory") { fg = fg.g2 }
sethl("DiffAdd") { bg = bg.g0 }
sethl("DiffChange") { bg = bg.b0 }
sethl("DiffDelete") { bg = bg.r0 }
sethl("DiffText") { bg = bg.b2 }
sethl("EndOfBuffer") { bg = bg.w2 }
sethl("TermCursor") { reverse = true }
sethl("ErrorMsg") { fg = fg.r4 }
sethl("WinSeparator") { fg = fg.w4 }
sethl("Folded") { bg = bg.p0 }
sethl("FoldColumn") { bg = bg.w1, fg = fg.w4 }
sethl("SignColumn") { bg = bg.w1, fg = fg.w4 }
sethl("IncSearch") { bg = bg.b2 }
sethl("Substitute") { bg = bg.b2 }

sethl("LineNr") { bg = bg.w2 }
sethl("CursorLineNr") { bg = bg.w4 }
sethl("MatchParen") { bg = bg.p4, bold = true }
sethl("ModeMsg") { bold = true }
sethl("MoreMsg") { fg = fg.b2 }
sethl("NonText") { fg = fg.w5, bg = bg.w4 }

sethl("NormalFloat") { fg = fg.w1, bg = bg.w3 }
sethl("FloatBorder") { link = "WinSeparator" }
sethl("FloatTitle") { bold = true }
sethl("FloatFooter") { italic = true }
sethl("PmenuSel") { bg = bg.w4 }
sethl("Question") { fg = fg.o2 }
sethl("QuickfixLine") { fg = fg.e3 }
sethl("Search") { bg = bg.b4 }
sethl("SpecialKey") { fg = fg.w5, bg = bg.w4 }
sethl("StatusLine") { reverse = true }
sethl("Visual") { bg = bg.p2 }
sethl("WarningMsg") { fg = fg.y1 }
sethl("Whitespace") { fg = fg.e5 }

-- §§1 monaqa-specific
sethl("VisualBlue") { bg = bg.p4 }

-- §§1 nvim-treesitter

sethl("@attribute") {}
sethl("@boolean") { fg = fg.p4 }
sethl("@character") {}
sethl("@character.special") {}
sethl("@comment") { fg = fg.w5 }
sethl("@comment.doccomment") { fg = fg.w3, bold = true }
sethl("@conditional") {}
sethl("@constant") { fg = fg.p2 }
-- sethl("@constant.numeric") { fg = fg.purple4 }
sethl("@constant.builtin") { fg = fg.p4 }
sethl("@constant.macro") {}
sethl("@constructor") {}
sethl("@debug") {}
sethl("@define") {}
sethl("@exception") {}
sethl("@field") {}
sethl("@float") {}
sethl("@function") { fg = fg.e2 }
sethl("@function.method") { fg = fg.e2 }
sethl("@function.builtin") { fg = fg.e4 }
sethl("@function.call") { fg = fg.e2 }
sethl("@function.macro") { fg = fg.e3 }
sethl("@include") {}
sethl("@keyword") { fg = fg.y2 }
sethl("@label") {}
sethl("@method") {}
sethl("@method.call") {}
sethl("@namespace") {}
sethl("@none") { bg = "NONE", fg = "NONE" }
sethl("@number") {}
sethl("@operator") { fg = fg.v3 }
sethl("@parameter") {}
sethl("@preproc") {}
sethl("@property") {}
sethl("@punctuation") { fg = fg.o0 }
sethl("@punctuation.delimiter") { fg = fg.o5 }
sethl("@repeat") {}
sethl("@storageclass") {}
sethl("@string") { fg = fg.g3 }
-- sethl("@string.escape") { fg = fg.g3 }
-- sethl("@string.regex") { fg = fg.g3 }
-- sethl("@string.special") { fg = fg.g4 }
sethl("@symbol") {}
sethl("@tag") {}
sethl("@tag.attribute") {}
sethl("@tag.delimiter") {}
sethl("@text") {}
sethl("@text.danger") {}
sethl("@text.diff.add") {}
sethl("@text.diff.addsign") {}
sethl("@text.diff.change") {}
sethl("@text.diff.delete") {}
sethl("@text.diff.delsign") {}
sethl("@text.diff.indicator") { bg = "#555555" }
sethl("@text.emphasis") { italic = true }
sethl("@text.environment") {}
sethl("@text.environment.name") {}
sethl("@text.literal") { fg = fg.g2 }
sethl("@text.math") {}
sethl("@text.note") {}
sethl("@text.quote") {}
sethl("@text.reference") {}
sethl("@text.strike") { strikethrough = true }
sethl("@text.strong") { bold = true }
sethl("@text.title") { fg = fg.y3, bold = true }
sethl("@text.title.weak") { fg = fg.y0 }
sethl("@text.todo") {}
sethl("@text.underline") { underline = true }
sethl("@text.uri") {}
sethl("@text.warning") {}
sethl("@type") {}
sethl("@type.builtin") {}
sethl("@type.definition") {}
sethl("@type.qualifier") {}
-- sethl("@variable") {}
sethl("@variable.parameter") { fg = fg.b0 }
-- sethl("@variable.builtin") {}
sethl("@variable.member") { fg = fg.b0 }

sethl("@field") { fg = fg.b0 }

-- §§1 plugin-specific

-- §§1 types
---@class HlSpec
---@field fg? string color name or "#RRGGBB", see note.
---@field bg? string color name or "#RRGGBB", see note.
---@field sp? string color name or "#RRGGBB"
---@field blend? integer between 0 and 100
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string name of another highlight group to link to, see |:hi-link|.
---@field default? boolean Don't override existing definition |:hi-default|
---@field ctermfg? string Sets foreground of cterm color |ctermfg|
---@field ctermbg? string Sets background of cterm color |ctermbg|
---@field cterm? string cterm attribute map, like |highlight-args|. If not set, cterm attributes will match those from the attribute map documented above.
---@field force? boolean if true force update the highlight group when it exists.

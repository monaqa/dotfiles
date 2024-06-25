-- vim:fdm=marker:fmr=§§,■■

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
sethl("Normal") { fg = fg.w1, bg = bg.w1 }

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
sethl("Folded") { fg = fg.v1 }
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
sethl("SpellBad") { underdotted = true, fg = fg.r0 }
sethl("SpellCap") { underdotted = true, fg = fg.w0 }
sethl("SpellLocal") { underdotted = true, fg = fg.w0 }
sethl("SpellRare") { underdotted = true, fg = fg.w0 }
sethl("StatusLine") { reverse = true }
sethl("Visual") { bg = bg.p4 }
sethl("WarningMsg") { fg = fg.y1 }
sethl("Whitespace") { fg = fg.v5 }

-- §§1 monaqa-specific
sethl("VisualBlue") { bg = bg.p2 }

-- §§1 nvim-treesitter

sethl("@attribute") {}
sethl("@boolean") { fg = fg.p4 }
sethl("@character") {}
sethl("@character.special") {}
sethl("@comment") { fg = fg.w5 }
sethl("@comment.documentation") { fg = fg.w3, bold = true }
sethl("@conditional") {}
sethl("@constant") { fg = fg.p2 }
sethl("@constant.builtin") { fg = fg.p4 }
sethl("@constant.macro") {}
sethl("@constructor") {}
sethl("@debug") {}
sethl("@define") {}
sethl("@exception") {}
sethl("@float") {}
sethl("@function") { fg = fg.e2 }
sethl("@function.method") { fg = fg.e1 }
sethl("@function.builtin") { fg = fg.e3 }
sethl("@function.call") { fg = fg.e2 }
sethl("@function.macro") { fg = fg.e3 }
sethl("@include") {}
sethl("@keyword") { fg = fg.y2 }
sethl("@label") {}
sethl("@markup.raw") { fg = fg.o3 }
sethl("@markup.heading") { fg = fg.y3, bold = true }
sethl("@method") {}
sethl("@method.call") {}
sethl("@namespace") {}
sethl("@none") { bg = "NONE", fg = "NONE" }
sethl("@number") {}
sethl("@operator") { fg = fg.v2 }
sethl("@parameter") { fg = fg.b0 }
sethl("@preproc") {}
sethl("@property") { fg = fg.w0 }
sethl("@punctuation") { fg = fg.o0 }
sethl("@punctuation.delimiter") { fg = fg.o5 }
sethl("@punctuation.special") { fg = fg.o2 }
sethl("@repeat") {}
sethl("@storageclass") {}
sethl("@string") { fg = fg.g3 }
sethl("@string.documentation") { fg = fg.g1 }
sethl("@symbol") {}
sethl("@tag") {}
sethl("@tag.attribute") {}
sethl("@tag.delimiter") {}
sethl("@text") {}
sethl("@text.danger") {}
sethl("@text.diff.add") { link = "DiffAdd" }
sethl("@text.diff.addsign") { fg = fg.g1, bold = true }
sethl("@text.diff.change") { link = "DiffChange" }
sethl("@text.diff.delete") { link = "DiffDelete" }
sethl("@text.diff.delsign") { fg = fg.r1, bold = true }
sethl("@text.diff.indicator") { bg = bg.w4 }
sethl("@text.emphasis") { italic = true }
sethl("@text.environment") {}
sethl("@text.environment.name") {}
sethl("@text.literal") { fg = fg.g2 }
sethl("@text.math") {}
sethl("@text.note") {}
sethl("@text.quote") {}
sethl("@text.reference") { fg = fg.b0 }
sethl("@text.strike") { strikethrough = true }
sethl("@text.strong") { bold = true }
sethl("@text.title") { fg = fg.y2, bold = true }
sethl("@text.title.weak") { fg = fg.y0 }
sethl("@text.todo") {}
sethl("@text.underline") { underline = true }
sethl("@text.uri") { fg = fg.v5 }
sethl("@text.warning") {}
sethl("@type") { fg = fg.b2 }
sethl("@type.builtin") { fg = fg.b3 }
sethl("@type.definition") {}
sethl("@type.qualifier") {}
sethl("@variable.parameter") { fg = fg.b0 }
sethl("@variable.builtin") { fg = fg.v2 }
sethl("@variable.member") { fg = fg.b0 }

sethl("@field") { fg = fg.b0 }

-- §§1 plugin-specific
sethl("GitSignsStagedAddNr") { bg = bg.g4, fg = fg.g0 }
sethl("GitSignsStagedChangeNr") { bg = bg.b4, fg = fg.b0 }
sethl("GitSignsStagedDeleteNr") { bg = bg.r4, fg = fg.r0 }
sethl("GitSignsStagedChangeDeleteNr") { bg = bg.p4, fg = fg.p0 }
sethl("GitSignsAddNr") { bg = bg.g2, fg = fg.g5 }
sethl("GitSignsChangeNr") { bg = bg.b2, fg = fg.b5 }
sethl("GitSignsDeleteNr") { bg = bg.r2, fg = fg.r5 }
sethl("GitSignsChangeDeleteNr") { bg = bg.p2, fg = fg.p5 }

-- §§1 Vim-syntax aliases
sethl("Boolean") { link = "@boolean" }
sethl("Character") { link = "@character" }
sethl("Conditional") { link = "@conditional" }
sethl("Constant") { link = "@constant" }
sethl("Debug") { link = "@debug" }
sethl("Define") { link = "@define" }
sethl("Delimiter") { link = "@punctuation.delimiter" }
sethl("Exception") { link = "@exception" }
sethl("Float") { link = "@float" }
sethl("Function") { link = "@function" }
sethl("Identifier") { link = "@symbol" }
sethl("Include") { link = "@include" }
sethl("Keyword") { link = "@keyword" }
sethl("Label") { link = "@label" }
sethl("Macro") { link = "@function.macro" }
sethl("Number") { link = "@number" }
sethl("Operator") { link = "@operator" }
sethl("PreProc") { link = "@preproc" }
sethl("Quote") { link = "@text.quote" }
sethl("Repeat") { link = "@repeat" }
sethl("Special") { link = "@constant.builtin" }
sethl("SpecialChar") { link = "@character.special" }
sethl("SpecialComment") { link = "@text.note" }
sethl("StorageClass") { link = "@storageclass" }
sethl("String") { link = "@string" }
sethl("Tag") { link = "@tag" }
sethl("Title") { link = "@text.title" }
sethl("Todo") { link = "@text.todo" }
sethl("Type") { link = "@type" }
sethl("Typedef") { link = "@type.definition" }
sethl("Underlined") { link = "@text.uri" }

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
    w0 = "#e3decf",
    y0 = "#e8e294",
    g0 = "#cde9b0",
    e0 = "#bee9dc",
    b0 = "#c7e1fd",
    v0 = "#dfd7ff",
    p0 = "#f7d1ec",
    r0 = "#ffd1c3",
    o0 = "#fdd89d",
    w1 = "#ccc7b9",
    y1 = "#d3cc67",
    g1 = "#add691",
    e1 = "#97d6ca",
    b1 = "#a5ccf3",
    v1 = "#c8befb",
    p1 = "#e7b5dd",
    r1 = "#f6b5a8",
    o1 = "#efbe74",
    w2 = "#b6b1a3",
    y2 = "#beb630",
    g2 = "#8dc372",
    e2 = "#6cc3b8",
    b2 = "#83b6e9",
    v2 = "#b1a5f1",
    p2 = "#d799cd",
    r2 = "#e9998d",
    o2 = "#e0a446",
    w3 = "#a09b8e",
    y3 = "#aba000",
    g3 = "#6db052",
    e3 = "#37b0a7",
    b3 = "#60a0df",
    v3 = "#9c8be7",
    p3 = "#c77ebd",
    r3 = "#db7d73",
    o3 = "#d28b00",
    w4 = "#8b8679",
    y4 = "#978a00",
    g4 = "#4a9d2d",
    e4 = "#009d96",
    b4 = "#398bd4",
    v4 = "#8772dd",
    p4 = "#b662ae",
    r4 = "#cc6159",
    o4 = "#c27000",
    w5 = "#767165",
    y5 = "#857400",
    g5 = "#1d8900",
    e5 = "#008a85",
    b5 = "#0074c8",
    v5 = "#7457d2",
    p5 = "#a5459e",
    r5 = "#bc4240",
    o5 = "#b25500",
}

local bg = {
    w0 = "#1e212b",
    y0 = "#341c00",
    g0 = "#00311a",
    b0 = "#00225a",
    p0 = "#2f0056",
    r0 = "#490016",
    w1 = "#2a2d38",
    y1 = "#3e2a00",
    g1 = "#003c29",
    b1 = "#003163",
    p1 = "#391760",
    r1 = "#540f25",
    w2 = "#363a45",
    y2 = "#493802",
    g2 = "#004838",
    b2 = "#003f6c",
    p2 = "#442a69",
    r2 = "#5e2434",
    w3 = "#434753",
    y3 = "#534623",
    g3 = "#075447",
    b3 = "#044c74",
    p3 = "#4f3b72",
    r3 = "#673644",
    w4 = "#515561",
    y4 = "#5e553c",
    g4 = "#2d6057",
    b4 = "#2a5a7d",
    p4 = "#5a4c7b",
    r4 = "#6f4855",
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
sethl("Normal") { fg = fg.w1, bg = bg.w0 }

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
sethl("CursorLineNr") { bg = bg.w2 }
sethl("MatchParen") { bg = bg.p4, bold = true }
sethl("ModeMsg") { bold = true }
sethl("MoreMsg") { fg = fg.b2 }
sethl("NonText") { fg = fg.w4, bg = bg.w2 }

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

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
local fg = require("monaqa.colorimetry").fg
local bg = require("monaqa.colorimetry").bg

vim.g.terminal_color_0 = bg.w1
vim.g.terminal_color_1 = fg.r3
vim.g.terminal_color_2 = fg.g2
vim.g.terminal_color_3 = fg.y2
vim.g.terminal_color_4 = fg.b2
vim.g.terminal_color_5 = fg.p3
vim.g.terminal_color_6 = fg.e2
vim.g.terminal_color_7 = fg.w3
vim.g.terminal_color_8 = bg.w4
vim.g.terminal_color_9 = fg.r3
vim.g.terminal_color_10 = fg.g1
vim.g.terminal_color_11 = fg.y1
vim.g.terminal_color_12 = fg.b1
vim.g.terminal_color_13 = fg.p1
vim.g.terminal_color_14 = fg.e1
vim.g.terminal_color_15 = fg.w1

-- §§1 defaults
sethl("Normal") { fg = fg.w0 }

sethl("ColorColumn") { bg = bg.w2 }
sethl("Conceal") { fg = fg.w3 }
sethl("Cursor") { reverse = true }
sethl("CursorColumn") { bg = bg.w3 }
sethl("CursorLine") { link = "CursorColumn" }
sethl("Directory") { fg = fg.g2 }
sethl("DiffAdd") { bg = bg.g1 }
sethl("DiffChange") { bg = bg.b1 }
sethl("DiffDelete") { bg = bg.r1 }
sethl("DiffText") { bg = bg.b2 }
sethl("EndOfBuffer") {}
sethl("TermCursor") { reverse = true }
sethl("ErrorMsg") { fg = fg.r4 }
sethl("WinSeparator") { fg = fg.w2 }
sethl("Folded") { fg = fg.v1 }
sethl("FoldColumn") { bg = bg.w1, fg = fg.w4 }
sethl("SignColumn") { bg = bg.w1, fg = fg.w4 }
sethl("Substitute") { bg = bg.b2 }

sethl("LineNr") { bg = bg.w1 }
sethl("CursorLineNr") { bg = bg.w1, bold = true }
sethl("MatchParen") { bg = bg.p4, bold = true }
sethl("ModeMsg") { bold = true }
sethl("MoreMsg") { fg = fg.b2 }
sethl("NonText") { fg = fg.w4, bg = bg.w2 }
sethl("SpecialKey") { fg = fg.w4, bg = bg.w2 }

sethl("NormalFloat") { fg = fg.w0, bg = bg.b3 }
sethl("FloatBorder") { link = "WinSeparator" }
sethl("FloatTitle") { bold = true }
sethl("FloatFooter") { italic = true }
sethl("PmenuSel") { bg = bg.g4 }
sethl("Question") { fg = fg.o2 }
sethl("QuickfixLine") { fg = fg.e3 }

sethl("Search") { bg = bg.b4 }
sethl("CurSearch") { bg = bg.b4, bold = true }
sethl("IncSearch") { bg = bg.b3 }

sethl("SpellBad") { undercurl = true, sp = fg.r3 }
sethl("SpellCap") { undercurl = true, sp = fg.b3 }
sethl("SpellLocal") { undercurl = true, sp = fg.g3 }
sethl("SpellRare") { undercurl = true, sp = fg.y3 }
sethl("StatusLine") { reverse = true }
sethl("Visual") { bg = bg.p4 }
sethl("WarningMsg") { fg = fg.y1 }
sethl("Whitespace") { fg = fg.v5 }

-- §§1 monaqa-specific
sethl("VisualBlue") { bg = bg.p2 }
sethl("LilypondAccidental") { fg = fg.r0 }

-- §§1 nvim-treesitter

sethl("@attribute") { fg = fg.o0 }
sethl("@attribute.builtin") { fg = fg.o2 }
sethl("@boolean") { fg = fg.p2 }
sethl("@character") { fg = fg.y2 }
sethl("@character.special") { fg = fg.y3 }
sethl("@comment") { fg = fg.w4 }
sethl("@comment.documentation") { fg = fg.w2 }
sethl("@conditional") {}
sethl("@constant") { fg = fg.p1 }
sethl("@constant.builtin") { fg = fg.p3 }
sethl("@constant.macro") {}
sethl("@constructor") {}
sethl("@debug") {}
sethl("@define") {}
sethl("@exception") {}
sethl("@float") {}
sethl("@function") { fg = fg.e2 }
sethl("@function.method") { fg = fg.e1 }
sethl("@function.builtin") { fg = fg.e3 }
sethl("@function.call") { fg = fg.e1 }
sethl("@function.macro") { fg = fg.e2 }
sethl("@include") {}
sethl("@keyword") { fg = fg.y1 }
sethl("@label") { fg = fg.v2 }
sethl("@markup.raw") { fg = fg.g1 }
sethl("@markup.heading") { fg = fg.y1, bold = true }
sethl("@markup.heading.weak") { fg = fg.y2 }
sethl("@method") {}
sethl("@method.call") {}
sethl("@module") { fg = fg.o1 }
sethl("@namespace") {}
sethl("@none") { bg = "NONE", fg = "NONE" }
sethl("@number") { fg = fg.p2 }
sethl("@number.float") { fg = fg.p2 }
sethl("@operator") { fg = fg.v1 }
sethl("@parameter") { fg = fg.b0 }
sethl("@preproc") {}
sethl("@property") { fg = fg.w1 }
sethl("@punctuation") { fg = fg.o3 }
sethl("@punctuation.delimiter") { fg = fg.o4 }
sethl("@punctuation.bracket") { fg = fg.o3 }
sethl("@punctuation.special") { fg = fg.o3 }
sethl("@repeat") {}
sethl("@storageclass") {}
sethl("@string") { fg = fg.g2 }
sethl("@string.field") { fg = fg.g1 }
sethl("@string.special") { fg = fg.g3 }
sethl("@string.regexp") { fg = fg.g3 }
sethl("@string.escape") { fg = fg.e4 }
sethl("@string.documentation") { fg = fg.g0 }
sethl("@symbol") {}
sethl("@tag") { fg = fg.o0 }
sethl("@tag.attribute") { fg = fg.o0 }
sethl("@tag.delimiter") { fg = fg.o4 }
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
sethl("@text.literal") { fg = fg.g0 }
sethl("@text.math") {}
sethl("@text.note") {}
sethl("@text.quote") { fg = fg.w2 }
sethl("@text.reference") { fg = fg.b0 }
sethl("@text.strike") { strikethrough = true }
sethl("@text.strong") { bold = true }
sethl("@text.title") { fg = fg.y1, bold = true }
sethl("@text.title.weak") { fg = fg.y0 }
sethl("@text.todo") {}
sethl("@text.underline") { underline = true }
sethl("@text.uri") { fg = fg.v3 }
sethl("@text.warning") {}
sethl("@type") { fg = fg.b2 }
sethl("@type.builtin") { fg = fg.b3 }
sethl("@type.definition") {}
sethl("@type.qualifier") {}
sethl("@variable") {}
sethl("@variable.parameter") { fg = fg.b0 }
sethl("@variable.builtin") { fg = fg.v2 }
sethl("@variable.member") {}

sethl("@field") { fg = fg.b0 }

-- §§1 plugin-specific
sethl("GitSignsStagedAddNr") { bg = bg.g3, fg = fg.g0 }
sethl("GitSignsStagedChangeNr") { bg = bg.b3, fg = fg.b0 }
sethl("GitSignsStagedDeleteNr") { bg = bg.r3, fg = fg.r0 }
sethl("GitSignsStagedChangeDeleteNr") { bg = bg.p3, fg = fg.p0 }
sethl("GitSignsAddNr") { bg = bg.g1, fg = fg.g1 }
sethl("GitSignsChangeNr") { bg = bg.b1, fg = fg.b1 }
sethl("GitSignsDeleteNr") { bg = bg.r1, fg = fg.r1 }
sethl("GitSignsChangeDeleteNr") { bg = bg.p1, fg = fg.p1 }

sethl("GinaChangesAdded") { fg = fg.g1 }
sethl("GinaChangesRemoved") { fg = fg.r1 }
sethl("GinaChangesPath") { fg = fg.w1 }

sethl("NotifyBackground") { bg = bg.w2 }

sethl("CocFloatActive") { bg = bg.w2 }

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
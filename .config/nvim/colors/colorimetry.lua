if vim.g.colors_name then
    vim.cmd("hi clear")
end
vim.g.colors_name = "colorimetry"
vim.opt.termguicolors = true

---@param name string
local function sethl(name)
    ---@param val HlSpec
    return function(val)
        vim.api.nvim_set_hl(0, name, val)
    end
end

local fg = {
    white0 = "#dedede",
    white1 = "#d1d1d1",
    white2 = "#c4c4c4",
    white3 = "#b7b7b7",
    white4 = "#ababab",
    white5 = "#9e9e9e",
    red0 = "#ffcbdc",
    red1 = "#ffbacf",
    red2 = "#fba8c1",
    red3 = "#f597b4",
    red4 = "#ee85a7",
    red5 = "#e7729b",
    orange0 = "#ffd0b8",
    orange1 = "#ffc0a2",
    orange2 = "#fcaf8d",
    orange3 = "#f69e77",
    orange4 = "#f08e60",
    orange5 = "#e97c48",
    yellow0 = "#f0dda9",
    yellow1 = "#e7cf8f",
    yellow2 = "#dec274",
    yellow3 = "#d5b457",
    yellow4 = "#cca634",
    yellow5 = "#c39900",
    green0 = "#cae9bb",
    green1 = "#b9dea5",
    green2 = "#a8d390",
    green3 = "#96c87a",
    green4 = "#85bd64",
    green5 = "#74b24c",
    emerald0 = "#abeee0",
    emerald1 = "#8fe4d3",
    emerald2 = "#71dac7",
    emerald3 = "#4dd0ba",
    emerald4 = "#02c6ae",
    emerald5 = "#00bca2",
    blue0 = "#ace9ff",
    blue1 = "#91ddfc",
    blue2 = "#75d2f6",
    blue3 = "#54c7f0",
    blue4 = "#22bcea",
    blue5 = "#00b0e4",
    violet0 = "#ccddff",
    violet1 = "#bbcfff",
    violet2 = "#aac1ff",
    violet3 = "#9ab3ff",
    violet4 = "#8aa5ff",
    violet5 = "#7a97fb",
    purple0 = "#f0d1ff",
    purple1 = "#e7c0f8",
    purple2 = "#ddb0f2",
    purple3 = "#d4a0eb",
    purple4 = "#cb90e5",
    purple5 = "#c17fde",
}

local bg = {
    black0 = "#161616",
    black1 = "#222222",
    black2 = "#2e2e2e",
    black3 = "#3a3a3a",
    black4 = "#484848",
    red0 = "#4c0000",
    red1 = "#570000",
    red2 = "#620000",
    red3 = "#6b1900",
    red4 = "#74301e",
    green0 = "#021e00",
    green1 = "#0e2b00",
    green2 = "#1c3700",
    green3 = "#2b4400",
    green4 = "#3a5103",
    blue0 = "#001c48",
    blue1 = "#002c51",
    blue2 = "#003a59",
    blue3 = "#004762",
    blue4 = "#00536a",
    purple0 = "#2c0053",
    purple1 = "#35005b",
    purple2 = "#400b63",
    purple3 = "#4a246b",
    purple4 = "#553772",
}

sethl("Normal") { fg = fg.white1, bg = bg.black1 }

sethl("ColorColumn") { bg = bg.black2 }
sethl("Conceal") { fg = fg.white5 }
sethl("CurSearch") { bg = bg.blue1 }
sethl("Cursor") { reverse = true }
sethl("CursorColumn") { bg = bg.black3 }
sethl("CursorLine") { link = "CursorColumn" }
sethl("Directory") { fg = fg.green2 }
sethl("DiffAdd") { bg = bg.green0 }
sethl("DiffChange") { bg = bg.blue0 }
sethl("DiffDelete") { bg = bg.red0 }
sethl("DiffText") { bg = bg.blue2 }
sethl("EndOfBuffer") { bg = bg.black2 }
sethl("TermCursor") { reverse = true }
sethl("ErrorMsg") { fg = fg.red4 }
sethl("WinSeparator") { fg = fg.white4 }
sethl("Folded") { bg = bg.purple0 }
sethl("FoldColumn") { bg = bg.black1, fg = fg.white4 }
sethl("SignColumn") { bg = bg.black1, fg = fg.white4 }
sethl("IncSearch") { bg = bg.blue2 }
sethl("Substitute") { bg = bg.blue2 }

sethl("LineNr") { bg = bg.black2 }
sethl("CursorLineNr") { bg = bg.black4 }
sethl("MatchParen") { bg = bg.purple4, bold = true }
sethl("ModeMsg") { bold = true }
sethl("MoreMsg") { fg = fg.blue2 }
sethl("NonText") { fg = fg.white5, bg = bg.black4 }

sethl("NormalFloat") { fg = fg.white1, bg = bg.black3 }
sethl("FloatBorder") { link = "WinSeparator" }
sethl("FloatTitle") { bold = true }
sethl("FloatFooter") { italic = true }
sethl("PmenuSel") { bg = bg.black4 }
sethl("Question") { fg = fg.orange2 }
sethl("QuickfixLine") { fg = fg.emerald3 }
sethl("Search") { bg = bg.blue4 }
sethl("StatusLine") { reverse = true }
sethl("Visual") { bg = bg.purple2 }
sethl("WarningMsg") { fg = fg.yellow1 }
sethl("Whitespace") { fg = fg.emerald5 }

sethl("@function.call") { fg = fg.emerald1 }

sethl("VisualBlue") { bg = bg.purple4 }

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

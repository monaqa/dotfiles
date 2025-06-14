-- vim:fdm=marker:fmr=§§,■■

-- §§1 表示設定
vim.cmd([[
language messages en_US.UTF-8
]])

-- vim.opt.belloff = {}
vim.opt.visualbell = false
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.ambiwidth = "single"
vim.opt.wrap = true
vim.opt.colorcolumn = "80"
vim.opt.list = true
vim.opt.listchars = {
    tab = "▸▹┊",
    trail = "▫",
    extends = "❯",
    precedes = "❮",
}
vim.opt.fillchars = {
    eob = " ",
    -- stl = "─",
    -- stlnc = "─",
}
vim.opt.formatoptions:append("M")

vim.opt.scrolloff = 0
-- default は marker にしておく
vim.opt.foldmethod = "marker"
vim.opt.foldlevelstart = 99
-- あえて manual にしたときは、自動的に fold が保存されるようにしておく
-- vim.opt.viewoptions = {
--     "folds",
-- }

vim.opt.matchpairs:append {
    "（:）",
    "「:」",
    "『:』",
    "【:】",
}

vim.opt.guicursor = {
    "n-v-c-sm:block",
    "i-ci-ve:ver25",
    "r-cr-o:hor20",
    "t:ver25-blinkon1000-blinkoff500-TermCursor",
}

-- 下
vim.opt.showcmd = true
vim.opt.laststatus = 3
-- vim.opt.statusline = "─"

-- 左
vim.opt.number = true
vim.opt.foldcolumn = "0"
-- vim.opt.signcolumn = "yes:2"
vim.opt.signcolumn = "number"

-- misc
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.diffopt:append { "vertical", "algorithm:histogram" }

-- function _G.vimrc.fn.winbar()
--     local name = vim.fn.bufname()
--     local icon, color = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
--     if icon == nil then
--         icon = ""
--     end
--     return icon .. " " .. name
-- end
--
-- -- winbar
-- vim.opt.winbar = [[%{%v:lua.vimrc.fn.winbar()%}%#@winbar.reset#]]

-- §§1 編集関係
vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd.colorscheme("colorimetry")

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindent = true
vim.opt.smartindent = false
vim.opt.virtualedit = "block"
vim.opt.isfname:remove("=")

vim.opt.exrc = true
vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.autoread = true
vim.opt.confirm = true
vim.opt.modeline = true
vim.opt.modelines = 3

vim.opt.hidden = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.backspace = { "indent", "eol", "start", "nostop" }
vim.opt.history = 10000

vim.opt.mouse = "a"
-- 最後の4文字が "fish" だったら "sh" にする
if vim.opt.shell:get():sub(#vim.opt.shell - 3) == "fish" then
    vim.opt.shell = "sh"
end

if vim.fn.has("persistent_undo") then
    vim.opt.undofile = true
end

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.inccommand = "split"

vim.opt.sessionoptions = {
    "buffers",
    "folds",
    "tabpages",
    "winsize",
}

if vim.fn.executable("rg") then
    vim.opt.grepprg = "rg --vimgrep --hidden --no-heading --glob " .. "'!tags*'"
    vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- 正確にはオプションではないがまあオプションっぽく扱おうということで
vim.g.python3_host_prog = (vim.fn.getenv("HOME")) .. "/.local/share/nvim/venv/neovim/bin/python"

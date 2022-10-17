-- vim:fdm=marker:fmr=§§,■■

-- §§1 表示設定
vim.cmd [[
language messages en_US.UTF-8
]]

vim.opt.belloff = "all"
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

vim.opt.scrolloff = 0
vim.opt.foldlevelstart = 99

vim.opt.matchpairs:append {
    "（:）",
    "「:」",
    "『:』",
    "【:】",
}

-- 下
vim.opt.showcmd = true
vim.opt.laststatus = 3

-- 左
vim.opt.number = true
vim.opt.foldcolumn = "0"
vim.opt.signcolumn = "yes:2"

-- misc
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.diffopt:append { "vertical", "algorithm:histogram" }

-- §§1 表示設定
vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd [[
colorscheme gruvbit
]]

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindent = true
vim.opt.smartindent = false
vim.opt.virtualedit = "block"
vim.opt.isfname = vim.opt.isfname - "="

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.autoread = true
vim.opt.confirm = true
vim.opt.modeline = true
vim.opt.modelines = 3

vim.opt.hidden = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.history = 10000

vim.opt.mouse = "a"
-- 最後の4文字が "fish" だったら "sh" にする
if vim.opt.shell:get():sub(#vim.opt.shell - 3) == "fish" then
    vim.opt.shell.set "sh"
end

if vim.fn.has "persistent_undo" then
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

if vim.fn.executable "rg" then
    vim.opt.grepprg = "rg --vimgrep --hidden --glob " .. "'!tags*'"
    vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- 正確にはオプションではないがまあオプションっぽく扱おうということで
vim.g.python3_host_prog = (vim.fn.getenv "HOME") .. "/.local/share/nvim/venv/neovim/bin/python"

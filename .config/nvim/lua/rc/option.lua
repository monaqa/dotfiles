-- vim:fdm=marker:fmr=§§,■■


-- §§1 表示設定
vim.cmd [[
language messages en_US.UTF-8
]]

vim.o.belloff = "all"
vim.o.lazyredraw = true
vim.o.ttyfast = true
vim.o.ambiwidth = "single"
vim.o.wrap = true
vim.o.colorcolumn = 80
vim.o.list = true
vim.opt.listchars = {
    tab = "▸▹┊",
    trail = "▫",
    extends = "❯",
    precedes = "❮",
}

vim.o.scrolloff = 0
vim.o.foldlevelstart = 99

vim.opt.matchpairs = vim.opt.matchpairs + {
    "（:）",
    "「:」",
    "『:』",
    "【:】",
}

-- 下
vim.o.showcmd = true
vim.o.laststatus = 3

-- 左
vim.o.number = true
vim.o.foldcolumn = "0"
vim.o.signcolumn = "yes:2"

-- misc
vim.o.splitright = true
vim.o.splitbelow = true
vim.opt.diffopt = vim.opt.diffopt + { "vertical", algorithm = "histgram" }

-- §§1 表示設定
vim.o.termguicolors = true
vim.o.background = "dark"

vim.cmd[[
colorscheme gruvbit
]]

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.smartindent = false
vim.o.virtualedit = "block"
vim.opt.isfname = vim.opt.isfname - "="

vim.o.backup = false
vim.o.swapfile = false

vim.api.nvim_create_autocmd("StdinReadPost", {
    group = "vimrc",
    command = "set nomodified",
})

vim.o.autoread = true
vim.o.confirm = true
vim.o.modeline = true
vim.o.modelines = 3

vim.o.hidden = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.backspace = { "indent", "eol", "start" }
vim.o.history = 10000

vim.o.mouse = "a"
-- 最後の4文字が "fish" だったら "sh" にする
if vim.o.shell:sub(#vim.o.shell - 3) == "fish" then
    vim.o.shell = "sh"
end

if vim.fn.has("persistent_undo") then
    vim.o.undofile = true
end

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.wrapscan = true
vim.o.hlsearch = true
vim.o.inccommand = "split"

vim.opt.sessionoptions = {
    "buffers",
    "folds",
    "tabpages",
    "winsize",
}

if vim.fn.executable("rg") then
    vim.o.grepprg = 'rg --vimgrep --hidden --glob ' .. "'!tags*'"
    vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

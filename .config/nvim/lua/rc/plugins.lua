local vec = require "rc.util.vec"

local disable_plugins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}

for _, name in ipairs(disable_plugins) do
    vim.g["loaded_" .. name] = 1
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local plugins = vec {
    dev = {
        -- directory where you store your local plugin projects
        path = "~/ghq/github.com/",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = { "monaqa" }, -- For example {"folke"}
        fallback = false, -- Fallback to git when local plugin doesn't exist
    },
}

-- local

require("lazy").setup(vec({
    require "rc.plugins.denops",
    require "rc.plugins.filer",
    require "rc.plugins.filetype",
    require "rc.plugins.git",
    require "rc.plugins.layout",
    require "rc.plugins.lsp",
    require "rc.plugins.paren",
    require "rc.plugins.telescope",
    require "rc.plugins.textedit",
    require "rc.plugins.treesitter",

    require "rc.plugins.misc",
    require "rc.plugins.monaqa",
}):concat():collect())

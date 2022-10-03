local util = require "rc.util"

vim.opt_local.shiftwidth = 4
vim.opt_local.formatoptions = vim.opt_local.formatoptions - "o"

if util.to_bool(vim.fn.getline "1" == "# %% [markdown]") then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "HydrogenFoldOnlyCode(v:lnum)"
    vim.opt_local.foldtext = "HydrogenCustomFoldText()"
end

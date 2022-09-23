vim.g.python3_host_prog = vim.fn.getenv("HOME") .. "/.local/share/nvim/venv/neovim/bin/python"

local disable_plugins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}

for _, name in ipairs(disable_plugins) do
    vim.g["loaded_" .. name] = 1
end

-- §§1 Plugin settings for gruvbit
vim.g.gruvbit_transp_bg = 1

-- §§1 Plugin settings for lambdalisue/fern.vim
vim.g["fern#disable_default_mappings"] = 1
vim.g["fern#default_hidden"] = 1

-- §§1 Plugin settings for lervag/vimtex
vim.g.tex_flavor = "latex"

-- §§1 Plugin settings for liuchengxu/vista.vim
vim.g.vista_default_executive = "coc"

vim.g.sonictemplate_vim_template_dir = {
    "$HOME/.config/nvim/scripts/template",
}

vim.g.python_highlight_all = 1

vim.g.vim_markdown_new_list_item_indent = 4

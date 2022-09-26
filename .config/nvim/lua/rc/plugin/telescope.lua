-- vim:fdm=marker:fmr=§§,■■
-- §§1 Plugin settings for telescope.nvim
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

require('telescope').load_extension('coc')

-- Global remapping
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--line-number',
      '--no-heading',
      '--color=never',
      '--hidden',
      '--with-filename',
      '--column',
      -- '--smart-case'
    },
    prompt_prefix = "𝜻",
    find_command = {
        "rg",
        '--ignore',
        '--hidden',
        '--files',
    },
    mappings = {
      n = {
        ["<Esc>"] = actions.close,
      },
    },
  }
}

vim.keymap.set("n", "to", function () builtin.git_files({prompt_prefix = "𝝋"}) end)
vim.keymap.set("n", "tO", function () builtin.find_files({prompt_prefix = "𝝋"}) end)
vim.keymap.set("n", "tb", function () builtin.buffers({prompt_prefix = "𝜷"}) end)
vim.keymap.set("n", "tg", function () builtin.live_grep({prompt_prefix = "𝜸"}) end)
vim.keymap.set("n", "tq", function () builtin.quickfix({prompt_prefix = "𝝄"}) end)

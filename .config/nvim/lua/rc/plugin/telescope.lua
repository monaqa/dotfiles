-- vim:fdm=marker:fmr=§§,■■
-- §§1 Plugin settings for telescope.nvim
local actions = require('telescope.actions')
require('telescope').load_extension('coc')
-- Global remapping
------------------------------
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

vim.cmd[[
nnoremap so <Cmd>Telescope git_files prompt_prefix=𝝋<CR>
nnoremap sg <Cmd>Telescope live_grep prompt_prefix=𝜸<CR>
nnoremap sb <Cmd>Telescope buffers prompt_prefix=𝜷<CR>
nnoremap sO <Cmd>Telescope find_files prompt_prefix=𝝋<CR>
]]

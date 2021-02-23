-- vim:fdm=marker:fmr=§§,■■
-- §§1 Plugin settings for lualine.nvim
local lualine = require('lualine')
lualine.theme = 'gruvbox'

lualine.sections.lualine_b = {
    function()
        return [[%f %m]]
    end
}

lualine.sections.lualine_y = { function()
    return "" .. vim.fn["gina#component#repo#branch"]()
end }
local function cocstatus()
    return vim.fn["coc#status"]()
end
local function location()
    local n = #tostring(vim.fn.line("$"))
    n = math.max(n, 3)
    return "%" .. n .. [[l/%-3L:%-2c]]
end
lualine.sections.lualine_c = { cocstatus }
lualine.sections.lualine_z = { location }

lualine.status()


-- §§1 Plugin settings for telescope.nvim
local actions = require('telescope.actions')
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

-- §§1 Plugin settings for nvim-treesitter.nvim
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this

        -- ["iF"] = {
        --   python = "(function_definition) @function",
        --   cpp = "(function_definition) @function",
        --   c = "(function_definition) @function",
        --   java = "(method_declaration) @function",
        -- },
      },
    },
  },
}

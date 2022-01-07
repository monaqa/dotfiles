-- vim:fdm=marker:fmr=§§,■■
-- §§1 Plugin settings for lualine.nvim
require('lualine').setup {
  sections = {
    lualine_b = {
      function ()
        return [[%f %m]]
      end
    },
    lualine_c = {
      function()
        return vim.fn["coc#status"]()
      end
    },
    lualine_y = {
      function()
        return "" .. vim.fn["gina#component#repo#branch"]()
      end
    },
    lualine_z = {
      function()
        local n = #tostring(vim.fn.line("$"))
        n = math.max(n, 3)
        return "%" .. n .. [[l/%-3L:%-2c]]
      end
    }
  },
  options = {
    theme = 'tomorrow',
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
}

-- §§1 Plugin settings for hlslens
-- require'hlslens'.setup{
--     nearest_only = true,
--     -- nearest_float_when = 'always',
-- }

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

-- §§1 Plugin settings for nvim-treesitter.nvim
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'rust', 'lua', 'typescript', 'query', 'toml', 'python'},
  highlight = {
      enable = true,
  },
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

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.todome = {
  install_info = {
    url = "~/ghq/github.com/monaqa/tree-sitter-todome", -- local path or git repo
    files = {"src/parser.c", "src/scanner.cc"}
  },
  filetype = "todome", -- if filetype does not agrees with parser name
}

-- §§1 Plugin settings for pretty-fold.nvim

require('pretty-fold').setup{
    fill_char = '┄',
    sections = {
        left = {
            'content',
        },
        right = {
            ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
            function(config) return config.fill_char:rep(3) end
        }
    },

    remove_fold_markers = true,

    -- Keep the indentation of the content of the fold string.
    keep_indentation = true,

    -- Possible values:
    -- "delete" : Delete all comment signs from the fold string.
    -- "spaces" : Replace all comment signs with equal number of spaces.
    -- false    : Do nothing with comment signs.
    comment_signs = 'spaces',

    -- List of patterns that will be removed from content foldtext section.
    stop_words = {
        '@brief%s*', -- (for cpp) Remove '@brief' and all spaces after.
    },

    add_close_pattern = true,
    matchup_patterns = {
        { '{', '}' },
        { '%(', ')' }, -- % to escape lua pattern char
        { '%[', ']' }, -- % to escape lua pattern char
        { 'if%s', 'end' },
        { 'do%s', 'end' },
        { 'for%s', 'end' },
    },
}
require('pretty-fold.preview').setup_keybinding()

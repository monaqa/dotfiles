-- vim:fdm=marker:fmr=§§,■■

require("rc.plugin.before")

require("jetpack").startup(
function(use)

    -- general plugins
    use{"Shougo/vimproc.vim"}
    use{"Vimjas/vim-python-pep8-indent"}
    use{"bps/vim-textobj-python"}
    use{"glidenote/memolist.vim"}
    use{"glts/vim-textobj-comment"}
    use{"habamax/vim-gruvbit"}
    use{"haya14busa/vim-asterisk"}
    use{"iamcco/markdown-preview.nvim", ["do"] = 'packloadall! | call mkdp#util#install()'}
    use{"itchyny/vim-qfedit"}
    use{"kana/vim-altr"}
    use{"kana/vim-operator-user"}
    use{"kana/vim-textobj-user"}
    use{"kkiyama117/zenn-vim"}
    use{"kyazdani42/nvim-web-devicons"}
    use{"lambdalisue/fern-hijack.vim"}
    use{"lambdalisue/fern-renderer-nerdfont.vim"}
    use{"lambdalisue/fern.vim"}
    use{"lambdalisue/gina.vim"}
    use{"lambdalisue/nerdfont.vim"}
    use{"lervag/vimtex"}
    use{"liuchengxu/vista.vim"}
    use{"machakann/vim-sandwich"}
    use{"machakann/vim-swap"}
    use{"machakann/vim-textobj-functioncall"}
    use{"mattn/vim-maketable"}
    use{"mbbill/undotree"}
    use{"mhinz/vim-signify"}
    use{"nvim-lualine/lualine.nvim"}
    use{"nvim-neorg/neorg"}
    use{"powerman/vim-plugin-AnsiEsc"}
    use{"rhysd/rust-doc.vim"}
    use{"romgrk/barbar.nvim"}
    use{"thinca/vim-qfreplace"}
    use{"thinca/vim-quickrun"}
    use{"thinca/vim-submode"}
    use{"tpope/vim-capslock"}
    use{"tyru/capture.vim"}
    use{"tyru/caw.vim"}
    use{"tyru/open-browser.vim"}
    use{"xolox/vim-misc"}
    use{"xolox/vim-session"}
    use{"yasukotelin/shirotelin", opt = true}

    -- paren
    use{"cohama/lexima.vim"}
    use{"machakann/vim-sandwich"}

    -- coc
    use{"neoclide/coc.nvim", branch = "release"}
    use{"rafcamlet/coc-nvim-lua"}

    -- telescope
    use{"nvim-telescope/telescope.nvim"}
    use{"nvim-lua/popup.nvim"}
    use{"nvim-lua/plenary.nvim"}
    use{"fannheyward/telescope-coc.nvim"}

    -- denops
    use{"Shougo/ddu.vim"}
    use{"Shougo/ddu-filter-matcher_substring"}
    use{"Shougo/ddu-kind-file"}
    use{"Shougo/ddu-source-file_rec"}
    use{"Shougo/ddu-ui-ff"}
    use{"kuuote/ddu-source-mr"}
    use{"lambdalisue/mr.vim"}
    use{"matsui54/ddu-source-file_external"}
    use{"shun/ddu-source-rg"}
    use{"vim-denops/denops.vim"}

    -- tree-sitter
    use{"nvim-treesitter/nvim-treesitter"}
    use{"nvim-treesitter/playground"}
    use{"sainnhe/gruvbox-material"}

    -- filetype
    use{"JuliaEditorSupport/julia-vim"}
    use{"aklt/plantuml-syntax"}
    use{"bfontaine/Brewfile.vim"}
    use{"cespare/vim-toml"}
    use{"chr4/nginx.vim"}
    use{"ekalinin/Dockerfile.vim"}
    use{"leafgarland/typescript-vim"}
    use{"ocaml/vim-ocaml"}
    use{"pangloss/vim-javascript"}
    use{"pest-parser/pest.vim"}
    use{"rust-lang/rust.vim"}
    use{"vim-python/python-syntax"}
    use{"vito-c/jq.vim"}
    use{"wlangstroth/vim-racket"}
    use{"qnighy/satysfi.vim"}

    -- monaqa
    use{"monaqa/colordinate.vim", opt = true}
    use{"monaqa/dial.nvim", opt = true}
    use{"monaqa/modesearch.vim"}
    use{"monaqa/peridot.vim"}
    use{"monaqa/pretty-fold.nvim", branch = "for_stable_neovim"}
    -- use{"monaqa/satysfi.vim"}
    use{"monaqa/smooth-scroll.vim"}
    use{"monaqa/vim-edgemotion"}
    use{"monaqa/vim-partedit", branch = "feat-prefix_pattern"}

end
)

require("rc.plugin.general")
require("rc.plugin.paren")
require("rc.plugin.coc")
require("rc.plugin.telescope")
require("rc.plugin.denops")
require("rc.plugin.treesitter")
require("rc.plugin.filetype")
require("rc.plugin.monaqa")


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
  ensure_installed = {
      'bash',
      'lua',
      'markdown',
      'python',
      'query',
      'rust',
      'toml',
      'typescript',
      -- 'satysfi',
      -- 'todome',
      -- 'mermaid',
  },
  highlight = {
      enable = true,
      -- disable = {"rust",},
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
parser_config.mermaid = {
  install_info = {
    url = "~/ghq/github.com/monaqa/tree-sitter-mermaid", -- local path or git repo
    files = {"src/parser.c"}
  },
  filetype = "mermaid", -- if filetype does not agrees with parser name
}
parser_config.satysfi = {
  install_info = {
    url = "~/ghq/github.com/monaqa/tree-sitter-satysfi", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"}
  },
  filetype = "satysfi", -- if filetype does not agrees with parser name
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
-- require('pretty-fold.preview').setup_keybinding()

-- §§1 Plugin settings for dial.nvim

-- local augend = require"dial.augend"
-- require"dial.config".augends:register_group{
--     default = {
-- 
--     }
-- }

require('neorg').setup {
    load = {
        ["core.defaults"] = {}
    }
}

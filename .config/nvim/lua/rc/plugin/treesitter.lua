-- vim:fdm=marker:fmr=§§,■■
-- §§1 Plugin settings for nvim-treesitter.nvim

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
    url = "https://github.com/monaqa/tree-sitter-satysfi", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"},
    branch = "master",
  },
  filetype = "satysfi", -- if filetype does not agrees with parser name
}

parser_config.satysfi_v0_1_0 = {
  install_info = {
    url = "~/ghq/github.com/monaqa/tree-sitter-satysfi", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"}
  },
  filetype = "satysfi_v0_1_0", -- if filetype does not agrees with parser name
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      'bash',
      'css',
      'html',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'rust',
      'svelte',
      'toml',
      'typescript',
      'yaml',

      -- custom grammar
      'mermaid',
      'satysfi',
      'satysfi_v0_1_0',
      'todome',
  },
  highlight = {
      enable = true,
      -- disable = {"rust",},
  },
  indent = {
      enable = true,
      disable = {
      'bash',
      'css',
      'html',
      'json',
      'lua',
      -- 'markdown',
      'python',
      'query',
      -- 'rust',
      -- 'svelte',
      'toml',
      'typescript',
      'yaml',

      -- custom grammar
      'mermaid',
      -- 'satysfi',
      -- 'satysfi_v0_1_0',
      'todome',
      },
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
  matchup = {
    enable = false,              -- mandatory, false will disable the whole extension
    -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold", "InsertLeave"},
  },
}

-- vim.pretty_print{sfile = vim.fn.expand("<sfile>:p", nil, nil)}

-- vim.cmd[[
-- nnoremap ts <Cmd> TSHighlightCapturesUnderCursor<CR>
-- 
-- let s:query_dir = expand("<sfile>:p:h:h:h") .. '/after/queries/'
-- 
-- function! TreeSitterOverrideQuery(filetype, query_type)
--   let query_file = s:query_dir .. a:filetype .. '/' .. a:query_type .. '.scm'
--   let query = join(readfile(query_file), "\n")
--   call luaeval('require("vim.treesitter.query").set_query(_A[1], _A[2], _A[3])', [a:filetype, a:query_type, query])
-- endfunction
-- 
-- call TreeSitterOverrideQuery('bash', 'highlights')
-- call TreeSitterOverrideQuery('markdown', 'highlights')
-- ]]

vim.keymap.set("n", "ts", "<Cmd>TSHighlightCapturesUnderCursor<CR>")

local query_dir = vim.fn.expand("~/.config/nvim/after/queries", nil, nil)

local function override_query(filetype, query_type)
    local query_file = ("%s/%s/%s.scm"):format(query_dir, filetype, query_type)
    local query = vim.fn.join(vim.fn.readfile(query_file), "\n")
    require("vim.treesitter.query").set_query(filetype, query_type, query)
end

override_query("bash", "highlights")
override_query("markdown", "highlights")
override_query("markdown_inline", "highlights")

vim.keymap.set("o", "q", ":<C-U>lua require('tsht').nodes()<CR>")
vim.keymap.set("x", "q", ":lua require('tsht').nodes()<CR>")

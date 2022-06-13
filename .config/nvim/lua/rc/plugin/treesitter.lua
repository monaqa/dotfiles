-- vim:fdm=marker:fmr=§§,■■
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

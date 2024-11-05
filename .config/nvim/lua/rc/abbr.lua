local cabbr = require("monaqa").cabbr

-- ミス防止
cabbr:add { prepose = "'<,'>", require_space = false, from = "w", to = "<C-u>w" }
cabbr:add { from = "w2", to = "w" }
cabbr:add { from = "w]", to = "w" }
cabbr:add { from = "w:", to = "w" }

-- 標準コマンドのエイリアス
cabbr:add { from = "open", to = "!open" }
cabbr:add { from = "s", to = "%s///g<Left><Left>", remove_trigger = true }
cabbr:add { from = "ssf", to = "syntax sync fromstart" }
cabbr:add { from = "gd", to = "g//d" }
cabbr:add { from = "vd", to = "v//d" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "s", to = "%s///g<Left><Left>", remove_trigger = true }
cabbr:add { prepose = "'<,'>", require_space = false, from = "gd", to = "g//d" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "vd", to = "v//d" }

-- coc.nvim 周り
cabbr:add { from = "c", to = "CocCommand" }
cabbr:add { prepose = "CocCommand", from = "s", to = "snippets.editSnippets" }
cabbr:add { from = "cc", to = "CocConfig" }
cabbr:add { from = "cl", to = "CocList" }
cabbr:add { prepose = "CocList", from = "e", to = "extensions" }
cabbr:add { from = "clc", to = "CocLocalConfig" }
cabbr:add { from = "cr", to = "CocRestart" }
cabbr:add { from = "fmt", to = [[call CocActionAsync("format")]] }
cabbr:add { from = "wd", to = "Telescope coc workspace_diagnostics" }

-- git 操作
cabbr:add { from = "gby", to = "GinaBrowseYank" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "gby", to = "GinaBrowseYank" }
cabbr:add { from = "gc", to = "Gina commit" }
cabbr:add { prepose = "Gina commit", from = "a", to = "--amend" }
cabbr:add { prepose = "Gina commit", from = "e", to = "--allow-empty" }
cabbr:add { from = "gl", to = "Gina log --all --graph" }
cabbr:add { from = "gpc", to = "GinaPrChanges" }
cabbr:add { from = "gs", to = "Gina status -s --opener=split" }
cabbr:add { from = "git", to = "Gina" }

-- telescope.nvim
cabbr:add { from = "t", to = "Telescope" }
cabbr:add { prepose = "Telescope", from = "c", to = "coc" }
cabbr:add { prepose = "Telescope coc", from = "c", to = "commands" }
cabbr:add { prepose = "Telescope coc", from = "d", to = "diagnostics" }
cabbr:add { prepose = "Telescope", from = "f", to = "find_files" }
cabbr:add { prepose = "Telescope", from = "g", to = "live_grep" }

-- tree-sitter 関連
cabbr:add { from = "it", to = "InspectTree" }

-- その他
cabbr:add { from = "l", to = "Lazy" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "m", to = "MakeTable" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "p", to = "Partedit" }
cabbr:add { prepose = "'<,'>", require_space = false, from = "pc", to = "ParteditCodeblock" }

-- monaqa-specific commands
cabbr:add { from = "ef", to = "EditFtplugin" }
cabbr:add { from = "ty", to = "Typscrap" }

cabbr:register_all()

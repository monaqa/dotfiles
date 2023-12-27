local util = require "rc.util"
local vec = require "rc.util.vec"

local plugins = vec {}

-- nvim_lsp

-- plugins:push { "https://github.com/neovim/nvim-lspconfig", opt = 1, config = config.nvim_lsp }
-- plugins:push { "https://github.com/williamboman/mason.nvim", opt = 1 }
-- plugins:push { "https://github.com/williamboman/mason-lspconfig.nvim", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/nvim-cmp", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/cmp-nvim-lsp", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/cmp-vsnip", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/cmp-buffer", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/cmp-path", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/cmp-cmdline", opt = 1 }
-- plugins:push { "https://github.com/hrsh7th/vim-vsnip", opt = 1 }
-- plugins:push { "https://github.com/folke/neodev.nvim", opt = 1 }

-- coc
plugins:push {
    "https://github.com/neoclide/coc.nvim",
    branch = "release",
    config = function()
        local function coc_service_names(arglead, cmdline, cursorpos)
            return vim.tbl_map(function(service)
                return service["id"]
            end, vim.fn.CocAction "services")
        end

        util.create_cmd("CocToggleService", function(meta)
            vim.fn.CocAction("toggleService", meta.args)
        end, { nargs = 1, complete = coc_service_names })

        vim.opt.tagfunc = "CocTagFunc"

        vim.g["coc_global_extensions"] = {
            "coc-deno",
            "coc-json",
            "coc-marketplace",
            "coc-pyright",
            "coc-rust-analyzer",
            "coc-snippets",
            "coc-sumneko-lua",
            "coc-toml",
            -- "coc-tsserver",
            "coc-yaml",
        }

        vim.keymap.set("n", "gd", "<C-]>")

        vim.keymap.set("n", "t", "<Nop>")
        vim.keymap.set("n", "td", util.cmdcr "Telescope coc definitions")
        vim.keymap.set("n", "ti", util.cmdcr "Telescope coc implementations")
        vim.keymap.set("n", "tr", util.cmdcr "Telescope coc references")
        vim.keymap.set("n", "ty", util.cmdcr "Telescope coc type_definitions")
        vim.keymap.set("n", "tA", util.cmdcr "Telescope coc code_actions")
        vim.keymap.set("n", "tn", "<Plug>(coc-rename)")
        vim.keymap.set("n", "ta", "<Plug>(coc-codeaction-cursor)")
        vim.keymap.set("x", "ta", "<Plug>(coc-codeaction-selected)")
        vim.keymap.set("n", "tw", "<Plug>(coc-float-jump)")
        vim.keymap.set("n", "K", util.cmdcr "call CocActionAsync('doHover')")
        vim.keymap.set("n", "th", util.cmdcr "CocCommand document.toggleInlayHint")

        -- coc#_select_confirm などは Lua 上では動かないので、 <Plug> にマッピングして使えるようにする
        vim.cmd [[
            inoremap <expr> <Plug>(vimrc-coc-select-confirm) coc#_select_confirm()
            inoremap <expr> <Plug>(vimrc-lexima-expand-cr) lexima#expand('<LT>CR>', 'i')
        ]]

        vim.keymap.set("i", "<CR>", function()
            if util.to_bool(vim.fn["coc#pum#visible"]()) then
                -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
                -- （意図せず補完候補がセレクトされてしまうのを抑止）
                if vim.fn["coc#pum#info"]()["index"] >= 0 then
                    return "<Plug>(vimrc-coc-select-confirm)"
                end
                return "<C-y><Plug>(vimrc-lexima-expand-cr)"
            end
            return "<Plug>(vimrc-lexima-expand-cr)"
        end, { expr = true, remap = true })

        -- coc#pum#next(1) などが Vim script 上でしか動かないっぽい

        -- local function coc_check_backspace()
        --     local col = vim.fn.col "." - 1
        --     if not util.to_bool(col) then
        --         return true
        --     end
        --     return vim.regex([[\s]]):match_str(vim.fn.getline(".")[col])
        -- end

        -- vim.keymap.set("i", "<Tab>", function ()
        --     -- if util.to_bool(vim.fn.pumvisible()) then
        --     --     return "<C-n>"
        --     -- end
        --     if util.to_bool(vim.fn["coc#pum#visible"]()) then
        --         return vim.fn["coc#pum#next"](1)
        --     end
        --     if coc_check_backspace() then
        --         return "<Tab>"
        --     end
        --     return vim.fn["coc#refresh"]()
        -- end, {expr = true, silent = true})
        --
        -- vim.keymap.set("i", "<S-Tab>", function ()
        --     -- if util.to_bool(vim.fn.pumvisible()) then
        --     --     return "<C-p>"
        --     -- end
        --     if util.to_bool(vim.fn["coc#pum#visible"]()) then
        --         return vim.fn["coc#pum#next"](-1)
        --     end
        --     return "<C-h>"
        -- end, {expr = true})

        vim.cmd [[
          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~ '\s'
          endfunction

          " Insert <tab> when previous text is space, refresh completion if not.
          inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1):
            \ pumvisible() ? "\<C-n>":
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()
          inoremap <expr><S-TAB>
            \ coc#pum#visible() ? coc#pum#prev(1) :
            \ pumvisible() ? "\<C-p>":
            \ "\<C-h>"
        ]]

        vim.g.coc_snippet_next = "<C-g><C-j>"
        vim.g.coc_snippet_prev = "<C-g><C-k>"

        -- coc の diagnostics の内容を QuiciFix に流し込む。
        local function coc_diag_to_quickfix()
            local diags = vim.fn["CocAction"] "diagnosticList"
            ---@type any[]
            local entries = vim.tbl_map(function(diag)
                return {
                    filename = diag.file,
                    lnum = diag.lnum,
                    end_lnum = diag.end_lnum,
                    col = diag.col,
                    end_col = diag.end_col,
                    text = diag.message,
                    type = diag.severity:sub(1, 1),
                }
            end, diags)

            vim.fn.setqflist(entries)
            vim.fn.setqflist({}, "a", { title = "Coc diagnostics" })
        end

        util.create_cmd("CocQuickfix", function()
            coc_diag_to_quickfix()
            vim.cmd [[cwindow]]
        end)

        ---diagnostics のある位置にジャンプする。ただし種類に応じて優先順位を付ける。
        ---つまり、エラーがあればまずエラーにジャンプする。
        ---エラーがなく警告があれば、警告にジャンプする。みたいな。
        ---@param forward boolean
        local function jump_diag(forward)
            local action_name = util.ifexpr(forward, "diagnosticNext", "diagnosticPrevious")
            util.motion_autoselect {
                function()
                    vim.fn.CocAction(action_name, "error")
                end,
                function()
                    vim.fn.CocAction(action_name, "warning")
                end,
                function()
                    vim.fn.CocAction(action_name, "information")
                end,
                function()
                    vim.fn.CocAction(action_name, "hint")
                end,
            }
        end

        vim.keymap.set("n", ")", function()
            jump_diag(true)
        end)
        vim.keymap.set("n", "(", function()
            jump_diag(false)
        end)
    end,
}

return plugins:collect()

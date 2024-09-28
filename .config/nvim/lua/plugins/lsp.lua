local util = require("rc.util")
local monaqa = require("monaqa")
local motion_autoselect = monaqa.edit.motion_autoselect
local logic = monaqa.logic
local create_cmd = monaqa.shorthand.create_cmd
local mapset = monaqa.shorthand.mapset
local vec = require("rc.util.vec")

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
            end, vim.fn.CocAction("services"))
        end

        create_cmd("CocToggleService") {
            desc = [[引数に与えた coc のサービスを有効化・無効化する]],
            nargs = 1,
            complete = coc_service_names,
            function(meta)
                vim.fn.CocAction("toggleService", meta.args)
            end,
        }

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
            "coc-tsserver",
            "coc-yaml",
            "coc-tsdetect",
            "coc-css",
            "@yaegassy/coc-tailwindcss3",
            "coc-eslint",
        }

        vim.keymap.set("n", "gd", "<C-]>")

        mapset.n("t") { "<Nop>" }
        mapset.n("td") { "<Cmd>Telescope coc definitions<CR>" }
        mapset.n("ti") { "<Cmd>Telescope coc implementations<CR>" }
        mapset.n("tr") { "<Cmd>Telescope coc references<CR>" }
        mapset.n("ty") { "<Cmd>Telescope coc type_definitions<CR>" }
        mapset.n("tA") { "<Cmd>Telescope coc code_actions<CR>" }
        mapset.n("tn") { "<Plug>(coc-rename)" }
        mapset.n("ta") { "<Plug>(coc-codeaction-cursor)" }
        mapset.n("ta") { "<Plug>(coc-codeaction-selected)" }
        mapset.n("tw") { "<Plug>(coc-float-jump)" }
        mapset.n("K") { "<Cmd>call CocActionAsync('doHover')<CR>" }
        mapset.n("tf") { "<Cmd>call CocActionAsync('format')<CR>" }
        mapset.n("th") { "<Cmd>CocCommand document.toggleInlayHint<CR>" }

        -- coc#_select_confirm などは Lua 上では動かないので、 <Plug> にマッピングして使えるようにする

        mapset.i("<Plug>(vimrc-coc-select-confirm)") { "coc#_select_confirm()", expr = true }
        mapset.i("<Plug>(vimrc-lexima-expand-cr)") { "lexima#expand('<LT>CR>', 'i')", expr = true }

        mapset.i("<CR>") {
            desc = [[lexima と coc 両方を加味したエンター]],
            expr = true,
            remap = true,
            function()
                if logic.to_bool(vim.fn["coc#pum#visible"]()) then
                    -- 補完候補をセレクトしていたときのみ、補完候補の内容で確定する
                    -- （意図せず補完候補がセレクトされてしまうのを抑止）
                    if vim.fn["coc#pum#info"]()["index"] >= 0 then
                        return "<Plug>(vimrc-coc-select-confirm)"
                    end
                    return "<C-y><Plug>(vimrc-lexima-expand-cr)"
                end
                return "<Plug>(vimrc-lexima-expand-cr)"
            end,
        }

        vim.cmd([[
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
        ]])

        vim.g.coc_snippet_next = "<C-g><C-j>"
        vim.g.coc_snippet_prev = "<C-g><C-k>"

        -- coc の diagnostics の内容を QuiciFix に流し込む。
        local function coc_diag_to_quickfix()
            local diags = vim.fn["CocAction"]("diagnosticList")
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

        create_cmd("CocQuickfix") {
            desc = [[coc.nvim の診断情報を QuiciFix に表示する]],
            function()
                coc_diag_to_quickfix()
                vim.cmd.cwindow()
            end,
        }

        ---diagnostics のある位置にジャンプする。ただし種類に応じて優先順位を付ける。
        ---つまり、エラーがあればまずエラーにジャンプする。
        ---エラーがなく警告があれば、警告にジャンプする。みたいな。
        ---@param forward boolean
        local function jump_diag(forward)
            local action_name = logic.ifexpr(forward, "diagnosticNext", "diagnosticPrevious")
            motion_autoselect {
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

        mapset.n(")") {
            desc = [[次の diagnostics の場所にうつる]],
            function()
                jump_diag(true)
            end,
        }

        mapset.n("(") {
            desc = [[前の diagnostics の場所にうつる]],
            function()
                jump_diag(false)
            end,
        }
    end,
}

return plugins:collect()

-- local directory に memo を取るための設定 & 関数集

local M = {}

local logic = require("monaqa.logic")
local shorthand = require("monaqa.shorthand")
local autocmd_vimrc = shorthand.autocmd_vimrc

--- memo file を作成し、そのパスを返す。
function M.create_memo_files(dir)
    local memo_dir = dir .. "/.memo.local"
    if not logic.to_bool(vim.fn.isdirectory(memo_dir)) then
        vim.fn.mkdir(memo_dir, "p")
    end
    local memo_typ = memo_dir .. "/memo.typ"
    local preamble_typ = memo_dir .. "/preamble.typ"
    if logic.to_bool(vim.fn.filereadable(memo_typ)) then
        return
    end
    vim.fn.writefile({
        [[#import "preamble.typ": *; #show: preamble]],
    }, memo_typ)
    vim.fn.writefile({
        [[// /Users/monaqa/ghq/github.com/monaqa/typst-class-memo/src/lib.typ]],
        [[#import "@local/class-memo:0.1.0": *]],
        [[]],
        [[#let preamble(body) = {]],
        [[  show: document]],
        [[  body]],
        [[}]],
    }, preamble_typ)
    vim.notify("New memo file is created at " .. memo_dir .. ".")

    return memo_typ
end

function M.setup()
    autocmd_vimrc("VimEnter") {
        desc = ".memo.local/memo.typ が cwd にあればそれを開く",
        callback = function()
            if #vim.v.argv > 2 then
                -- Workaround: nvim を引数付きで開いた場合は後続処理を行わない。
                -- 引数無しで開けば vim.v.argv は
                -- {"nvim への絶対パス", "--embed"} みたいな配列になるため、
                -- それ以外を弾く形。
                return
            end
            if logic.to_bool(vim.fn.filereadable(".memo.local/memo.typ")) then
                vim.cmd.edit(".memo.local/memo.typ")
                vim.cmd.setfiletype("typst")
                -- なぜか BufRead が発火しない
                vim.cmd.normal([[g`"]])
            end
        end,
    }
end

return M

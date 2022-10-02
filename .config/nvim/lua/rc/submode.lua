-- submode 相当の機能を提供する。

-- 以下のようなマッピングを量産できる
--
-- vim.keymap.set("n", "s+", "<C-w>+<Plug>(vimrc-enter-pending)")
-- vim.keymap.set("n", "<Plug>(vimrc-enter-pending)+", "<C-w>+<Plug>(vimrc-enter-pending)")
-- vim.keymap.set("n", "<Plug>(vimrc-enter-pending)", "<Nop>")
--
-- このテクニックは以下の記事を参考にした:
-- https://zenn.dev/mattn/articles/83c2d4c7645faa
-- （Lua では <SID> が使えないようなので <Plug> で代用。<Plug> が remap を自動展開してくれる仕様で助かった）

local M = {}

---@param namespace string
---@param prefix string
---@param beforehook fun() | nil
---@param afterhook fun() | nil
function M.create_mode(namespace, prefix, beforehook, afterhook)
    local plug_pending = ("<Plug>(submode-p-%s)"):format(namespace)
    local plug_before_hook = ("<Plug>(submode-b-%s)"):format(namespace)
    local plug_after_hook = ("<Plug>(submode-a-%s)"):format(namespace)

    local timeoutlen

    if beforehook == nil then
        beforehook = function()
            timeoutlen = vim.opt.timeoutlen
            vim.opt.timeoutlen = 10000
            print("SUBMODE (" .. namespace .. ") IS ACTIVE!")
        end
    end

    if afterhook == nil then
        afterhook = function()
            vim.opt.timeoutlen = timeoutlen
            print("Submode (" .. namespace .. ") finished.")
        end
    end

    vim.keymap.set("n", plug_before_hook, beforehook)
    vim.keymap.set("n", plug_after_hook, afterhook)
    vim.keymap.set("n", plug_pending, plug_after_hook)

    local mode = {
        ---@param repeater string
        ---@param action string
        register_mapping = function(repeater, action)
            vim.keymap.set("n", prefix .. repeater, plug_before_hook .. action .. plug_pending)
            vim.keymap.set("n", plug_pending .. repeater, action .. plug_pending)
        end,
    }

    return mode
end

return M

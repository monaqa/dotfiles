-- OSC 8 links received after setup(), in terminal buffer coordinates.
-- Best effort: plain-text overwrites, scrollback eviction and terminal reflow
-- do not necessarily emit OSC 8, so recorded ranges can become stale.
local M = {}
local buffers = {}

local function before(a, b)
    return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
end

local function position()
    return { vim.fn.line("."), vim.fn.virtcol(".", true)[1] - 1 }
end

function M.get_link_under_cursor()
    local state = buffers[vim.api.nvim_get_current_buf()]
    local pos = position()
    for _, link in ipairs(state and state.links or {}) do
        if not before(pos, link.start) and before(pos, link.finish) then
            return link
        end
    end
end

function M.open(t)
    t = t or {}

    local line = M.get_link_under_cursor()
    if link == nil then
        vim.notify("カーソル下に記録済みの OSC 8 リンクはありません")
        return false
    end

    if t.external == true then
        local _, err = vim.ui.open(link.url)
        if err then
            vim.notify(err, vim.log.levels.ERROR)
            return false
        end
        return true
    else
        vim.cmd.edit(link.url)
        return true
    end
end

function M.jump(direction)
    local state = buffers[vim.api.nvim_get_current_buf()]
    local links = state and state.links or {}
    local pos = position()
    for _ = 1, vim.v.count1 do
        local target
        for _, link in ipairs(links) do
            if direction > 0 and before(pos, link.start) then
                target = link.start
                break
            elseif direction < 0 and before(link.start, pos) then
                target = link.start
            end
        end
        if not target then
            break
        end
        pos = target
    end
    if pos[1] <= vim.api.nvim_buf_line_count(0) then
        -- TermRequest columns are screen cells, not UTF-8 byte offsets.
        local col = vim.fn.virtcol2col(0, pos[1], pos[2] + 1)
        if col > 0 then
            vim.api.nvim_win_set_cursor(0, { pos[1], col - 1 })
        end
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("terminal_osc8_links", { clear = true })
    vim.api.nvim_create_autocmd("TermRequest", {
        group = group,
        callback = function(ev)
            local url = ev.data.sequence:match("^\27%]8;[^;]*;(.*)$")
            if not url then
                return
            end
            local state = buffers[ev.buf]
            if not state then
                state = { links = {} }
                buffers[ev.buf] = state
            end
            local cursor = { ev.data.cursor[1], ev.data.cursor[2] }
            local pending = state.pending
            if pending and before(pending.start, cursor) then
                pending.finish = cursor
                -- A newly emitted link replaces overlapping recorded links.
                state.links = vim.tbl_filter(function(link)
                    return not (before(link.start, pending.finish) and before(pending.start, link.finish))
                end, state.links)
                table.insert(state.links, pending)
                table.sort(state.links, function(a, b)
                    return before(a.start, b.start)
                end)
            end
            state.pending = url ~= "" and { start = cursor, url = url } or nil
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        callback = function(ev)
            buffers[ev.buf] = nil
        end,
    })
end

return M

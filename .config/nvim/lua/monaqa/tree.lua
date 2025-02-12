-- tree-sitter helper

local M = {}

---@class MatchNode
---@field node TSNode
---@field text string
---@field region {s: [integer, integer], e: [integer, integer]}

--- query とキャプチャ名を与えて、マッチする node 、value の列を返す。
---@param query vim.treesitter.Query
---@param root TSNode
---@param start? integer
---@param stop? integer
---@return table<string, MatchNode>[]
function M.find_matches(query, root, start, stop)
    return vim.iter(query:iter_matches(root, 0, start, stop))
        :map(
            ---@param match table<integer, TSNode>
            function(_, match, _)
                local m = vim
                    .iter(pairs(match))
                    -- :enumerate()
                    :map(function(id, node)
                        local capture_name = query.captures[id]
                        if vim.startswith(capture_name, "_") then
                            return capture_name
                        end
                        local sr, sc, er, ec = node:range()
                        local text =
                            table.concat(vim.fn.getregion({ 0, sr + 1, sc + 1, 0 }, { 0, er + 1, ec, 0 }), "\n")
                        return capture_name,
                            {
                                node = node,
                                text = text,
                                region = { s = { sr + 1, sc + 1 }, e = { er + 1, ec } },
                            }
                    end)
                    :fold({}, function(acc, k, v)
                        acc[k] = v
                        return acc
                    end)
                return m
            end
        )
        :totable()
end

--- query string にマッチする node 、value の列を返す。
---@param query_str string
---@param opts? {bufnr?: integer, start?: integer, stop?: integer}
---@return table<string, MatchNode>[]
function M.find_buf_matches(query_str, opts)
    if opts == nil then
        opts = {}
    end
    local bufnr = opts.bufnr
    local start = opts.start
    local stop = opts.stop
    local parser = vim.treesitter.get_parser(bufnr)
    local root = parser:parse()[1]:root()
    local query = vim.treesitter.query.parse(parser:lang(), query_str)
    return M.find_matches(query, root, start, stop)
end

--- query string にマッチする node を replacef の評価結果で置き換える。
---@param query_str string
---@param replacef fun(s: string, n: TSNode): string
---@param opts? {bufnr?: integer, start?: integer, stop?: integer, capture_name?: string}
function M.replace_buf(query_str, replacef, opts)
    local matches = M.find_buf_matches(query_str, opts)

    if opts == nil then
        opts = {}
    end
    local capture_name = opts.capture_name or "-"

    vim.iter(matches):rev():each(
        ---@param match table<string, MatchNode>
        function(match)
            if match[capture_name] == nil then
                return
            end
            local m = match[capture_name]
            local after = replacef(m.text, m.node)
            local s = m.region.s
            local e = m.region.e

            vim.api.nvim_buf_set_text(opts.bufnr or 0, s[1] - 1, s[2] - 1, e[1] - 1, e[2], vim.split(after, "\n"))
        end
    )
end

--- query string にマッチする場所にカーソルを動かす。
---@param query_str string
---@param opts? {backward?: boolean, bufnr?: integer, capture_name?: string}
function M.move(query_str, opts)
    if opts == nil then
        opts = {}
    end
    local capture_name = opts.capture_name or "-"

    local bufnr = opts.bufnr
    local parser = vim.treesitter.get_parser(bufnr)
    local root = parser:parse()[1]:root()
    local query = vim.treesitter.query.parse(parser:lang(), query_str)
    local matches = M.find_matches(query, root, 1, -1)

    local _, cur_row, cur_col = unpack(vim.fn.getcurpos())

    ---@type MatchNode[]
    local captures = vim.iter(matches)
        :filter(
            ---@param match table<string, MatchNode>
            function(match)
                return match[capture_name] ~= nil
            end
        )
        :map(function(match)
            return match[capture_name]
        end)
        :totable()

    if #captures == 0 then
        return
    end

    local next_node
    if not opts.backward then
        next_node = vim.iter(captures):find(
            ---@param capture MatchNode
            function(capture)
                local s_row, s_col = unpack(capture.region.s)
                return s_row > cur_row or (s_row == cur_row and s_col > cur_col)
            end
        )
        if next_node == nil then
            next_node = captures[1]
        end
    else
        next_node = vim.iter(captures):rev():find(
            ---@param capture MatchNode
            function(capture)
                local s_row, s_col = unpack(capture.region.s)
                return s_row < cur_row or (s_row == cur_row and s_col < cur_col)
            end
        )
        if next_node == nil then
            next_node = captures[#captures]
        end
    end

    vim.fn.setpos(".", { 0, next_node.region.s[1], next_node.region.s[2], 0 })

    -- local m = vim.iter(matches):find(
    --     ---@param match table<string, MatchNode>
    --     function(match)
    --         if match[capture_name] == nil then
    --             return false
    --         end
    --         local capture = match[capture_name]
    --         return capture.region.s[1] > cursor[2]
    --             or (capture.region.s[1] == cursor[2] and capture.region.s[2] > cursor[3])
    --     end
    -- )
    -- if m == nil then
    --     return
    -- end
    -- vim.fn.setpos(".", { 0, m[capture_name].region.s[1], m[capture_name].region.s[2], 0 })
end

return M

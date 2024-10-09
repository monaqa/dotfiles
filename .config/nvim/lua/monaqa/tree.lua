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
                local m = vim.iter(match)
                    :enumerate()
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

---@param query_str string
---@param replacef fun(string, TSNode): string
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

return M

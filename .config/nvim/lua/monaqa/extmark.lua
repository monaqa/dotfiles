local M = {}

---@class monaqa.extmark.getall_opts: vim.api.keyset.get_extmarks
---@field [1]? integer
---@field [2]? integer

---@class monaqa.extmark.set_opts: vim.api.keyset.set_extmark
---@field [1] [integer, integer] | string
---@field [2]? [integer, integer] | string

---@class monaqa.extmark.update_opts: vim.api.keyset.set_extmark
---@field [1]? [integer, integer] | string
---@field [2]? [integer, integer] | string

---@class monaqa.extmark.ExtmarkApi
---@field ns_id integer
---@field bufnr integer
local ExtmarkApi = {}

---@class monaqa.extmark.MarkApi
---@field ns_id integer
---@field bufnr integer
---@field id integer
local MarkApi = {}

--- 独自 API の opts を公式 API の引数3つ組にする。
---@param opts monaqa.extmark.set_opts
---@return integer
---@return integer
---@return vim.api.keyset.set_extmark
local function setopts_to_args(opts)
    local start_pos = opts[1]
    opts[1] = nil
    local end_pos = opts[2]
    opts[2] = nil

    if type(start_pos) == "string" then
        local pos = vim.fn.getpos(start_pos)
        start_pos = { pos[2] - 1, pos[3] - 1 }
    end
    if type(end_pos) == "string" then
        local pos = vim.fn.getpos(end_pos)
        end_pos = { pos[2] - 1, pos[3] - 1 }
    end
    if start_pos == nil then
        start_pos = {}
    end
    if end_pos ~= nil then
        opts.end_row = end_pos[1]
        opts.end_col = end_pos[2]
    end
    return start_pos[1], start_pos[2], opts
end

---@param t {bufnr: integer, ns_id: integer}
---@return monaqa.extmark.ExtmarkApi
function ExtmarkApi.new(t)
    return setmetatable(t, { __index = ExtmarkApi })
end

---@param opts monaqa.extmark.set_opts
---@return monaqa.extmark.MarkApi
function ExtmarkApi:set(opts)
    local line, col, setopts = setopts_to_args(opts)
    local id = vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, line, col, setopts)
    return MarkApi.new {
        bufnr = self.bufnr,
        ns_id = self.ns_id,
        id = id,
    }
end

---@param opts monaqa.extmark.set_opts
---@return monaqa.extmark.MarkApi
function ExtmarkApi:set_with_hl(opts)
    opts.hl_group = "NvimInvalid"
    return self:set(opts)
end

---@param opts? monaqa.extmark.getall_opts
---@return vim.api.keyset.get_extmark_item
function ExtmarkApi:getall(opts)
    if opts == nil then
        opts = {}
    end
    return vim.api.nvim_buf_get_extmarks(self.bufnr, self.ns_id, opts[1], opts[2], opts)
end

---@param opts? [integer?, integer?]
function ExtmarkApi:clear(opts)
    if opts == nil then
        opts = {}
    end
    vim.api.nvim_buf_clear_namespace(self.bufnr, self.ns_id, opts[1] or 0, opts[2] or -1)
end

---@param t {bufnr: integer, ns_id: integer, id: integer}
---@return monaqa.extmark.MarkApi
function MarkApi.new(t)
    return setmetatable(t, { __index = MarkApi })
end

---@return vim.api.keyset.get_extmark_item_by_id
function MarkApi:info()
    return vim.api.nvim_buf_get_extmark_by_id(self.bufnr, self.ns_id, self.id, { details = true, hl_name = true })
end

---@return boolean
function MarkApi:del()
    return vim.api.nvim_buf_del_extmark(self.bufnr, self.ns_id, self.id)
end

---@param opts monaqa.extmark.set_opts
function MarkApi:set(opts)
    local line, col, setopts = setopts_to_args(opts)
    setopts.id = self.id
    return vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, line, col, setopts)
end

-- ---@param opts monaqa.extmark.update_opts
-- function MarkApi:update(opts)
--     local info = self:info()
--     local args = info[3]
--     local line, col, setopts = setopts_to_args(opts)
--     if line == nil then
--         line = info[1]
--     end
--     if col == nil then
--         col = info[2]
--     end
--     for key, value in pairs(setopts) do
--         args[key] = value
--     end
--     args.id = self.id
--     return vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, line, col, args)
-- end

---@param bufnr integer
---@param namespace? string
---@return monaqa.extmark.ExtmarkApi
function M.with_buffer(bufnr, namespace)
    if namespace == nil then
        namespace = "monaqa.extmark"
    end

    local ns_id = vim.api.nvim_create_namespace(namespace)
    return ExtmarkApi.new { bufnr = bufnr, ns_id = ns_id }
end

return M

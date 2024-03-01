-- Vec みたいなやつ。
-- vec({1, 2, 3}):map(function(x) return 2 * x end).collect()
-- vec({"foo", "bar"}):contains("baz")
-- vec({{1}, {2, 3}}):concat()
-- とかやりたいよね。

---@class Vec
---@field t any
local Vec = {}

---@param t any[]
---@return Vec
function Vec.new(t)
    return setmetatable({ t = t }, { __index = Vec })
end

---@generic T, U
---@param f fun(t: T): U
---@return Vec
function Vec:map(f)
    local results = {}
    for _, value in ipairs(self.t) do
        results[#results + 1] = f(value)
    end
    return Vec.new(results)
end

---@return Vec
function Vec:sorted(comp)
    local ary = self:collect()
    table.sort(ary, comp)
    return Vec.new(ary)
end

---@return Vec
function Vec:uniq()
    local map = {}
    local idx = 1
    for _, value in ipairs(self:collect()) do
        if map[value] == nil then
            map[value] = idx
            idx = idx + 1
        end
    end

    local ary = {}

    for key, value in pairs(map) do
        ary[value] = key
    end

    return Vec.new(ary)
end

---@generic T
---@param f fun(t: T)
function Vec:for_each(f)
    for _, value in ipairs(self.t) do
        f(value)
    end
end

---@generic T
---@param f fun(t: T): boolean
---@return Vec
function Vec:filter(f)
    local results = {}
    for _, value in ipairs(self.t) do
        if f(value) then
            results[#results + 1] = value
        end
    end
    return Vec.new(results)
end

---@generic T, U
---@param f fun(t: T): U | nil
---@return Vec
function Vec:filter_map(f)
    local results = {}
    for _, value in ipairs(self.t) do
        if f(value) ~= nil then
            results[#results + 1] = f(value)
        end
    end
    return Vec.new(results)
end

---@generic T
---@return T[]
function Vec:collect()
    return self.t
end

---@generic T
---@return Vec
function Vec:concat()
    local results = {}
    for _, array in ipairs(self.t) do
        for _, value in ipairs(array) do
            results[#results + 1] = value
        end
    end
    return Vec.new(results)
end

---@generic T
---@param e T
function Vec:push(e)
    self.t[#self.t + 1] = e
end

---@generic T
---@param t T[]
function Vec:append(t)
    for _, value in ipairs(t) do
        self.t[#self.t + 1] = value
    end
end

---@generic T
---@param t T[]
---@return Vec
local function vec(t)
    return Vec.new(t)
end

return vec

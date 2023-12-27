-- Vec みたいなやつ。
-- vec({1, 2, 3}):map(function(x) return 2 * x end).into_table()
-- vec({"foo", "bar"}):contains("baz")
-- vec({{1}, {2, 3}}):concat()
-- とかやりたいよね。

---@generic T
---@class Vec<T>
---@field t `T`[]
local Vec = {}

---@generic T
---@param t `T`[]
---@return Vec<T>
function Vec.new(t)
    return setmetatable({ t = t }, { __index = Vec })
end

---@generic T
---@param f fun(t: T): T
---@return Vec<T>
function Vec:map(f)
    local results = {}
    for _, value in ipairs(self.t) do
        results[#results + 1] = f(value)
    end
    return Vec.new(results)
end

---@generic T
---@param f fun(t: T): boolean
---@return Vec<T>
function Vec:filter(f)
    local results = {}
    for _, value in ipairs(self.t) do
        if f(value) then
            results[#results + 1] = value
        end
    end
    return Vec.new(results)
end

---@generic T
---@param f fun(t: T): T | nil
---@return Vec<T>
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
function Vec:into_table()
    return self.t
end

---@generic T
---@param self Vec<T[]>
---@return T[]
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
---@param t T[]
---@return Vec<T>
local function vec(t)
    return Vec.new(t)
end

return vec

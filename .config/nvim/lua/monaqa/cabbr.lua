local M = {}

local logic = require("monaqa.logic")
local mapset = require("monaqa.shorthand").mapset

---@class rule
---@field condition fun(text: string): boolean
---@field to string
---@field remove_trigger boolean

---@class ruletable
---@field from string
---@field to string
---@field type? string
---@field prepose? string
---@field condition? fun(text: string): boolean
---@field require_space? boolean
---@field remove_trigger? boolean

---@type {[string]: rule[]}
M.rules = {}

---cabbrev を register する。
---@param lhs string
function M:register(lhs)
    local rules = self.rules[lhs]
    if rules == nil or #rules == 0 then
        return
    end
    local expands = vim.iter(rules)
        :map(function(rule)
            return rule.to
        end)
        :join(", ")
    mapset.ca(lhs) {
        desc = [[Expanding into ]] .. expands,
        expr = true,
        replace_keycodes = true,
        function()
            local cmdline = vim.fn.getcmdtype() .. vim.fn.getcmdline()
            for _, rule in ipairs(rules) do
                if rule.condition(cmdline) then
                    if rule.remove_trigger then
                        vim.fn.getchar()
                    end
                    return rule.to
                end
            end
            return lhs
        end,
    }
end

---add された cabbrev をすべて register する。
function M:register_all()
    for key, _ in pairs(self.rules) do
        self:register(key)
    end
end

---ruletable を rule に変換する。
---@param t ruletable
---@return rule?
local function ruletable_to_rule(t)
    local condition
    local type = t.type
    if type == nil then
        type = ":"
    end
    if t.condition ~= nil then
        condition = t.condition
    elseif t.prepose ~= nil then
        ---@param text string
        condition = function(text)
            local space = logic.ifexpr(t.require_space == false, "", " ")
            return text == type .. t.prepose .. space .. t.from
        end
    else
        ---@param text string
        condition = function(text)
            return text == type .. t.from
        end
    end
    return {
        to = t.to,
        condition = condition,
        remove_trigger = t.remove_trigger,
    }
end

---与えられた設定を元に cabbrev の設定を追加する。
---  - from (string): lhs に相当する置換前の文字列
---  - to (string): 置換後の文字列
---  - prepose (string?): この文字が前置されているときだけ置換する
---  - require_space (boolean?): prepose と from 間の空白を必須にする（default: true）
---  - remove_trigger (boolean?): trigger 文字（スペースなど）を展開後に削除する
---  - condition (fun(string):bool): 置換する条件を任意に設定できる
---@param t ruletable
function M:add(t)
    local key = t.from
    local rule = ruletable_to_rule(t)
    if rule == nil then
        return
    end
    if self.rules[key] == nil then
        self.rules[key] = {}
    end
    self.rules[key][#self.rules[key] + 1] = rule
end

---与えられた設定を元に cabbrev を作成する。
---@param t ruletable
function M:add_and_register(t)
    self:add(t)
    self:register(t.from)
end

return M

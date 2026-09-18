-- list を Markdown に変換するとき、空行挿入や TODO などをよしなに扱う

local function is_nested_list(block)
    return block.t == "BulletList"
        or block.t == "OrderedList"
        or block.t == "DefinitionList"
end

local function task_marker(inlines)
    local marker
    local rest_start

    if inlines[1]
        and inlines[1].t == "Str"
        and inlines[1].text == "[x]"
    then
        marker = inlines[1].text
        rest_start = 2
    elseif #inlines >= 3
        and inlines[1].t == "Str"
        and inlines[1].text == "["
        and inlines[2].t == "Space"
        and inlines[3].t == "Str"
        and inlines[3].text == "]"
    then
        marker = "[ ]"
        rest_start = 4
    else
        return inlines
    end

    local result = pandoc.Inlines({
        pandoc.RawInline("gfm", marker)
    })
    for i = rest_start, #inlines do
        result:insert(inlines[i])
    end
    return result
end

local function tighten(list)
    for _, item in ipairs(list.content) do
        local first = item[1]
        if first and (first.t == "Para" or first.t == "Plain") then
            first.content = task_marker(first.content)
        end

        local paragraph_count = 0
        local safe = true
        for _, block in ipairs(item) do
            if block.t == "Para" then
                paragraph_count = paragraph_count + 1
            elseif not is_nested_list(block) then
                safe = false
            end
        end

        if safe and paragraph_count == 1 then
            for i, block in ipairs(item) do
                if block.t == "Para" then
                    item[i] = pandoc.Plain(block.content)
                end
            end
        end
    end

    return list
end

function BulletList(list)
    return tighten(list)
end

function OrderedList(list)
    return tighten(list)
end

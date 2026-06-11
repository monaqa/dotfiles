-- 以下の Typst 構文について、変換後もそのまま保持する。
-- - lang が "embed" になっている code block
-- - 直後に `<embed>` ラベルが付いている inline code

local function raw_format()
    return FORMAT:match("^[^%+%-]+") or FORMAT
end

function CodeBlock(cb)
    if cb.classes and cb.classes:includes("embed") then
        return pandoc.RawBlock(raw_format(), cb.text)
    end
end

function Inlines(inlines)
    local out = pandoc.List()
    local i = 1

    while i <= #inlines do
        local cur = inlines[i]
        local nxt = inlines[i + 1]

        if cur.t == "Code"
            and nxt
            and nxt.t == "Span"
            and nxt.identifier == "embed"
            and #nxt.content == 0
        then
            out:insert(pandoc.RawInline(raw_format(), cur.text))
            i = i + 2
        else
            out:insert(cur)
            i = i + 1
        end
    end

    return out
end


-- add some TeX code to headers with `{punkte=42}`
function Header(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    local c = el.content

    if p > 0 then
        c:insert(pandoc.Space())
        c:insert(pandoc.RawInline("latex", "\\hfill"))
        c:insert(pandoc.Space())
        c:insert(pandoc.Str("(" .. p))
        c:insert(pandoc.Space())
        c:insert(pandoc.Str("Punkt" .. (p > 1 and "e" or "") .. ")"))
    end

    return el
end

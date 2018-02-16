-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- add some TeX code to headers with `{punkte=42}`
function extendHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    if p > 0 then
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.RawInline("latex", "\\hfill"))
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.Str("(" .. p))
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.Str("Punkt" .. (p > 1 and "e" or "") .. ")"))
    end

    return el
end


return { { Header = extendHeaders } }


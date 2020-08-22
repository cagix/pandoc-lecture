
-- add some TeX code to headers with `{punkte=42}`
function Header(el)
    local p = tonumber(el.attributes["punkte"]) or 0

    if p > 0 then
        el.content:extend { pandoc.Space(), pandoc.RawInline("latex", "\\hfill"),
                pandoc.Space(), pandoc.Str("(" .. p), pandoc.Space(),
                pandoc.Str("Punkt" .. (p > 1 and "e" or "") .. ")") }
    end

    return el
end

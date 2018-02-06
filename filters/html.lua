-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- handling of `\blueArrow` ... (RawInline, tex)
function blueArrow(el)
    if el.format == "tex" then
        if string.match(el.text, "\\blueArrow") then
            return {pandoc.Span({pandoc.Str("=>")}, pandoc.Attr("", {"blueArrow"})), pandoc.Space()}
        end
    end
end


return {{RawInline = blueArrow}}


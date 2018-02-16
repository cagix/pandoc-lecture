-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- helper function to create span for blue arrows
local function blueArrow()
    return {pandoc.Span({pandoc.Str("=>")}, pandoc.Attr("", {"blueArrow"})), pandoc.Space()}
end


-- handling of `\blueArrow` ... (RawInline, tex)
function blueArrowInline(el)
    if el.format == "tex" or el.format == "latex" then
        if string.match(el.text, "\\blueArrow") then
            return blueArrow()
        end
    end
end


-- handling of `\blueArrow` ... (RawBlock, tex)
function blueArrowBlock(el)
    if el.format == "tex" or el.format == "latex"  then
        if string.match(el.text, "\\blueArrow") then
            return pandoc.Plain(blueArrow())
        end
    end
end


-- remove inline slides: `[...]{.slides}` ... (Span class)
function inlineSlides(el)
    if el.classes[1] == "slides" then
        return {}
    end
end

-- remove block slides: `::: slides ... :::` ... (Div class)
function blockSlides(el)
    if el.classes[1] == "slides" then
        return {}
    end
end


return {{RawInline = blueArrowInline, RawBlock = blueArrowBlock}, {Span = inlineSlides, Div = blockSlides}}


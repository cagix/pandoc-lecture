-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- helper function to create span for blue arrows
local function blueArrow()
    return { pandoc.Span({ pandoc.Str("=>") }, pandoc.Attr("", { "blueArrow" })), pandoc.Space() }
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
    if el.format == "tex" or el.format == "latex" then
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


-- helper function to remove key from table (if existing)
local function stripAttr(table, attr)
    if table[attr] then
        table[attr] = nil
    end
end

-- strip scaling information from images attrs
-- explicit scaling in markdown is used for beamer slides (pdf)
-- for more predictable results in html we use manually scaled png images
function stripImageAttrs(el)
    stripAttr(el.attr.attributes, "scale")
    stripAttr(el.attr.attributes, "width")
    stripAttr(el.attr.attributes, "height")

    return el
end


return { { RawInline = blueArrowInline, RawBlock = blueArrowBlock }, { Span = inlineSlides, Div = blockSlides }, { Image = stripImageAttrs } }


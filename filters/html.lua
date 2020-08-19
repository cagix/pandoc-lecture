
-- add outer Span to  `[...]{.cbox}` ... (Span class)
function cbox(el)
    if el.classes[1] == "cbox" then
        return pandoc.Span(el, pandoc.Attr("", { "cboxbox" }))
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


-- remove inline notes span, return content: `[...]{.notes}` ... (Span class)
-- rationale: w/o this filter content would appear in generated html but not in toc
function inlineNotes(el)
    if el.classes[1] == "notes" then
        return el.content
    end
end

-- remove block notes div, return content: `::: notes ... :::` ... (Div class)
-- rationale: w/o this filter content would appear in generated html but not in toc
function blockNotes(el)
    if el.classes[1] == "notes" then
        return el.content
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
-- strip also "width" from Div (div.column) to avoid column overlap on small screens
function stripImageAttrs(el)
    stripAttr(el.attr.attributes, "scale")
    stripAttr(el.attr.attributes, "width")
    stripAttr(el.attr.attributes, "height")

    return el
end


return { { Span = cbox }, { Span = inlineNotes, Div = blockNotes }, { Span = inlineSlides, Div = blockSlides }, { Div = stripImageAttrs, Image = stripImageAttrs } }

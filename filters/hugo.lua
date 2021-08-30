-- Remove TeX/LaTeX RawInlines
function RawInline(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        return {}
    end
end

-- Remove TeX/LaTeX RawBlocks
function RawBlock(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        return {}
    end
end


-- Encapsulate TeX Math
function Math(el)
    if el.mathtype:match 'InlineMath' then
        return {
            pandoc.RawInline('markdown', '<span>'),
            el,
            pandoc.RawInline('markdown', '</span>')
          }
    end
    if el.mathtype:match 'DisplayMath' then
        return {
            pandoc.RawInline('markdown', '<div>'),
            el,
            pandoc.RawInline('markdown', '</div>')
          }
    end
end


-- Replace native Divs with "real" Divs or Shortcodes
function Div(el)
    -- Replace "showme" Div with "expand" Shortcode
    if el.classes[1] == "showme" then
        return
            { pandoc.RawBlock("markdown", '{{% expand "Show Me" %}}'), pandoc.RawBlock("markdown", "<div class='showme'>") } ..
            el.content ..
            { pandoc.RawBlock("markdown", "</div>"), pandoc.RawBlock("markdown", "{{% /expand %}}") }
    end

    -- Transform all other native Divs to "real" Divs digestible to Hugo
    return
        { pandoc.RawBlock("markdown", "<div class='" .. el.classes[1] .. "'>") } ..
        el.content ..
        { pandoc.RawBlock("markdown", "</div>") }
end

-- Replace native Spans with "real" Spans or Shortcodes
function Span(el)
    -- Replace "bsp" Span with "button" Shortcode
    if el.classes[1] == "bsp" then
        return
            { pandoc.RawInline("markdown", "{{% button %}}") } ..
            el.content ..
            { pandoc.RawInline("markdown", "{{% /button %}}") }
    end

    -- Transform all other native Spans to "real" Spans digestible to Hugo
    return
        { pandoc.RawInline("markdown", "<span class='" .. el.classes[1] .. "'>") } ..
        el.content ..
        { pandoc.RawInline("markdown", "</span>") }
end

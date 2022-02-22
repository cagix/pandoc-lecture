-- Remove TeX/LaTeX RawInlines
function RawInline(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        -- replace RawInlines ("latex") w/ a space
        return pandoc.Space()
    end
end

-- Remove TeX/LaTeX RawBlocks
function RawBlock(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        -- use empty Para instead of just returning an empty list,
        -- which turns up in the result as HTML comment?!
        return pandoc.Para{}
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


-- Emit custom shortcode `img`: `{{% img src="path" title="text" width="60%" %}}`
function Image(el)
    local w = el.attributes["width"] or "auto"
    local t = pandoc.utils.stringify(el.caption)

    return pandoc.RawInline('markdown', '{{% img src="' .. el.src .. '" title="' .. t .. '" width="' .. w .. '" %}}')
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
            { pandoc.RawInline("markdown", "{{% button-crossreference %}}") } ..
            el.content ..
            { pandoc.RawInline("markdown", "{{% /button-crossreference %}}") }
    end

    -- Transform all other native Spans to "real" Spans digestible to Hugo
    return
        { pandoc.RawInline("markdown", "<span class='" .. el.classes[1] .. "'>") } ..
        el.content ..
        { pandoc.RawInline("markdown", "</span>") }
end


-- Handle citations
-- use "#id_KEY" as target => needs be be defined in the document
-- i.e. the shortcode/partial "bib.html" needs to create this targets
local keys = {}

function Cite(el)
    -- translate a citation into a link
    local citation_to_link = function(citation)
        local id = citation.id
        local suffix = pandoc.utils.stringify(citation.suffix)
        -- remember this id, needs to be added to the meta data
        keys[id] = true
        -- create a link into the current document
        return pandoc.Link("[" .. id .. suffix .. "]", "#id_" .. id)
    end

    -- replace citation with list of links
    return el.citations:map(citation_to_link)
end

function Meta(md)
    -- meta data "readings"
    md.readings = md.readings or pandoc.MetaList(pandoc.List())

    -- has a "readings" element "x" a "key" with value "k"?
    local has_id = function(k)
        return function(x) return pandoc.utils.stringify(x.key) == k end
    end

    -- collect all "keys" which are not in "readings"
    for k, _ in pairs(keys) do
        if #md.readings:filter(has_id(k)) == 0 then
            md.readings:insert(pandoc.MetaMap{key = pandoc.MetaInlines{pandoc.Str(k)}})
        end
    end

    return md
end

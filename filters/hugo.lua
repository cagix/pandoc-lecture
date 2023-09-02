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
            pandoc.RawInline('markdown', '{{< math >}}'),
            el,
            pandoc.RawInline('markdown', '{{< /math >}}')
          }
    end
    if el.mathtype:match 'DisplayMath' then
        return {
            pandoc.RawInline('markdown', '{{< math >}}'),
            el,
            pandoc.RawInline('markdown', '{{< /math >}}')
          }
    end
end


-- Handling of images for Hugo
--
-- Images (empty title): Convert scaling from Pandoc markdown to Hugo Relearn theme
--        "![](img/wuppie.png){width=20%}" will become "![](img/wuppie.png?width=20%25)"
-- Figures (non-empty title): Emit custom shortcode `img`
--        "![Wuppieee](img/wuppie.png){width=20%}" will become "{{% img src="img/wuppie.png?width=20%25" caption="Wuppieee" width="20%" height="auto" class="center" %}}"
--
-- If both the "width" and "web_width" parameters are present, "web_width" takes precedence
-- over the regular "width" parameter. Likewise for "height" and "web_height".
--
-- This needs "-implicit_figures" for Pandoc (see https://github.com/cagix/pandoc-lecture/pull/28).
function Image(el)
    local w = el.attributes["web_width"]  or el.attributes["width"]  or "auto"
    local h = el.attributes["web_height"] or el.attributes["height"] or "auto"
    local t = pandoc.utils.stringify(el.caption)

    if t == "" then
        -- Empty caption ("image"): Just transform width/height for Hugo and Relearn theme
        return pandoc.Image("", el.src .. "?width=" .. w:gsub("%%", "%%25") .. "&height=" .. h:gsub("%%", "%%25"))
    else
        -- Non-empty caption ("figure"): Emit `img` shortcode for Hugo
        -- (custom shortcode, see https://github.com/cagix/pandoc-lecture/pull/28)
        return pandoc.RawInline('markdown', '{{% img src="' .. el.src .. '" caption="' .. t .. '" width="' .. w .. '" height="' .. h .. '" class="center" %}}')
    end
end


-- Replace native Divs with "real" Divs or Shortcodes
function Div(el)
    -- Replace "showme" Div with "expand" Shortcode
    if el.classes[1] == "showme" then
        return
            { pandoc.RawBlock("markdown", '{{% expand "Show Me" %}}') } ..
            el.content ..
            { pandoc.RawBlock("markdown", "{{% /expand %}}") }
    end

    -- Replace "cbox" Div with centered "button" Shortcode
    if el.classes[1] == "cbox" then
        return
            { pandoc.RawBlock("markdown", '<div style="text-align:center;">'), pandoc.RawBlock("markdown", '{{% button style="primary" %}}') } ..
            el.content ..
            { pandoc.RawBlock("markdown", "{{% /button %}}"), pandoc.RawBlock("markdown", "</div>") }
    end

    -- Replace "tabs" Div with "tabs" Shortcode (may have a 'groupid')
    if el.classes[1] == "tabs" then
        local groupid = el.attributes["groupid"] and ('groupid="' .. el.attributes["groupid"] .. '"') or ""
        return
            { pandoc.RawBlock("markdown", '{{< tabs ' .. groupid .. ' >}}') } ..
            el.content ..
            { pandoc.RawBlock("markdown", "{{< /tabs >}}") }
    end

    -- Replace "tab" Div with "tab" Shortcode (may have a 'title')
    if el.classes[1] == "tab" then
        local title = el.attributes["title"] and ('title="' .. el.attributes["title"] .. '"') or ""
        return
            { pandoc.RawBlock("markdown", '{{% tab ' .. title .. ' %}}') } ..
            el.content ..
            { pandoc.RawBlock("markdown", "{{% /tab %}}") }
    end

    -- Transform all other native Divs to "real" Divs digestible to Hugo
    return
        { pandoc.RawBlock("markdown", "<div class='" .. el.classes[1] .. "'>") } ..
        el.content ..
        { pandoc.RawBlock("markdown", "</div>") }
end

-- Replace native Spans with "real" Spans or Shortcodes
function Span(el)
    -- Replace "bsp" span with "button" shortcode
    -- Use key/value pair "href=..." in span as href parameter in shortcode
    if el.classes[1] == "bsp" then
        return {
            pandoc.RawInline('markdown', '<div style="text-align: right;">'),
            pandoc.RawInline('markdown', '{{% button style="btn-crossreference" href="' .. (el.attributes["href"] or "") .. '" %}}')
        } .. el.content .. {
            pandoc.RawInline('markdown', '{{% /button %}}'),
            pandoc.RawInline('markdown', '</div>')
        }
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

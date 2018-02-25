-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- helper function
local function isFormatHtml()
    return FORMAT == "html5" or FORMAT == "html4" or FORMAT == "html"
end


-- helper function
local function isFormatLatex()
    return FORMAT == "beamer" or FORMAT == "latex" or FORMAT == "tex"
end


-- helper function to handle inline images
-- adds extra line of text after inline image
local function inlineImage(img, str)
    if isFormatHtml() then
        return { img, pandoc.LineBreak(), pandoc.Span(pandoc.Str(str), pandoc.Attr("", { "origin" })) }
    elseif isFormatLatex() then
        return { img, pandoc.LineBreak(), pandoc.RawInline("latex", "\\vspace{-1em} "), pandoc.RawInline("latex", "\\tiny "), pandoc.Str(str), pandoc.RawInline("latex", " \\normalsize") }
    else
        return img -- some other format, do nothing
    end
end

-- helper function to handle figures
-- adds information to figure caption
local function figure(img, str)
    table.insert(img.caption, pandoc.Str(str))
    return img
end


-- add proper source information to figures
-- use image title (if provided): `![caption string](path/to/image "title string"){.class key=value}`
function image(img)
    -- check for empty title string
    if img.title == "" or img.title == "fig:" then
        return img
    end

    -- check for figure vs. inline image: figure title string starts with prefix "fig:"
    local title = string.match(img.title, "^fig:(.*)")
    if title == nil then
        return inlineImage(img, img.title)
    else
        return figure(img, " (" .. title .. ")")
    end
end


-- handling of  `[...]{.origin}` for inline images... (Span class)
-- allows for some formatting inside the origin/author/license information
-- should follow the inline image in the same paragraph/line
function origin(el)
    if el.classes[1] == "origin" then
        if isFormatLatex() then
            local content = el.content
            table.insert(content, 1, pandoc.LineBreak())
            table.insert(content, 1, pandoc.RawInline("latex", "\\vspace{-1em} "))
            table.insert(content, 1, pandoc.RawInline("latex", "\\tiny "))
            table.insert(content, #content + 1, pandoc.RawInline("latex", " \\normalsize"))
            return content
        elseif isFormatHtml() then
            return { pandoc.LineBreak(), el }
        else
            return el
        end
    end
end


return { { Span = origin, Image = image } }


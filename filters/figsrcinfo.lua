-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- helper function to handle inline images
-- adds extra line of text after inline image
local function inlineImage(img, str)
    if FORMAT == "html5" or FORMAT == "html4" or FORMAT == "html" then
        return { img, pandoc.LineBreak(), pandoc.Span(pandoc.Str(str), pandoc.Attr("", { "quelle" })) }
    elseif FORMAT == "beamer" or FORMAT == "latex" or FORMAT == "tex" then
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
    local quelle = "Quelle: "

    -- check for empty title string
    if img.title == "" or img.title == "fig:" then
        return img
    end

    -- check for figure vs. inline image: figure title string starts with prefix "fig:"
    local title = string.match(img.title, "^fig:(.*)")
    if title == nil then
        return inlineImage(img, quelle .. img.title)
    else
        return figure(img, " [" .. quelle .. title .. "]")
    end
end


return { { Image = image } }



-- strip scaling information from images attrs
--
-- the images are often explicitly scaled based on the absolute dimensions in
-- the markdown sources, which is quite usefull when emitting beamer slides (pdf).
-- however, absolute dimensions can cause problems when generating html, as this
-- will not match the rest of the style (e.g. page width).
--
-- we are therefore temporarily using manually scaled png images for more predictable
-- results in html
-- strip also "width" from Div (div.column) to avoid column overlap on small screens
function stripImageAttrs(el)
    el.attr.attributes["scale"] = nil
    el.attr.attributes["width"] = nil
    el.attr.attributes["height"] = nil

    return el
end


return { { Div = stripImageAttrs, Image = stripImageAttrs } }

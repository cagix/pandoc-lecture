
-- strip scaling information from images attrs
--
-- the images are often explicitly scaled based using absolute dimensions in
-- the markdown sources, which is quite usefull when emitting beamer slides (pdf).
-- however, absolute dimensions can cause problems when generating html, as this
-- will not match the rest of the style (e.g. page width).
--
-- we are therefore temporarily using manually scaled png images for more predictable
-- results in html: save png at width=600px (max. 800px), downscaling is done via CSS
--
-- strip also "width" from Div (div.column) to avoid column overlap on small screens

function Image(el)
    el.attributes["scale"] = nil
    el.attributes["width"] = nil
    el.attributes["height"] = nil

    return el
end


function Div(el)
    el.attributes["width"] = nil

    return el
end

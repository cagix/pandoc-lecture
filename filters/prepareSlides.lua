
-- prepare Beamer slides:
-- (a) remove any notes Spans or Divs including content
-- (b) remove slides Spans oder Divs, but keep content
--     rationale: w/o this filter TeX content would not be processed correctly


local function prepareSlides(el)
    -- completely remove notes
    if el.classes[1] == "notes" then
        return {}
    end

    -- remove slides (Span, Div), return content
    if el.classes[1] == "slides" then
        return el.content
    end
end


function Span(el)
    return prepareSlides(el)
end


function Div(el)
    return prepareSlides(el)
end

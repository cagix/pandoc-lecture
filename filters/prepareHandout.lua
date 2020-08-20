
-- prepare HTML handouts:
-- (a) remove any slide Spans or Divs including content
-- (b) remove notes Spans oder Divs, but keep content
--     rationale: w/o this filter content would appear in generated html but not in toc


local function prepareHandout(el)
    -- completely remove slides
    if el.classes[1] == "slides" then
        return {}
    end

    -- remove notes (Span, Div), return content
    if el.classes[1] == "notes" then
        return el.content
    end
end


function Span(el)
    return prepareHandout(el)
end


function Div(el)
    return prepareHandout(el)
end


-- prepare Beamer slides:
-- (a) remove any notes Spans or Divs including content
-- (b) remove slides Spans oder Divs, but keep content
--     rationale: w/o this filter TeX content would not be processed correctly


function Span(el)
    -- completely remove inline notes: `[...]{.notes}` ... (Span class)
    if el.classes[1] == "notes" then
        return {}
    end

    -- remove inline slides span, return content: `[...]{.slides}` ... (Span class)
    if el.classes[1] == "slides" then
        return el.content
    end
end


function Div(el)
    -- completely remove block notes: `::: notes ... :::` ... (Div class)
    if el.classes[1] == "notes" then
        return {}
    end

    -- remove block slides div, return content: `::: slides ... :::` ... (Div class)
    if el.classes[1] == "slides" then
        return el.content
    end
end

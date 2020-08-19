
-- prepare HTML handouts:
-- (a) remove any slide Spans or Divs including content
-- (b) remove notes Spans oder Divs, but keep content
--     rationale: w/o this filter content would appear in generated html but not in toc


function Span(el)
    -- completely remove inline slides: `[...]{.slides}` ... (Span class)
    if el.classes[1] == "slides" then
        return {}
    end

    -- remove inline notes span, return content: `[...]{.notes}` ... (Span class)
    if el.classes[1] == "notes" then
        return el.content
    end
end


function Div(el)
    -- completely remove block slides: `::: slides ... :::` ... (Div class)
    if el.classes[1] == "slides" then
        return {}
    end

    -- remove block notes div, return content: `::: notes ... :::` ... (Div class)
    if el.classes[1] == "notes" then
        return el.content
    end
end

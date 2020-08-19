
-- add outer Span with class 'cboxcbox' to  `[...]{.cbox}` ... (Span class)
-- to actually center the centered box (Span 'cbox') ...
--
-- note: a Div with class 'center' would also work in real life, but it's not
-- an inline element like a Span ... and replacing an inline (Span) with a
-- block (Div) could show some side effects.
function Span(el)
    if el.classes[1] == "cbox" then
        return pandoc.Span(el, {class = 'cboxbox'})
    end
end

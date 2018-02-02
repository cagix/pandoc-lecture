-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- handling of `::: center ... :::`
function center(el)
    if el.classes[1] == "center" then
        return {pandoc.RawBlock("latex","\\begin{center}"), el, pandoc.RawBlock("latex","\\end{center}")}
    end
end


-- there is a Note class in Pandoc Lua ... (inline class)
function notes(el)
    return {}
end

-- remove inline notes: `[...]{.notes}` ... (Span class)
function inlineNotes(el)
    if el.classes[1] == "notes" then
        return {}
    end
end

-- remove block notes: `::: notes ... :::` ... (Div class)
function blockNotes(el)
    if el.classes[1] == "notes" then
        return {}
    end
end


return {{Div = center}, {Note = notes, Span = inlineNotes, Div = blockNotes}}


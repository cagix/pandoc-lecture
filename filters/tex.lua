-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- handling of `::: center ... :::` ... (Div class)
function center(el)
    if el.classes[1] == "center" then
        return {pandoc.RawBlock("latex","\\begin{center}"), el, pandoc.RawBlock("latex","\\end{center}")}
    end
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


-- handling of  `[...]{.alert}` ... (Span class)
function alert(el)
    if el.classes[1] == "alert" then
        local erg = el.content
        table.insert(erg, 1,      pandoc.RawInline("latex","\\alert{"))
        table.insert(erg, #erg+1, pandoc.RawInline("latex","}"))
        return erg
    end
end


-- handling of  `[...]{.bsp}` ... (Span class)
function bsp(el)
    if el.classes[1] == "bsp" then
        local erg = el.content
        table.insert(erg, 1,      pandoc.RawInline("latex","\\bsp{"))
        table.insert(erg, #erg+1, pandoc.RawInline("latex","}"))
        return erg
    end
end


-- handling of  `[...]{.cbox}` ... (Span class)
function cbox(el)
    if el.classes[1] == "cbox" then
        local erg = el.content
        table.insert(erg, 1,      pandoc.RawInline("latex","\\cboxbegin"))
        table.insert(erg, #erg+1, pandoc.RawInline("latex","\\cboxend"))
        return erg
    end
end


return {{Div = center}, {Span = inlineNotes, Div = blockNotes}, {Span = alert}, {Span = bsp}, {Span = cbox}}


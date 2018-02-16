-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- helper function to insert two string as RawInline into a table
local function insertLatexEnvInline(tab, strBegin, strEnd)
    table.insert(tab, 1, pandoc.RawInline("latex", strBegin))
    table.insert(tab, #tab + 1, pandoc.RawInline("latex", strEnd))
    return tab
end


-- handling of `::: center ... :::` ... (Div class)
function center(el)
    if el.classes[1] == "center" then
        return { pandoc.RawBlock("latex", "\\begin{center}"), el, pandoc.RawBlock("latex", "\\end{center}") }
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
        return insertLatexEnvInline(el.content, "\\alert{", "}")
    end
end


-- handling of  `[...]{.bsp}` ... (Span class)
function bsp(el)
    if el.classes[1] == "bsp" then
        return insertLatexEnvInline(el.content, "\\bsp{", "}")
    end
end


-- handling of  `[...]{.cbox}` ... (Span class)
function cbox(el)
    if el.classes[1] == "cbox" then
        return insertLatexEnvInline(el.content, "\\cboxbegin ", " \\cboxend")
    end
end


-- handling of  `[...]{.hinweis}` ... (Span class)
function hinweis(el)
    if el.classes[1] == "hinweis" then
        return insertLatexEnvInline(el.content, "\\hinweis{", "}")
    end
end


-- handling of  `[...]{.thema}` ... (Span class)
function thema(el)
    if el.classes[1] == "thema" then
        return insertLatexEnvInline(el.content, "\\thema{", "}")
    end
end


return { { Div = center }, { Span = inlineNotes, Div = blockNotes }, { Span = alert }, { Span = bsp }, { Span = cbox }, { Span = hinweis }, { Span = thema } }


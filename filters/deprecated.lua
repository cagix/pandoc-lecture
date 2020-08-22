
-- Issue a warning if users use elements that are no longer supported (spans, divs, classes, ...)

local function warning(w)
    io.stderr:write("\n\n" .. "[WARNING: ]" .. w .. "\n\n")
end


function Span(el)
    if el.classes[1] == "cbox" then
        warning("Span `cbox`: `[...]{.cbox}` is no longer supported => please use Div `cbox` instead (`::: cbox ... :::`)")
    end
end

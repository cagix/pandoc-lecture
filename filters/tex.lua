
-- pandoc's List type
local List = require 'pandoc.List'


-- LaTeX commands to be handled (matching definitions needed!)
local latexCmds = List:new({'alert', 'bsp', 'cbox', 'hinweis', 'origin', 'thema'})

-- LaTeX environments to be handled (matching definitions needed!)
local latexEnvs = List:new({'center'})


-- handle selected Spans: embed content into a RawInline with matching LaTeX command
function Span(el)
    local cmd = el.classes[1]

    -- should we handle this command?
    if latexCmds:includes(cmd) then
        local c = el.content
        c:insert(1, pandoc.RawInline("latex", "\\" .. cmd .. "{"))
        c:insert(#c + 1, pandoc.RawInline("latex", "}"))
        return c
    end
end


-- handle selected Divs: embed content into a RawBlock with matching LaTeX environment
function Div(el)
    local env = el.classes[1]

    -- should we handle this environment?
    if latexEnvs:includes(env) then
        return { pandoc.RawBlock("latex", "\\begin{" .. env .. "}"), el, pandoc.RawBlock("latex", "\\end{" .. env .. "}") }
    end
end

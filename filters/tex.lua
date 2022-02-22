
-- LaTeX commands to be handled (matching definitions needed!)
local latexCmds = pandoc.List:new {'alert', 'bsp', 'hinweis', 'origin', 'thema'}

-- LaTeX environments to be handled (matching definitions needed!)
local latexEnvs = pandoc.List:new {'cbox', 'center'}

-- handle selected Spans: embed content into a RawInline with matching LaTeX command
function Span(el)
    local cmd = el.classes[1]

    -- should we handle this command?
    if latexCmds:includes(cmd) then
        return {pandoc.RawInline("latex", "\\" .. cmd .. "{")} .. el.content .. {pandoc.RawInline("latex", "}")}
    end
end

-- handle selected Divs: embed content into a RawBlock with matching LaTeX environment
function Div(el)
    local env = el.classes[1]

    -- should we handle this environment?
    if latexEnvs:includes(env) then
        return {pandoc.RawBlock("latex", "\\begin{" .. env .. "}")} .. el.content .. {pandoc.RawBlock("latex", "\\end{" .. env .. "}")}
    end
end


-- center images without captions too (like "real" images w/ caption)
--
-- remove as a precaution a possibly existing parameter `web_width`, which
-- should only be respected in the web version.
function Image(el)
    el.attributes["web_width"] = nil

    if el.caption and #el.caption == 0 then
        return { pandoc.RawInline('latex', '\\begin{center}'), el, pandoc.RawInline('latex', '\\end{center}') }
    end
end


-- do not remove "`el`{=markdown}", convert it to raw "LaTeX" instead
-- see https://github.com/KI-Vorlesung/kitest/issues/80
function RawInline(el)
    if el.format:match 'markdown' then
        return pandoc.RawInline('latex', el.text)
    end
end

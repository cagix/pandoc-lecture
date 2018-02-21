-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- transform headers to questions
function headerToQuestion(el)
    local text = "\\myQuestion[" .. tostring(el.attributes["punkte"]) .. "]{" .. pandoc.utils.stringify(el.content) .. "}"
    local task = pandoc.RawBlock("latex", text)

    if tonumber(el.level) == 1 then
        -- Level 1 header: add extra `\clearpage`
        return { pandoc.RawBlock("latex", "\\clearpage"), task }
    else
        return task
    end
end


return { { Header = headerToQuestion } }


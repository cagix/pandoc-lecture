-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- transform headers to questions
function headerToQuestion(el)
    -- get content of header (list of inlines)
    local task = el.content

    -- add start of question to the front
    table.insert(task, 1, pandoc.RawInline("latex", "\\myQuestion[" .. tostring(el.attributes["punkte"]) .. "]{"))
    -- add end of question to the end
    table.insert(task, #task + 1, pandoc.RawInline("latex", "}"))

    -- Level 1 header: add extra `\clearpage` to front
    if tonumber(el.level) == 1 then
        table.insert(task, 1, pandoc.RawInline("latex", "\\clearpage "))
    end

    -- return result as new Para (needs to be a "block" since the header was "block")
    return pandoc.Para(task)
end


return { { Header = headerToQuestion } }


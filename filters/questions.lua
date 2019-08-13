
-- collect all questions
questions = {}


-- generate table of all question headers
function collectQuestionHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    local c = el.content

    -- collect only questions with points ...
    if p > 0 then
        table.insert(c, pandoc.Space())
        table.insert(c, pandoc.Str("(" .. p .. "P)"))
        table.insert(questions, pandoc.MetaInlines(c))
    end
end


-- set question metadata (if requested)
function setQuestionMetadata(meta)
    meta["questions"] = pandoc.MetaList(questions)

    return meta
end


return { { Header = collectQuestionHeaders }, { Meta = setQuestionMetadata } }


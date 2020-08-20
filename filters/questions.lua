
-- collect all questions
local questions = {}


-- generate table of all question headers
function collectQuestionHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    local c = el.content

    -- collect only questions with points ...
    if p > 0 then
        c:insert(pandoc.Space())
        c:insert(pandoc.Str("(" .. p .. "P)"))
        questions[#questions + 1] = pandoc.MetaInlines(c)
    end
end


-- set question metadata (if requested)
function setQuestionMetadata(meta)
    meta["questions"] = pandoc.MetaList(questions)

    return meta
end


return {
    { Header = collectQuestionHeaders },    -- First run: collect all questions
    { Meta = setQuestionMetadata }          -- Second run: add questions to metadata
}

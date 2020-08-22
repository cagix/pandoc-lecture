
-- collect all questions
local questions = {}


-- generate table of all question headers
function collectQuestionHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0

    -- collect only questions with points ...
    if p > 0 then
        questions[#questions + 1] = pandoc.MetaInlines(el.content .. {pandoc.Space(), pandoc.Str("(" .. p .. "P)")})
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

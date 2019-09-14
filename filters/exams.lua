
-- transform headers to questions
function headerToQuestion(el)
    -- only handle level 1 and level 2 headers
    local level = tonumber(el.level)
    if level ~= 1 and level ~= 2 then
        return el
    end

    -- get content of header (list of inlines)
    local task = el.content

    -- add start of question to the front
    table.insert(task, 1, pandoc.RawInline("latex", "\\myQuestion[" .. tostring(el.attributes["punkte"]) .. "]{"))
    -- add end of question to the end
    table.insert(task, #task + 1, pandoc.RawInline("latex", "}"))

    -- Level 1 header: add extra `\clearpage` to front
    if level == 1 then
        table.insert(task, 1, pandoc.RawInline("latex", "\\clearpage "))
    end

    -- return result as new Para (needs to be a "block" since the header was "block")
    return pandoc.Para(task)
end


-- transform markdown table to simple latex tabular
local function mdtabletotabular(el)
    -- returns (list of) `Block` (since `Table` is of type `Block`)

    local function addcell(tab, cell)
        -- a cell is a list of blocks, e.g.pandoc.Plain()
        for _, e in pairs(cell) do
            -- add all elements of current cell to the end
            table.insert(tab, e)
        end
        -- add `&` as end-of-cell marker for tex to the end
        table.insert(tab, pandoc.RawBlock("latex", " & "))
    end

    local function addrow(tab, row)
        -- a row is a list of cells
        for _, cell in pairs(row) do
            addcell(tab, cell)
        end
        -- the last cell of a row must not be ended by `&`, end row with newline and separator
        tab[#tab] = pandoc.RawBlock("latex", "\\\\\\hline")
    end

    -- alignments: pandoc to tex
    local align = { [pandoc.AlignDefault] = "c", [pandoc.AlignLeft] = "l", [pandoc.AlignRight] = "r", [pandoc.AlignCenter] = "c" }

    -- start of tabular
    local tabstrt = "\\begin{tabular}{" .. table.concat(el.aligns:map(function(e) return align[e] end), "|") .. "}"
    local tabular = { pandoc.RawBlock("latex", "\\rowstretch"), pandoc.RawBlock("latex", tabstrt) }

    -- create header
    addrow(tabular, el.headers)

    -- create rows
    for _, row in pairs(el.rows) do
        addrow(tabular, row)
    end
    -- the last row should end with plain linebreak
    tabular[#tabular] = pandoc.RawBlock("latex", "\\\\")

    -- end of tabular
    table.insert(tabular, pandoc.RawBlock("latex", "\\end{tabular}"))
    table.insert(tabular, pandoc.RawBlock("latex", "\\rowrelax"))

    return tabular
end


-- handling of `::: solution ... :::` ... (Div class)
function solution(el)
    if el.classes[1] == "solution" then
        -- length attribute (if available)
        local length = el.attributes["length"]

        -- if we have a length, then we need to use `\begin{solution}[length] ... \end{solution}`
        -- otherwise use just empty dummies instead
        local solbeg = length and ("\\begin{solution}[" .. length .. "]") or ""
        local solend = length and "\\end{solution}" or ""

        -- transform markdown table to simple latex tabular
        el = pandoc.walk_block(el, { Table = mdtabletotabular })

        -- return list of blocks
        return { pandoc.RawBlock("latex", "\\begin{streifenenv}"), pandoc.RawBlock("latex", solbeg), el, pandoc.RawBlock("latex", solend), pandoc.RawBlock("latex", "\\end{streifenenv}") }
    end
end


-- handling of  `[...]{.ok}` and `[...]{.nok}` inside `mc` and `choices` Div's ... (Span class)
local function mcquestion(ok, nok, row)
    return function(el)
        local function createrow(cont, str)
            -- `cont` is a list of inlines
            table.insert(cont, 1, pandoc.RawInline("latex", str))
            if row then table.insert(cont, pandoc.RawInline("latex", " \\\\[5pt] \n")) end
        end

        -- handle class `ok`
        if el.classes[1] == "ok" or el.classes[1] == "CorrectChoice" then
            createrow(el.content, ok)
        end

        -- handle class `nok`
        if el.classes[1] == "nok" or el.classes[1] == "choice" then
            createrow(el.content, nok)
        end

        return el.content
    end
end

-- handling of `::: {.mc ok="correct" nok="wrong" points="each 0.5P"} ... :::` ... (Div class)
function multiplechoice(el)
    if el.classes[1] == "mc" then

        -- start of tabular
        local tabular = { pandoc.RawBlock("latex", "\\begin{streifenenv}"), pandoc.RawBlock("latex", "\\mcstretch"), pandoc.RawBlock("latex", "\\begin{tabular}{ccp{0.82\\textwidth}}") }

        -- create header
        local ok = tostring(el.attributes["ok"]) or "true"
        local nok = tostring(el.attributes["nok"]) or "false"
        table.insert(tabular, pandoc.RawBlock("latex", "\\textbf{" .. ok .. "} & \\textbf{" .. nok .. "} \\\\"))

        -- transform entries to multiple choice questions
        local mc = mcquestion("\\wahr ", "\\falsch ", true)
        table.insert(tabular, pandoc.walk_block(el, { Span = mc }))

        -- close mc-tabular
        table.insert(tabular, pandoc.RawBlock("latex", "\\end{tabular}"))
        table.insert(tabular, pandoc.RawBlock("latex", "\\rowrelax"))

        -- handle points
        local points = tostring(el.attributes["points"]) or ""
        table.insert(tabular, pandoc.RawBlock("latex", "\\x{" .. points .. "}"))

        -- end of solution
        local points = tostring(el.attributes["points"]) or ""
        table.insert(tabular, pandoc.RawBlock("latex", "\\end{streifenenv}"))

        return tabular
    end
end


-- handling of `::: choices ... :::` and friends... (Div class)
function choices(el)
    if el.classes[1] == "choices" or
            el.classes[1] == "oneparchoices" or
            el.classes[1] == "checkboxes" or
            el.classes[1] == "oneparcheckboxes" then

        -- start of environment
        local tabular = { pandoc.RawBlock("latex", "\\begin{streifenenv}"), pandoc.RawBlock("latex", "\\begin{" .. el.classes[1] .. "}") }

        -- transform entries to multiple choice questions
        local mc = mcquestion("\\CorrectChoice ", "\\choice ", false)
        table.insert(tabular, pandoc.walk_block(el, { Span = mc }))

        -- end of environment
        table.insert(tabular, pandoc.RawBlock("latex", "\\end{" .. el.classes[1] .. "}"))
        table.insert(tabular, pandoc.RawBlock("latex", "\\end{streifenenv}"))

        return tabular
    end
end


-- handling of  `[...]{.answer}` ... (Span class)
function answer(el)
    if el.classes[1] == "answer" then
        local content = el.content
        table.insert(content, 1, pandoc.RawInline("latex", "\\x{"))
        table.insert(content, #content + 1, pandoc.RawInline("latex", "}"))
        return content
    end
end


return { { Header = headerToQuestion }, { Div = solution }, { Div = multiplechoice }, { Div = choices }, { Span = answer } }

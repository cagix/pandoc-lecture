-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- count of all points
points = 0


-- add points of headers with attributes `{punkte=42}`
function addPoints(el)
    points = points + (tonumber(el.attributes["punkte"]) or 0)
end


-- add some TeX code to headers with `{punkte=42}`
function extendHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    if p > 0 then
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.RawInline("latex","\\hfill"))
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.Str("(" .. p))
        table.insert(el.content, pandoc.Space())
        table.insert(el.content, pandoc.Str("Punkt" .. (p>1 and "e" or "") .. ")"))
    end

    return el
end


-- set `points` field in global metadata
function setPointsMetadata(meta)
    if tonumber(meta["points"]) ~= points then
        -- check expectation and real value
        io.stderr:write("\n\n" .. "Expected " .. (meta["points"] or "NO") .. " points.\n")
        io.stderr:write("Found " .. points .. " points!" .. '\n\n\n')
    end

    -- set metadata (parameter needs to be a string)
    meta["points"] = pandoc.MetaString("" .. points)

    return meta
end


return {{Header = addPoints}, {Header = extendHeaders}, {Meta = setPointsMetadata}}


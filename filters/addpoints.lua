-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- count of all points
points = 0


-- add points of headers with attributes `{punkte=42}`
function addPoints(el)
    points = points + (tonumber(el.attributes["punkte"]) or 0)
end


-- check `points` field in global metadata
function checkPoints(meta)
    if meta["points"] or points > 0 then
        if tonumber(meta["points"]) ~= points then
            -- check expectation and real value
            io.stderr:write("\n\n" .. "Expected " .. (meta["points"] or "NO") .. " points.\n")
            io.stderr:write("Found " .. points .. " points!" .. '\n\n\n')
        end
    end
end


return { { Header = addPoints }, { Meta = checkPoints } }


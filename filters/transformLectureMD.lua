
-- Rationale: This filter is to support the transformation of the teaching material. Headings
-- marked with certain classes and the blocks below them are to be converted into meta variables
-- in order to support a custom template.
--
-- 1. find all header with classes in {'tldr', 'bib', 'k1', 'k2', 'k3', 'quizzes', 'challenges'}
-- 2. collect all blocks "under" these headers and remove headers + blocks from content
-- 3. add collected blocks to metadata to allow for formatting in custom template


-- classes to be handled
local classes = pandoc.List:new {'tldr', 'bib', 'k1', 'k2', 'k3', 'quizzes', 'challenges'}

-- collect blocks for each class
local mblocks = pandoc.List:new()


--- find all headers and associated blocks
function collectBlocks(allblocks)
    local body = pandoc.List:new()
    local cls = nil
    local level = 9
    local insideHeader = false

    for _, block in ipairs(allblocks) do
        if block.t == 'Header' then
            -- see if this header's class is in classes
            if block.classes[1] and classes:includes(block.classes[1]) then
                -- header w/ class found: remove header and start "inside header scope"
                insideHeader = true
                cls = block.classes[1]
                level = block.level
                mblocks[cls] = pandoc.List:new()
            elseif block.level <= level
                -- "other" header with same or higher level found: stop former "inside header scope"
                cls = nil
                level = 9
                insideHeader = false
                body:insert(block)
            else
                if insideHeader then
                    -- we are in "inside header scope": put block to mblocks
                    mblocks[cls]:insert(block)
                else
                    -- we are not in "inside header scope":< just leave this block in document body
                    body:insert(block)
                end
            end
        elseif insideHeader then
            -- we are in "inside header scope": put block to mblocks
            mblocks[cls]:insert(block)
        else
            -- we are not in "inside header scope":< just leave this block in document body
            body:insert(block)
        end
    end

    return body
end


-- add found blocks to global metadata
function blocksToMeta(meta)
    for _, cls in ipairs(classes) do
        if mblocks[cls] then
            meta[cls] = pandoc.MetaBlocks(mblocks[cls])
        end
    end
    return meta
end


return {
    { Blocks = collectBlocks },     -- First run: find all headers and associated blocks
    { Meta =  blocksToMeta }        -- Second run: add blocks to metadata
}

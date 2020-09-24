
-- add HOME-Button
-- if MetaString/MetaInlines "home" is present, inject a block (para) containing a link to the URI in meta.home
function Pandoc(doc)
    local meta = doc.meta
    local blocks = doc.blocks

    -- meta.home is either nil, MetaString or MetaInlines
    local home = (type(meta.home) == "table" and pandoc.utils.stringify(meta.home)) or meta.home or nil
    if home then
        blocks:extend { pandoc.Para(pandoc.Link('HOME', home, 'HOME', {class = 'home-btn'})) }
    end

    return pandoc.Pandoc(blocks, meta)
end

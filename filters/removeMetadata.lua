-- Remove all metadata from document

function Pandoc(doc)
    return pandoc.Pandoc(doc.blocks)
end

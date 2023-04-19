-- Convert metadata title to (first) H1 header in document

function Pandoc(doc)
    if doc.meta.title then
        return pandoc.Pandoc({ pandoc.Header(1, doc.meta.title) } .. doc.blocks, doc.meta)
    end
end

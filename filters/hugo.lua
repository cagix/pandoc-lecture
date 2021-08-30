-- Remove TeX/LaTeX RawInlines
function RawInline(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        return {}
    end
end

-- Remove TeX/LaTeX RawBlocks
function RawBlock(el)
    if el.format:match 'tex' or el.format:match 'latex' then
        return {}
    end
end


-- Encapsulate TeX Math
function Math(el)
    if el.mathtype:match 'InlineMath' then
        return {
            pandoc.RawInline('markdown', '<span>'),
            el,
            pandoc.RawInline('markdown', '</span>')
          }
    end
    if el.mathtype:match 'DisplayMath' then
        return {
            pandoc.RawInline('markdown', '<div>'),
            el,
            pandoc.RawInline('markdown', '</div>')
          }
    end
end

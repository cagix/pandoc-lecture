
-- wrap inline code in `inlinecode` LaTeX command
function Code(el)
    return { pandoc.RawInline("latex", "\\inlinecode{"), el, pandoc.RawInline("latex", "}") }
end


-- wrap listings (code block) in `codeblock` LaTeX environment
-- set font size to "small" (default) or use attribute "size"
function CodeBlock(el)
    local size = el.attributes.size or "small"
    return { pandoc.RawBlock("latex", "\\" .. size),
             pandoc.RawBlock("latex", "\\begin{codeblock}"),
             el,
             pandoc.RawBlock("latex", "\\end{codeblock}"),
             pandoc.RawBlock("latex", "\\normalsize") }
end

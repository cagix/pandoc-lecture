
-- wrap inline code in `inlinecode` LaTeX command
function Code(el)
    return { pandoc.RawInline("latex", "\\inlinecode{"), el, pandoc.RawInline("latex", "}") }
end


-- wrap listings (code block) in `codeblock` LaTeX environment
function CodeBlock(el)
    return { pandoc.RawBlock("latex", "\\begin{codeblock}"), el, pandoc.RawBlock("latex", "\\end{codeblock}") }
end

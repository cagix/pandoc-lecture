

function center(el)
    if el.classes[1] == "center" then
        return {pandoc.RawBlock("latex","\\begin{center}"), el, pandoc.RawBlock("latex","\\end{center}")}
    end
end


return {{Div = center}}


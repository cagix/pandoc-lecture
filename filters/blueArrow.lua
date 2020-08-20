
-- helper function to create span for blue arrows
local function blueArrow()
    -- `return pandoc.Span('=> ', {class = 'blueArrow'})` would be shorter, but
    -- results in ugly space with style "blueArrow" after the blue arrow ...
    -- now the space is just in normal style and thus much smaller
    return { pandoc.Span('=>', {class = 'blueArrow'}), pandoc.Space() }
end


-- helper function (DRY)
local function isTexAndArrow(el)
    if el.format == "tex" or el.format == "latex" then
        if string.match(el.text, "\\blueArrow") then
            return true
        end
    end
    return false
end


-- handling of `\blueArrow` ... (RawInline, tex)
function Inline(el)
    if isTexAndArrow(el) then
        return blueArrow()
    end
end


-- handling of `\blueArrow` ... (RawBlock, tex)
function Block(el)
    if isTexAndArrow(el) then
        return pandoc.Plain(blueArrow())
    end
end

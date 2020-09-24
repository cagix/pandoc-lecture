
-- prepare toggle elements in HTML handouts:
-- (a) detect Divs with class "showme"
-- (b) return list of label/input to allow for toggle plus new Div with original content
-- (c) use as label text "Show me" or identifier of Div


-- count of toogles
local count = 0


function Div(el)
    if el.classes[1] == "showme" then
        local label = (el.identifier == "" and "Show me") or el.identifier
        count = count + 1

        return { pandoc.RawBlock ("html5", "<label for='toggle" .. count .."' class='toggle-btn'>" .. label .. "</label>"),
                 pandoc.RawBlock ("html5", "<input type='checkbox' id='toggle" .. count .. "' />"),
                 pandoc.Div(el.content, {class = 'expandable'}) }
    end
end

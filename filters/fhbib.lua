
-- translate ISBN links generated by citeproc
-- (needs to be run *after* citeproc)
--
-- reference to ISBN 12345 would be linked to https://worldcat.org/isbn/12345
-- my students would rather like to know availability in university library,
-- thus change generated URL to https://www.digibib.net/openurl/Bi10?isbn=12345
-- 03/2023: the URL apparently changed to https://fhb-bielefeld.digibib.net/openurl?isbn=12345 (?)
function Link(el)
    el.target = el.target:gsub("^https://worldcat.org/isbn/(%d[0-9%-]+%d)$", "https://fhb-bielefeld.digibib.net/openurl?isbn=%1")
    return el
end

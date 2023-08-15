--[[
All 'readme.md' will be transformed into '_index.md', any other Markdown file
'file.md' will be transformed into 'file/_index.md' (see 'hugo_makedeps.lua').

This filter will adapt the image sources and the link targets in a Markdown
file so that Hugo can build a web page from it.
]]--


-- local vars
local INDEX_MD = "readme"       -- name of readme.md (will be set from metadata)



-- helper
local function _is_relative (target)
    return pandoc.path.is_relative(target)
end

local function _is_markdown (target)
    return target:match('.*%.md')
end

local function _is_url (target)
    return target:match('https?://.*')
end



-- replace `![](img/b.png)` with `![](b.png)`
function Image (image)
    if _is_relative(image.src) and not _is_url(image.src) then
        image.src = pandoc.path.filename(image.src)
        return image
    end
end



--[[
Hugo's ref shortcode tries to resolve paths without a leading '/' first relative to the current page,
then to the rest of the site. As long as all pages have a _unique name_, we can also simply use the
name of the page. Index pages ('_index.md') must be referenced via their toplevel folder.

All files will be transformed during processing (see 'hugo_makedeps.lua'):
-   'subdir/file-a.md' will become 'subdir/file-a/_index.md'
-   'subdir/readme.md' will become 'subdir/_index.md'

Since "subdir" might contain something like "../", we would have to resolve this first. However, as
Hugo's ref shortcode can also resolve just the filename without a path, we can skip this effort and
just replace the path with the filename. For index files ('readme.md'), we have to extract the last
folder.

This filter need to perform for any link in any Markdown file:
-   replace  `[Y](subdir/file-a.md)`  with  `[Y]({{< ref "file-a" >}})`
-   replace  `[Y](subdir/readme.md)`  with  `[Y]({{< ref "subdir" >}})`
-   replace  `[Y](readme.md)`         with  `[Y]({{< ref "/" >}})` (might work with Hugo)

Caveats:
(a) All referenced Markdown files must have UNIQUE NAMES.
(b) References to the top index page (landing page) are (presumably) not working.
]]--
function Link (link)
    local target = link.target
    local content = pandoc.utils.stringify(link.content)

    if _is_markdown(target) and _is_relative(target) and not _is_url(target) then
        local dir = pandoc.path.split(pandoc.path.directory(target))        -- 'foo.md' => {'.'}; 'sub/foo.md' => {'sub'}; './sub/foo.md' => {'.', 'sub'};
        local name, _ = pandoc.path.split_extension(pandoc.path.filename(target))

        if name == INDEX_MD then
            target = (#dir >= 1 and dir[#dir] ~= ".") and dir[#dir] or "/"  -- readme.md: use parent folder or '/'
        else
            target = name                                                   -- ordinary file: use it's name w/o extension
        end

        return pandoc.RawInline('markdown', '[' .. content .. ']({{< ref "' .. target .. '" >}})')
    end
end



function Meta (m)
    INDEX_MD = m.indexMD or "readme"
end



return {
    { Meta = Meta },
    { Image = Image },
    { Link = Link }
}

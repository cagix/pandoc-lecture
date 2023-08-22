--[[
All 'readme.md' will be transformed into '_index.md', any other Markdown file 'file.md' will be
transformed into 'file/_index.md' (see 'hugo_makedeps.lua').

This filter will adapt the image sources (1) and the link targets (2) in a Markdown file so that
Hugo can build a web page from it.

(1) The Hugo Relearn Theme expects all resources on the same level as the '_index.md' for a page.
Thus all local images will be copied to the respective folders (via  'hugo_makedeps.lua' and some
Makefile magic). Here we just need to adjust all image sources and remove any path elements:
replace `![](img/b.png)` with `![](b.png)` for all local image files.

(2) Hugo's ref shortcode tries to resolve paths without a leading '/' first relative to the current
page, then to the rest of the site. As long as all pages have a _unique name_, we can also simply
use the name of the page. Index pages ('_index.md') must be referenced via their toplevel folder.

All files will be transformed during processing (see 'hugo_makedeps.lua'):
-   'subdir/file-a.md' will become 'subdir/file-a/_index.md'
-   'subdir/readme.md' will become 'subdir/_index.md'

Since "subdir" might contain something like "../", we would have to resolve this first. However,
as Hugo's ref shortcode can also resolve just the filename without a path, we can skip this effort
and just replace the path with the filename. For index files ('readme.md'), we have to extract the
last folder.

Thus this filter needs to perform for any link in any Markdown file:
-   replace  `[Y](subdir/file-a.md)`  with  `[Y]({{< ref "file-a" >}})`
-   replace  `[Y](subdir/readme.md)`  with  `[Y]({{< ref "subdir" >}})`
-   replace  `[Y](readme.md)`         with  `[Y]({{< ref "/" >}})` (might work with Hugo)


Usage: This filter is intended to be used with individual files that are placed either directly in
the working directory or in a subdirectory.
Examples:
    pandoc -L hugo_rewritelinks.lua -t markdown readme.md
    pandoc -L hugo_rewritelinks.lua -t markdown test/readme.md
    pandoc -L hugo_rewritelinks.lua -t markdown test/subdir/leaf/foo.md


Caveats (see 'hugo_makedeps.lua'):
(a) All referenced Markdown files must have UNIQUE NAMES.
(b) References to the top index page (landing page) are (presumably) not working.
]]--


-- vars
INDEX_MD = "readme"     -- name of the readme.md files (w/o extension)


-- helper
local function _is_local_path (path)
    return pandoc.path.is_relative(path) and    -- is relative path
           not path:match('https?://.*')        -- is not http(s)
end

local function _is_local_markdown_file_link (inline)
    return inline and
           inline.t and
           inline.t == "Link" and               -- is pandoc.Link
           inline.target:match('.*%.md') and    -- is markdown
           _is_local_path(inline.target)        -- is relative & not http(s)
end


-- filter: replace `![](img/b.png)` with `![](b.png)`
local function _fix_img_src (img)
    if _is_local_path(img.src) then
        img.src = pandoc.path.filename(img.src)
        return img
    end
end

-- filter: replace  `[Y](subdir/file-a.md)`  with  `[Y]({{< ref "file-a" >}})`
-- filter: replace  `[Y](subdir/readme.md)`  with  `[Y]({{< ref "subdir" >}})`
local function _process_links (link)
    local target = link.target
    local content = pandoc.utils.stringify(link.content)

    if _is_local_markdown_file_link(link) then
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


-- main filter function
function Pandoc (doc)
    -- name of the readme.md files (w/o extension): meta.indexMD
    INDEX_MD = doc.meta.indexMD or "readme"

    -- process all images and links
    return pandoc.Pandoc(doc.blocks:walk({ Image = _fix_img_src, Link = _process_links }), doc.meta)
end

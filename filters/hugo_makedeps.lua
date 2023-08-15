--[[
We want to transform a Markdown project layout

    |____ readme.md
    |____ img/
    | |____ a.png
    |____ subdir/
    | |____ readme.md
    | |____ img/
    | | |____ b.png
    | | |____ c.png
    | |____ file-a.md

into something that Hugo can work with:

    |____ _index.md
    |____ a.png
    |____ subdir/
    | |____ _index.md
    | |____ file-a/
    | | |___ _index.md
    | | |____ b.png
    | | |____ c.png

Side note: Technically, we convert all pages into "Branch Bundles", i.e. a 'file/_index.md'.
In general, this would not be required and we could also use "Leaf Bundles" ('file/index.md')
for normal pages. However, the Relearn theme assumes that there is an '_index.md' in _every_
folder. Therefore, we just convert all pages into branch bundles.

This will be accomplished using a Makefile like

```makefile
WEB_MARKDOWN_TARGETS =
WEB_IMAGE_TARGETS    =
WEIGHT               =

all: make.deps $$(WEB_IMAGE_TARGETS) $$(WEB_MARKDOWN_TARGETS)

make.deps: readme.md
	$(PANDOC) -L makedeps.lua -M prefix=$(TEMP_DIR) -M indexMD=$(INDEX_MD) -t markdown $< -o $@
-include make.deps

$(WEB_MARKDOWN_TARGETS):
	mkdir -p $(dir $@)
	$(PANDOC) $(PANDOC_ARGS) -L hugo_rewritelinks.lua -s -M weight=$(WEIGHT) -M indexMD=$(INDEX_MD) -M prefix=$(TEMP_DIR) $< -o $@

$(WEB_IMAGE_TARGETS):
	mkdir -p $(dir $@)
	cp $< $@
```

This filter need to build the dependency makefile containing

```makefile
## (1) all referenced files

## not referenced anywhere, but must exist as root entry
PREFIX/_index.md: readme.md
PREFIX/_index.md: WEIGHT=1
WEB_MARKDOWN_TARGETS += PREFIX/_index.md

## referenced in 'readme.md': "`[see File A](subdir/file-a.md)`"
PREFIX/subdir/file-a/_index.md: subdir/file-a.md
PREFIX/subdir/file-a/_index.md: PREFIX/subdir/file-a/b.png PREFIX/subdir/file-a/c.png
PREFIX/subdir/file-a/_index.md: WEIGHT=2
WEB_MARKDOWN_TARGETS += PREFIX/subdir/file-a/_index.md


## (2) all folders containing referenced files

## not referenced anywhere, but entry necessary because of 'subdir/file-a.md'
## weights are counted independently of the normal links (sub-landing pages)
PREFIX/subdir/_index.md: subdir/readme.md
PREFIX/subdir/_index.md: WEIGHT=3
WEB_MARKDOWN_TARGETS += PREFIX/subdir/_index.md


## (3) all referenced figures

PREFIX/a.png: img/a.png
WEB_IMAGE_TARGETS += PREFIX/a.png

PREFIX/subdir/file-a/b.png: subdir/img/b.png
WEB_IMAGE_TARGETS += PREFIX/subdir/file-a/b.png

PREFIX/subdir/file-a/c.png: subdir/img/c.png
WEB_IMAGE_TARGETS += PREFIX/subdir/file-a/c.png
```

The filter needs to look at the root Markdown file (`readme.md`) and to extract all local
images and local links to Markdown files. For each such link, this process will be repeated
(recursively, via breadth-first search).

Caveats:
(a) All referenced Markdown files must have UNIQUE NAMES.
(b) References to the top index page (landing page) are (presumably) not working.
]]--


-- vars
local img = {}                  -- list of collected images to ensure deterministic order in generated list (for testing)
local images = {}               -- set of collected images to avoid processing the same file/image several times
local link_img = {}             -- dependencies for _index.md: all referenced images

local links = {}                -- set of collected links to avoid processing the same file/link several times
local weights = {}              -- list of collected links to calculate the "weight" property for a page

local lqueue = {}               -- queue to implement breadth-first search for visiting links
local lqfirst = 0               -- first element in queue
local lqlast = -1               -- last element in queue

local PREFIX = "."              -- string to prepend to the new locations, e.g. temporary folder (will be set from metadata)
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

local function _old_path (include_path, file)
    return pandoc.path.normalize(pandoc.path.join({include_path, file}))
end

local function _new_path (include_path, parent_file, file)
    local parent = (parent_file == INDEX_MD) and "." or parent_file
    return pandoc.path.normalize(pandoc.path.join({PREFIX, include_path, parent, file}))
end

local function _new_path_idx (include_path, parent_file)
    return _new_path(include_path, parent_file, "_index.md")
end

local function _filename_woext (target)
    local name, _ = pandoc.path.split_extension(pandoc.path.filename(target))
    return name
end

local function _push (path)
    lqlast = lqlast + 1
    lqueue[lqlast] = path
end

local function _pop ()
    local path = nil
    if lqfirst <= lqlast then
        path = lqueue[lqfirst]
        lqueue[lqfirst] = nil
        lqfirst = lqfirst + 1
    end
    return path
end

local function _remember_me (md_file, include_path)
    -- remember this file
    -- => PREFIX/include_path/(md_file?)/_index.md: include_path/(md_file .. ".md")
    local oldl = _old_path(include_path, md_file .. ".md")
    local newl = _new_path_idx(include_path, md_file)

    if not links[newl] then
        weights[#weights + 1] = newl
        links[newl] = oldl
    else
        io.stderr:write("\t (_remember_me) new path '" .. newl .. "' (from '" .. oldl .. "') has been already processed ... this should not happen ... \n")
    end
end

local function _read_file (target)
    local fh = io.open(target, "r")
    if not fh then
        io.stderr:write("\t (_read_file) cannot open file '" .. target .. " ... skipping ... \n")
    else
        local content = fh:read "*all"
        fh:close()
        return pandoc.read(content, "markdown", PANDOC_READER_OPTIONS).blocks
    end
end



--[[
process Pandoc document (list of blocks):

(1) "save" link to current document, i.e. do not process this document again
(2) collect all images and all links in this document (local, relative, not HTTP, links to Markdown files)
]]
-- process document
local function process_doc (blocks, md_file, include_path)
    -- remember this file & folder
    _remember_me(md_file, include_path)

    -- collect all new images and links in this file
    local collect_images_links = {
        -- do not refactor this into separate functions as we need 'md_file' and 'include_path' as closure
        Image = function (image)
            -- collect all new images in this file
            -- => PREFIX/include_path/(md_file?)/file(img.src): include_path/img.src
            if _is_relative(image.src) and not _is_url(image.src) then
                local oldi = _old_path(include_path, image.src)
                local newi = _new_path(include_path, md_file, pandoc.path.filename(image.src))
                local newl = _new_path_idx(include_path, md_file)   -- corresponding _index.md

                if not images[newi] then
                    img[#img + 1] = newi    -- list: we want the same sequence for each run
                    images[newi] = oldi     -- set: do not store images twice
                    -- create dependency for corresponding _index.md
                    link_img[newl] = link_img[newl] and (link_img[newl] .. " " .. newi) or (newi)
                end
            end
        end,
        Link = function (link)
            -- collect all new links in this file:
            -- => PREFIX/include_path/path(link.target)/file_woe(link.target)?/_index.md: include_path/link.target
            if _is_markdown(link.target) and _is_relative(link.target) and not _is_url(link.target) then
                _push(_old_path(include_path, INDEX_MD .. ".md"))   -- need to look at "include_path/readme.md" as well
                _push(_old_path(include_path, link.target))         -- look at file "include_path/link.target"
            end
        end
    }
    blocks:walk(collect_images_links)
end



local function emit_images ()
    local inlines = pandoc.List:new()
    for _, newi in ipairs(img) do
        inlines:insert(pandoc.RawInline("markdown", newi .. ": " .. images[newi] .. "\n"))
        inlines:insert(pandoc.RawInline("markdown", "WEB_IMAGE_TARGETS += " .. newi .. "\n\n"))
    end
    return inlines
end



local function emit_links ()
    local inlines = pandoc.List:new()
    for weight, newl in ipairs(weights) do
        inlines:insert(pandoc.RawInline("markdown", newl .. ": " .. links[newl] .. "\n"))
        if link_img[newl] then
            inlines:insert(pandoc.RawInline("markdown", newl .. ": " .. link_img[newl] .. "\n"))
        end
        inlines:insert(pandoc.RawInline("markdown", newl .. ": WEIGHT=" .. weight .. "\n"))
        inlines:insert(pandoc.RawInline("markdown", "WEB_MARKDOWN_TARGETS += " .. newl .. "\n\n"))
    end
    return inlines
end


function Pandoc (doc)
    -- init global vars using metadata: meta.prefix and meta.indexMD
    PREFIX = doc.meta.prefix or "."                     -- if not set, use "." and do no harm
    INDEX_MD = doc.meta.indexMD or "readme"             -- we do need the name w/o extension

    -- landing page: process all images and links
    process_doc(doc.blocks, INDEX_MD, ".")

    -- process files recursively: breadth-first search
    local oldl = _pop()
    while oldl do
        local dir = pandoc.path.directory(oldl)
        local name = _filename_woext(oldl)
        local newl = _new_path_idx(dir, name)

        if not links[newl] then
            local blocks = _read_file(oldl)
            if blocks then process_doc(blocks, name, dir) end
        end

        oldl = _pop()
    end

    -- emit dependency makefile
    return pandoc.Pandoc({pandoc.Plain(emit_images()), pandoc.Plain(emit_links())}, doc.meta)
end

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


Usage: This filter is intended to be used with individual files that are placed directly in
the working directory.
Examples:
    pandoc -L hugo_makedeps.lua -t markdown readme.md


Credits: Work on this filter was partially inspired by some ideas shared in "include-files"
(https://github.com/pandoc/lua-filters/blob/master/include-files/include-files.lua, by Albert
Krewinkel (@tarleb), license: MIT). The 'hugo_makedeps.lua' filter has been developed by us
from scratch and is neither based on nor contains any third-party code.


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

local frontier = {}             -- queue to implement breadth-first search for visiting links
local frontier_first = 0        -- first element in queue
local frontier_last = -1        -- last element in queue
local frontier_mem = {}         -- remember all enqueued links to reduce processing time

local PREFIX = "."              -- string to prepend to the new locations, e.g. temporary folder (will be set from metadata)
local INDEX_MD = "readme"       -- name of readme.md (will be set from metadata)
local ROOT = "."                -- absolute path to working directory when starting


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

local function _prepend_include_path (path)
    local include_path = pandoc.path.make_relative(pandoc.system.get_working_directory(), ROOT)
    return pandoc.path.normalize(pandoc.path.join({include_path, path}))
end


-- queue
local function _enqueue (path)
    if not frontier_mem[path] then
        -- enqueue path
        frontier_last = frontier_last + 1
        frontier[frontier_last] = path

        -- remember this path: we don't need to enqueue this path for processing again
        frontier_mem[path] = true
    end
end

local function _dequeue ()
    local path = nil
    if frontier_first <= frontier_last then
        path = frontier[frontier_first]
        frontier[frontier_first] = nil
        frontier_first = frontier_first + 1
    end
    return path
end


-- processing of markdown files, links and images
local function _remember_file (include_path, md_file, newl)
    -- safe as PREFIX/include_path/(md_file?)/_index.md: include_path/(md_file .. ".md")
    local oldl = _old_path(include_path, md_file .. ".md")

    if not links[newl] then
        weights[#weights + 1] = newl
        links[newl] = oldl
    else
        io.stderr:write("\t (_remember_file) WARNING: new path '" .. newl .. "' (from '" .. oldl .. "') has been already processed ... THIS SHOULD NOT HAPPEN ... \n")
    end
end

local function _remember_image (include_path, md_file, image_src, newl)
    -- safe as PREFIX/include_path/(md_file?)/file(image_src): include_path/image_src
    local oldi = _old_path(include_path, image_src)
    local newi = _new_path(include_path, md_file, pandoc.path.filename(image_src))

    if not images[newi] then
        img[#img + 1] = newi    -- list: we want the same sequence for each run
        images[newi] = oldi     -- set: do not store images twice

        -- create a dependency for corresponding '_index.md'
        link_img[newl] = link_img[newl] and (link_img[newl] .. " " .. newi) or (newi)
    end
end

-- process all blocks in context of target's directory
local function _filter_blocks_in_dir (blocks, target)
    -- change into directory of 'target' to resolve potential '../' in path
    return pandoc.system.with_working_directory(
            pandoc.path.directory(target),    -- may still contain '../'
            function ()
                -- same as 'pandoc.path.directory(target)' but w/o '../' since Pandoc cd'ed here
                local target = _prepend_include_path(pandoc.path.filename(target))


                -- TODO
                local md_file = _filename_woext(target)
                local include_path = pandoc.path.make_relative(pandoc.system.get_working_directory(), ROOT)

                -- new link: PREFIX/include_path/(md_file?)/_index.md
                local newl = _new_path_idx(include_path, md_file)

                -- if not already processed:
                if not links[newl] then
                    -- remember this file
                    _remember_file(include_path, md_file, newl)

                    -- enqueue local landing page "include_path/readme.md" for later processing
                    _enqueue(_prepend_include_path(INDEX_MD .. ".md"))

                    -- collect and enqueue all new images and links in this file 'include_path/md_file'
                    local collect_images_links = {
                        Image = function (image)
                            if _is_local_path(image.src) then
                                -- remember this image
                                _remember_image(include_path, md_file, image.src, newl)
                            end
                        end,
                        Link = function (link)
                            if _is_local_markdown_file_link(link) then
                                -- enqueue "include_path/link.target" for later processing
                                _enqueue(_prepend_include_path(link.target))
                            end
                        end
                    }
                    blocks:walk(collect_images_links)
                end
            end)
end

-- open file and read content (and parse recursively and return list of blocks via '_filter_blocks_in_dir')
function _handle_file (target)
    local fh = io.open(target, "r")
    if not fh then
        io.stderr:write("\t (_handle_file) WARNING: cannot open file '" .. target .. "' ... skipping ... \n")
    else
        local blocks = pandoc.read(fh:read "*all", "markdown", PANDOC_READER_OPTIONS).blocks
        fh:close()

        _filter_blocks_in_dir(blocks, target)
    end
end


-- emit structures for make.deps
local function _emit_images ()
    local inlines = pandoc.List:new()
    for _, newi in ipairs(img) do
        inlines:insert(pandoc.RawInline("markdown", newi .. ": " .. images[newi] .. "\n"))
        inlines:insert(pandoc.RawInline("markdown", "WEB_IMAGE_TARGETS += " .. newi .. "\n\n"))
    end
    return inlines
end

local function _emit_links ()
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


-- main filter function
function Pandoc (doc)
    -- init global vars using metadata: meta.prefix and meta.indexMD
    PREFIX = doc.meta.prefix or "."                     -- if not set, use "." and do no harm
    INDEX_MD = doc.meta.indexMD or "readme"             -- we do need the name w/o extension
    ROOT = pandoc.system.get_working_directory()        -- remember our project root

    -- get filename (input file)
    local input_files = PANDOC_STATE.input_files
    local file = #input_files >= 1 and input_files[#input_files] or "."

    -- landing page: process all images and links
    _handle_file(file)

    -- process files recursively: breadth-first search
    local target = _dequeue()
    while target do
        _handle_file(target)
        target = _dequeue()
    end

    -- emit dependency makefile
    return pandoc.Pandoc({pandoc.Plain(_emit_images()), pandoc.Plain(_emit_links())}, doc.meta)
end

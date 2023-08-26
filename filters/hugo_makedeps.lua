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


Warping: When using the metadata field 'warp', the given part of the target path will be
removed (if present).
Given the example above, `pandoc -L hugo_makedeps.lua -M warp="subdir" -t markdown readme.md`
would produce instead:

```makefile
## (1) all referenced files

## not referenced anywhere, but must exist as root entry
PREFIX/_index.md: readme.md
PREFIX/_index.md: WEIGHT=1
WEB_MARKDOWN_TARGETS += PREFIX/_index.md

## referenced in 'readme.md': "`[see File A](subdir/file-a.md)`"
PREFIX/file-a/_index.md: subdir/file-a.md
PREFIX/file-a/_index.md: PREFIX/file-a/b.png PREFIX/file-a/c.png
PREFIX/file-a/_index.md: WEIGHT=2
WEB_MARKDOWN_TARGETS += PREFIX/file-a/_index.md


## (2) all folders containing referenced files

## nothing in this case, as 'subdir/readme.md' would translate to 'PREFIX/_index.md', which
## would overwrite the original 'readme.md' in the parent folder ('PREFIX/_index.md') ...


## (3) all referenced figures

PREFIX/a.png: img/a.png
WEB_IMAGE_TARGETS += PREFIX/a.png

PREFIX/file-a/b.png: subdir/img/b.png
WEB_IMAGE_TARGETS += PREFIX/file-a/b.png

PREFIX/file-a/c.png: subdir/img/c.png
WEB_IMAGE_TARGETS += PREFIX/file-a/c.png
```

In this example we "remove" the subfolder 'subfolder' from the target hierarchy. Since the readme
in this level would now overwrite the readme in the parent level, it will be skipped - as will all
files in 'subfolder' with the same name as those in the parent level! Also potential links in
'subfolder/readme.md' and other skipped files will not be analysed and considered! Subsequently,
the build with Hugo can fail as the links are still in the files but the linked-to files are missing.


Usage: This filter is intended to be used with individual files that are placed either directly
in the working directory or in a subdirectory.
Examples:
    pandoc -L hugo_makedeps.lua -t markdown readme.md
    pandoc -L hugo_makedeps.lua -t markdown subdir/leaf/readme.md


Credits: Work on this filter was partially inspired by some ideas shared in "include-files"
(https://github.com/pandoc/lua-filters/blob/master/include-files/include-files.lua, by Albert
Krewinkel (@tarleb), license: MIT). The 'hugo_makedeps.lua' filter has been developed by us
from scratch and is neither based on nor contains any third-party code.


Caveats (see 'hugo_rewritelinks.lua'):
(a) All referenced Markdown files must have UNIQUE NAMES.
(b) References to the top index page (landing page) are (presumably) not working.
(c) When warping, links in skipped files will not be analysed/considered.
]]--


-- vars
local img = {}                  -- list of collected images (new_image) to ensure deterministic order in generated list (for testing)
local images = {}               -- set of collected images (new_image:old_image) to avoid processing the same file/image several times
local link_img = {}             -- dependencies for _index.md: all referenced images (old_target:new_image)

local links = {}                -- set of collected links (old_target:new_target) to avoid processing the same file/link several times
local weights = {}              -- list of collected links (old_target) to calculate the "weight" property for a page

local frontier = {}             -- queue to implement breadth-first search for visiting links
local frontier_first = 0        -- first element in queue
local frontier_last = -1        -- last element in queue
local frontier_mem = {}         -- remember all enqueued links to reduce processing time

local INDEX_MD = "readme"       -- name of readme.md (will be set from metadata)
local PREFIX = "."              -- string to prepend to the new locations, e.g. temporary folder (will be set from metadata)
local WARP = nil                -- string to be removed from path, e.g. 'markdown'
local ROOT = "."                -- absolute path to working directory when starting
local LEVEL_STARTFILE = nil     -- remember subdir(s) of landing page/start file


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

local function _prepend_include_path (path)
    -- include path: current working directory, relative to project root
    local include_path = pandoc.path.make_relative(pandoc.system.get_working_directory(), ROOT)
    -- put everything together: include path and the given path
    return pandoc.path.normalize(pandoc.path.join({ include_path, path }))
end

local function _new_path (parent, file)
    -- append the file name of path 'parent' as last folder to the current include path
    -- when handling 'readme.md', we just get the current include path
    local parent, _ = pandoc.path.split_extension(pandoc.path.filename(parent))
    local name = (parent == INDEX_MD) and "." or parent
    local path = _prepend_include_path(name)

    -- remove folder names if requested, e.g. remove 'markdown/' from the path 'include_path/(md_file?)'
    if WARP and WARP ~= "" then
        path = path:gsub(WARP.."/", "")
    end

    -- put everything together: PREFIX, current version of 'path' and the given file name
    -- typically: 'PREFIX/include_path/(md_file?)/_index.md' for links
    -- typically: 'PREFIX/include_path/(md_file?)/file(image_src)' for images
    return pandoc.path.normalize(pandoc.path.join({ PREFIX, path, file }))
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

-- enqueue local landing page(s) of current target for later processing ("include_path/readme.md")
local function _enqueue_landingpages (target)
    -- if target = 'a/b/c/d/foo.md' and the start file was 'a/b/readme.md', we should consider only the 'c/d/' part here
    local path = pandoc.path.directory(pandoc.path.make_relative(target, LEVEL_STARTFILE))

    -- do this for all sub-folders in path, i.e. for a path 'a/b/c' enqueue 'a/b/c/readme.md', 'a/b/readme.md',
    -- and 'a/readme.md'; do not enqueue 'readme.md' to save time: the start file has been processed already
    while path ~= "." do
        _enqueue(pandoc.path.normalize(pandoc.path.join({ LEVEL_STARTFILE, path, INDEX_MD .. ".md" })))
        path = pandoc.path.directory(path)      -- removes the last directory separator and everything after
    end
end


-- store for each processed file the old and the new path
local function _remember_file (old_target, new_target)
    -- safe as PREFIX/include_path/(md_file?)/_index.md: include_path/target
    if not links[new_target] then
        weights[#weights + 1] = new_target
        links[new_target] = old_target      -- store new target as key because due to the "remove path parts" functionality the same resulting new file name can be constructed from different markdown files - we just keep the FIRST occurrence (n old_target => 1 new_target)
    end
end

-- store for each processed file the old and new image source
local function _remember_image (image_src, old_target, new_target)
    local old_image = _prepend_include_path(image_src)                          -- old src: include_path/image_src
    local new_image = _new_path(old_target, pandoc.path.filename(image_src))    -- new src: PREFIX/include_path/(md_file?)/file(image_src)

    -- safe as PREFIX/include_path/(md_file?)/file(image_src): include_path/image_src
    if not images[new_image] then
        img[#img + 1] = new_image       -- list: we want the same sequence for each run
        images[new_image] = old_image   -- store new image src as key because the same image can be referenced by different markdown files and needs to be copied in all cases to the new locations (1 old_image => n new_image)

        -- create a dependency for corresponding '_index.md'
        link_img[new_target] = link_img[new_target] and (link_img[new_target] .. " " .. new_image) or (new_image)
    end
end

-- process all blocks in context of target's directory
local function _filter_blocks_in_dir (blocks, target)
    -- change into directory of 'target' to resolve potential '../' in path
    pandoc.system.with_working_directory(
            pandoc.path.directory(target),    -- may still contain '../'
            function ()
                -- when processing the start file: remember the level of it's subdir(s) relative to project root
                -- "a/b/readme.md" => remember "a/b" to avoid trying to include 'readme.md' files above this level (except directly linked)
                if LEVEL_STARTFILE == nil then
                    LEVEL_STARTFILE = _prepend_include_path(".")
                end

                -- same as 'pandoc.path.directory(target)' but w/o '../' since Pandoc cd'ed here
                local old_target = _prepend_include_path(pandoc.path.filename(target))  -- old link: include_path/target
                local new_target = _new_path(target, "_index.md")                       -- new link: PREFIX/include_path/(md_file?)/_index.md

                -- if not already processed:
                if not links[new_target] then
                    -- remember this file (path w/o '../')
                    _remember_file(old_target, new_target)

                    -- collect and enqueue all new images and links in current file 'include_path/target'
                    blocks:walk({
                        Image = function (image)
                            if _is_local_path(image.src) then
                                _remember_image(image.src, old_target, new_target)
                            end
                        end,
                        Link = function (link)
                            if _is_local_markdown_file_link(link) then
                                local target = _prepend_include_path(link.target)
                                _enqueue_landingpages(target)
                                _enqueue(target)
                            end
                        end
                    })
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
    for _, new_image in ipairs(img) do
        local old_image = images[new_image]

        inlines:insert(pandoc.RawInline("markdown", new_image .. ": " .. old_image .. "\n"))
        inlines:insert(pandoc.RawInline("markdown", "WEB_IMAGE_TARGETS += " .. new_image .. "\n\n"))
    end
    return inlines
end

local function _emit_links ()
    local inlines = pandoc.List:new()
    for weight, new_target in ipairs(weights) do
        local old_target = links[new_target]

        inlines:insert(pandoc.RawInline("markdown", new_target .. ": " .. old_target .. "\n"))
        if link_img[new_target] then
            inlines:insert(pandoc.RawInline("markdown", new_target .. ": " .. link_img[new_target] .. "\n"))
        end
        inlines:insert(pandoc.RawInline("markdown", new_target .. ": WEIGHT=" .. weight .. "\n"))
        inlines:insert(pandoc.RawInline("markdown", "WEB_MARKDOWN_TARGETS += " .. new_target .. "\n\n"))
    end
    return inlines
end


-- main filter function
function Pandoc (doc)
    -- init global vars using metadata: meta.prefix and meta.indexMD
    INDEX_MD = doc.meta.indexMD or "readme"             -- we do need the name w/o extension
    PREFIX = doc.meta.prefix or "."                     -- if not set, use "." and do no harm
    WARP = doc.meta.warp or nil                         -- string to be removed from path, e.g. 'markdown'
    ROOT = pandoc.system.get_working_directory()        -- remember our project root

    -- get filename (input file)
    local input_files = PANDOC_STATE.input_files
    local file = #input_files >= 1 and input_files[#input_files] or "."

    -- enqueue landing page for processing
    _enqueue(_prepend_include_path(file))

    -- process files recursively: breadth-first search
    local target = _dequeue()
    while target do
        _handle_file(target)
        target = _dequeue()
    end

    -- emit dependency makefile
    return pandoc.Pandoc({ pandoc.Plain(_emit_images()), pandoc.Plain(_emit_links()) }, doc.meta)
end

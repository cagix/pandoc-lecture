--[[
include_mdfiles.lua – filter to include local Markdown files via links

for each link to local Markdown file in start document:
    (1) read file
    (2) "fix" links to local images, i.e. prepend include path
    (3) process links to local Markdown files in paragraphs and include content (recursively)
        - foreach Para:
            - prepare new empty block list (result), add new current block (empty Para)
            - foreach inline in current Para:
                - if not link: append inline to current block's content
                - if link:
                    - read link.target (file), process content and append resulting blocks to block list
                    - add new current block (empty Para) for remaining inlines of current block
            - return block list to replace current Para


Usage: This filter is intended to be used with individual files that are placed directly in
the working directory.
Examples:
    pandoc -L include_mdfiles.lua -t markdown readme.md
    pandoc -L include_mdfiles.lua -t markdown summary.md


Credits: Work on this filter was partially inspired by some ideas shared in "include-files"
(https://github.com/pandoc/lua-filters/blob/master/include-files/include-files.lua, by Albert
Krewinkel (@tarleb), license: MIT). The 'include_mdfiles.lua' filter has been developed by us
from scratch and is neither based on nor contains any third-party code.


Caveats:
The same file cannot be included more than once to avoid potential endless recursion.
]]--


-- vars
local ROOT = "."        -- absolute path to working directory when starting
local frontier = {}     -- set of collected links to avoid processing the same file/link several times


-- helper
local function _is_relative (target)
    return pandoc.path.is_relative(target)
end

local function _is_url (target)
    return target:match('https?://.*')
end

local function _is_markdown (target)
    return target:match('.*%.md')
end

local function _is_local_path (path)
    return _is_relative(path) and
           not _is_url(path)
end

local function _is_local_markdown_file_link (inline)
    return inline and
           inline.t and
           inline.t == "Link" and
           _is_markdown(inline.target) and
           _is_local_path(inline.target)
end

local function _join_path (include_path, file)
    return pandoc.path.normalize(pandoc.path.join({include_path, file}))
end


-- if not already processed, apply the filters to the blocks and return the result as a list of blocks
local function _filter_blocks (blocks, include_path, target)
    if not frontier[target] then
        -- remember this file (path w/o '../' - for this reason, this cannot be checked earlier/elsewhere)
        frontier[target] = true

        -- process this file
        return blocks:walk({
            Image = function (img)
                if _is_local_path(img.src) then
                    -- prepend current include path to image source
                    img.src = _join_path(include_path, img.src)
                    return img
                end
            end,
            Para = _include_md
        })
    else
        io.stderr:write("\t (_handle_file) WARNING: file has been included before '" .. target .. "' ... skipping ... \n")
        return pandoc.List:new()
    end
end


-- open file, read content, parse recursively and return list of blocks
local function _handle_file (lnk)
    local fh = io.open(lnk, "r")
    if not fh then
        io.stderr:write("\t (_handle_file) WARNING: cannot open file '" .. lnk .. "' ... skipping ... \n")
        return pandoc.List:new()
    else
        local blocks = pandoc.read(fh:read "*all", "markdown", PANDOC_READER_OPTIONS).blocks
        fh:close()

        return pandoc.system.with_working_directory(
            pandoc.path.directory(lnk),    -- may still contain '../'
            function ()
                -- same as 'pandoc.path.directory(lnk)' but w/o '../' since Pandoc cd'ed here
                local include_path = pandoc.path.make_relative(pandoc.system.get_working_directory(), ROOT)
                local target = _join_path(include_path, pandoc.path.filename(lnk))
                return _filter_blocks (blocks, include_path, target)
            end)
    end
end


-- to be used as a filter function for pandoc.Para: check each inline in a pandoc.Para block and
-- split this block into a list of blocks (before and after the links) and splice a list of blocks
-- for each link to a local Markdown file
function _include_md (para)
    local block_list = pandoc.List:new()
    local current_block = pandoc.Para({})
    block_list:insert(current_block)

    for _,i in ipairs(para.content) do
        if _is_local_markdown_file_link(i) then
            -- process link target
            block_list:extend(_handle_file(i.target))

            -- "close" current block and open new one for any remaining inlines in current block 'para'
            current_block = pandoc.Para({})
            block_list:insert(current_block)
        else
            -- copy inline into block content
            current_block.content:insert(i)
        end
    end

    return block_list
end


-- main filter function
function Pandoc (doc)
    -- remember our project root
    ROOT = pandoc.system.get_working_directory()

    -- process all images and links (recursively)
    return pandoc.Pandoc(doc.blocks:walk({Para = _include_md}), doc.meta)
end

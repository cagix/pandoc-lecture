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


Usage: This filter is intended to be used with individual files that are placed either directly
in the working directory or in a subdirectory.
Examples:
    pandoc -L include_mdfiles.lua -t markdown readme.md
    pandoc -L include_mdfiles.lua -t markdown subdir/leaf/readme.md


Credits: Work on this filter was partially inspired by some ideas shared in "include-files"
(https://github.com/pandoc/lua-filters/blob/master/include-files/include-files.lua, by Albert
Krewinkel (@tarleb), license: MIT). The 'include_mdfiles.lua' filter has been developed by us
from scratch and is neither based on nor contains any third-party code.


Caveats:
The same file cannot be included more than once to avoid potential endless recursion.
]]--


-- vars
local ROOT = "."        -- absolute path to working directory when starting
local frontier = {}     -- set of visited paths to avoid including the same file several times


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
    local include_path = pandoc.path.make_relative(pandoc.system.get_working_directory(), ROOT)
    return pandoc.path.normalize(pandoc.path.join({ include_path, path }))
end


-- filter: prepend current include path to image source
local function _fix_img_src (img)
    if _is_local_path(img.src) then
        img.src = _prepend_include_path(img.src)
        return img
    end
end

-- filter: process any links contained in paragraph
local function _process_links_in_para (para)
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


-- process all blocks in context of target's directory
local function _filter_blocks_in_dir (blocks, target)
    -- change into directory of 'target' to resolve potential '../' in path
    return pandoc.system.with_working_directory(
            pandoc.path.directory(target),    -- may still contain '../'
            function ()
                -- same as 'pandoc.path.directory(target)' but w/o '../' since Pandoc cd'ed here
                local target = _prepend_include_path(pandoc.path.filename(target))

                if not frontier[target] then
                    -- remember this file (path w/o '../')
                    frontier[target] = true
                    -- process this file, i.e. it's blocks
                    return blocks:walk({ Image = _fix_img_src, Para = _process_links_in_para })
                else
                    io.stderr:write("\t (_filter_blocks_in_dir) WARNING: file has been included before '" .. target .. "' ... skipping ... \n")
                    return pandoc.List:new()
                end
            end)
end

-- open file and read content (and parse recursively and return list of blocks via '_filter_blocks_in_dir')
function _handle_file (target)
    local fh = io.open(target, "r")
    if not fh then
        io.stderr:write("\t (_handle_file) WARNING: cannot open file '" .. target .. "' ... skipping ... \n")
        return pandoc.List:new()
    else
        local blocks = pandoc.read(fh:read "*all", "markdown", PANDOC_READER_OPTIONS).blocks
        fh:close()

        return _filter_blocks_in_dir(blocks, target)
    end
end


-- main filter function
function Pandoc (doc)
    -- remember our project root
    ROOT = pandoc.system.get_working_directory()

    -- get filename (input file)
    local input_files = PANDOC_STATE.input_files
    local file = #input_files >= 1 and input_files[#input_files] or "."

    -- process all images and links (recursively)
    return pandoc.Pandoc(_handle_file(file), doc.meta)
end

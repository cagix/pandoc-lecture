--[[
include-mdfiles.lua – filter to include local Markdown files via links

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
]]--


-- vars
local ROOT = "."    -- absolute path to working directory when starting


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


-- open file, read content, parse recursivly and return list of blocks
local function _handle_file (lnk)
    local fh = io.open(lnk, "r")
    if not fh then
        io.stderr:write("\t (_handle_file) cannot open file '" .. lnk .. "' ... skipping ... \n")
        return pandoc.List:new()
    else
        local content = fh:read "*all"
        fh:close()

        return pandoc.system.with_working_directory(
            pandoc.path.directory(lnk),    -- may still contain '../'
            function ()
                local wrkdir = pandoc.system.get_working_directory()    -- same as 'pandoc.path.directory(lnk)' but w/o '../' since Pandoc cd'ed here
                return process_doc(
                    pandoc.read(content, "markdown", PANDOC_READER_OPTIONS).blocks,
                    pandoc.path.make_relative(wrkdir, ROOT))
            end)
    end
end


-- process Pandoc document (list of blocks): fix image sources (prepend include path), recursive include of links
function process_doc (blocks, include_path)
    return blocks:walk({
        Image = function (img)
            if _is_local_path(img.src) then
                -- prepend current include path to image source
                img.src = _join_path(include_path, img.src)
                return img
            end
        end,
        Para = function (bl)
            local block_list = pandoc.List:new()
            local current_block = pandoc.Para({})
            block_list:insert(current_block)

            for _,i in ipairs(bl.content) do
                if _is_local_markdown_file_link(i) then
                    -- process link target
                    block_list:extend(_handle_file(i.target))

                    -- "close" current block and open new one for any remaining inlines in current block 'bl'
                    current_block = pandoc.Para({})
                    block_list:insert(current_block)
                else
                    -- copy inline into block content
                    current_block.content:insert(i)
                end
            end

            return block_list
        end
    })
end


-- main filter function
function Pandoc (doc)
    -- remember our project root
    ROOT = pandoc.system.get_working_directory()

    -- process all images and links
    return pandoc.Pandoc(process_doc(doc.blocks, "."), doc.meta)
end

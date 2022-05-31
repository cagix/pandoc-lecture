-- extract_filewise.lua
--
-- This filter will extract the title from a meta block
-- and all headings
--
-- If the file is an "_index.md" file, it is a top-level
-- topic landing page, which can be used to extract the
-- chapter-name
--
---@diagnostic disable: undefined-global
pandoc.utils = require 'pandoc.utils'
pandoc.path = require 'pandoc.path'
Blocks = {}
Skip = false

function Header(header)
	-- header level 1 is used for topics ("lexer", "parser")
	-- header level 2 is used for chapters("LL-Parsing", "LR-Parsing")
	header.level = header.level + 2
	table.insert(Blocks, header)
end

function Meta(meta)
	local input_file = PANDOC_STATE.input_files
	local input_file_as_str = pandoc.utils.stringify(input_file)
	print("Called filewise_filter for: " .. input_file_as_str)

	local split_path = pandoc.path.split(input_file_as_str)
	local path_length = 0
	for _ in pairs(split_path) do path_length = path_length + 1 end

	local directory = pandoc.path.directory(input_file_as_str)
	local file_name = pandoc.path.filename(input_file_as_str)
	local is_index = file_name == "_index.md"
	local is_index_str = pandoc.utils.stringify(is_index)

	-- "ternary operator"
	-- _index.md files are used for topmost chapter names
	local level = is_index and 1 or 2

	-- skip files with hidden attribute or no title
	if (meta.hidden ~= nil and meta.hidden == true) then
		print("Skipping file due to 'hidden' attribute")
		Skip = true
	elseif (meta.title == nil) then
		print("Skipping file due to missing title")
		Skip = true
	else
		local weight = meta.weight ~= nil and pandoc.utils.stringify(meta.weight) or "0"
		local title = meta.title ~= nil and pandoc.utils.stringify(meta.title) or "no title"
		local meta_header =
		pandoc.Header(
		level,
		title,
		{
			chapter_weight=weight,
			dir=directory,
			is_index=is_index_str
		})
		table.insert(Blocks, meta_header)
	end
end

---@diagnostic disable-next-line: unused-local
function Pandoc(doc)
	if (Skip) then
		return pandoc.Pandoc({})
	else
		return pandoc.Pandoc(Blocks)
	end
end

return {
  traverse = 'topdown',
  { Meta = Meta },
  { Header = Header},
  { Pandoc = Pandoc},
}

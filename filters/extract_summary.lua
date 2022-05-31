-- extract_summary.lua
--
---@diagnostic disable: undefined-global
--
-- This filter will take several steps to create the summary of the lecture structure
-- in the correct ordering (because processing order of the files seems to be non-deterministic
-- and generally does not represent the order of chapters in the lecture)
--
-- 1. create "buckets" based on path of the heading; this helps associating slides
-- 	  with subtopics
-- 2. collect all normal slides and store them in `slide_container` to create an
--    an association between chapter title and slides
-- 3. add _index.md in the "chapters"-key of the bucket, which corresponds to the
-- 	  parent-directory
-- 4. add chapters to the "chapters"-key of buckets
-- 5. sort chapters, based on weight (extracted from original meta-blocks)
-- 6. emit blocks according to sorted buckets (lookup in `slide_container`)

directory_buckets = {}
slide_container = {}
blocks = {}

pandoc.utils = require 'pandoc.utils'
pandoc.path = require 'pandoc.path'

function Pandoc(doc)
	local last_chapter_or_index_name = "none"

	for _,el in pairs(doc.blocks) do
		if el.t == "Header" and el.attributes.is_index == "true" then
			-- bucketing
			local split_dir =  pandoc.path.split(el.attributes.dir)
			Create_dir_buckets(split_dir,nil)

			last_chapter_or_index_name = Get_slide_container_name(el)

			Put_index(el)
		elseif el.t == "Header" and el.level == 2 then
			last_chapter_or_index_name = Get_slide_container_name(el)

			local split_dir =  pandoc.path.split(el.attributes.dir)
			Create_dir_buckets(split_dir,nil)

			Put_chapter(el)
		elseif el.t == "Header" and el.level > 2 then
			if (slide_container[last_chapter_or_index_name] == nil) then
				slide_container[last_chapter_or_index_name] = {el}
			else
				table.insert(slide_container[last_chapter_or_index_name], el)
			end
		end
	end

	Sort_bucket(directory_buckets["markdown"])
	print("----------------------EXTRACTED STRUCTURE----------------------")
	RecPrint(directory_buckets)
	print("----------------------EMITTING BLOCKS----------------------")
	Emit_blocks(directory_buckets["markdown"])

	local blocks_without_attrs = {}
	for _,b in pairs(blocks) do
		local new_block = pandoc.Header(b.level, b.content)
		table.insert(blocks_without_attrs, new_block)
	end

	return pandoc.Pandoc(blocks_without_attrs)
end

function Emit_blocks(bucket, root_level)
	-- if bucket has chapters
	-- 		iterate over chapters
	-- 		if chapter-entry is index
	-- 			emit index-block
	-- 			iterate over chapters of topic denoted by index
	-- 		if chapter-entry is chapter
	-- 			emit chapter-slides

	local level_offset = root_level ~= nil and root_level or 0

	if (bucket["chapters"] ~= nil) then
		for _, el in pairs(bucket["chapters"]) do
			if el.index ~= nil then
				local index_block = el.index
				index_block.level = index_block.level + level_offset

				local content = pandoc.utils.stringify(index_block.content)
				index_block.content = "Topic: "..content

				table.insert(blocks, el.index)
				local split_dir = pandoc.path.split(el.index.attributes.dir)

				local index_bucket = Get_bucket(split_dir, directory_buckets)
				Emit_blocks(index_bucket, level_offset + 1)
			elseif el.chapter ~= nil then
				local chapter = el.chapter
				chapter.level = chapter.level + level_offset - 1

				local slide_container_name = Get_slide_container_name(el.chapter)
				local slides = slide_container[slide_container_name]

				local content = pandoc.utils.stringify(chapter.content)
				chapter.content = "Chapter: "..content
				table.insert(blocks, chapter)

				for _,slide in pairs(slides) do
					slide.level = slide.level + level_offset - 1
					table.insert(blocks, slide)
				end
			end
		end
	end
end

function Create_dir_buckets(split_dir, parent)
	local count = 0
	for _ in pairs(split_dir) do count = count + 1 end
	if count > 0 then
		local bucket_name = split_dir[1]
		table.remove(split_dir, 1)

		local bucket = parent ~= nil and parent or directory_buckets
		if (bucket[bucket_name] == nil) then
			bucket[bucket_name] = {}
		end
		Create_dir_buckets(split_dir, bucket[bucket_name])
	end
end

function Compare_by_weight(a,b)
	return a.weight < b.weight
end

function Sort_bucket(bucket)
	if bucket == nil or bucket.chapters == nil then
		return
	end
	table.sort(bucket["chapters"], Compare_by_weight)

	for _,el in pairs(bucket) do
		if (type(el)=="table" and el.chapters ~= nil) then
			Sort_bucket(el)
		end
	end
end

function Get_bucket(split_dir, parent_bucket)
	local count = 0
	for _ in pairs(split_dir) do count = count + 1 end

	if count == 0 then
		return parent_bucket
	end

	if count > 0 then
		local bucket_name = split_dir[1]
		local bucket = parent_bucket[bucket_name]
		-- TODO: handle missing bucket

		table.remove(split_dir, 1)
		return Get_bucket(split_dir, bucket)
	end
end


function Put_index(index)
	-- put in "chapters" key of bucket "above"
	local bucket = directory_buckets
	local split_dir = pandoc.path.split(index.attributes.dir)
	local split_dir_count = 0
	for _ in pairs(split_dir) do split_dir_count = split_dir_count + 1 end
	table.remove(split_dir, split_dir_count)

	for _,el in pairs(split_dir) do
		bucket = bucket[el]
	end
	if (bucket["chapters"] == nil) then
		bucket["chapters"] = {}
	end

	local weight = index.attributes.chapter_weight
	table.insert(
	bucket["chapters"],
	{
		weight=weight,
		index=index
	})
end

function Put_chapter(chapter)
	local bucket = directory_buckets
	local split_dir = pandoc.path.split(chapter.attributes.dir)
	for _,el in pairs(split_dir) do
		bucket = bucket[el]
	end
	if (bucket["chapters"] == nil) then
		bucket["chapters"] = {}
	end

	table.insert
	(bucket["chapters"],
	{
		weight=chapter.attributes.chapter_weight,
		chapter=chapter
	})
end

function Get_slide_container_name(header)
	return header.attributes.dir .. pandoc.utils.stringify(header.content)
end

-- for debug
function RecPrint(s, l, i) -- recursive Print (structure, limit, indent)
	l = (l) or 100; i = i or "";	-- default item limit, indent string
	if (l<1) then print "ERROR: Item limit reached."; return l-1 end;
	local ts = type(s);
	if (ts ~= "table") then print (i,ts,s); return l-1 end
	print (i,ts);           -- print "table"
	for k,v in pairs(s) do  -- print "[KEY] VALUE"
		l = RecPrint(v, l, i.."\t["..tostring(k).."]");
		if (l < 0) then break end
	end
	return l
end

return {
  traverse = 'topdown',
  { Pandoc = Pandoc},
}

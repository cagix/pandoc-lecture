DIFF ?= diff --strip-trailing-cr -u
PANDOC ?= pandoc

FILES_TRANSFORM  = readme.md
FILES_MAKEDEPS1  = readme.md
FILES_MAKEDEPS2  = subdir/readme.md
FILES_MAKEDEPS3  = subdir/leaf/readme.md
FILES_INCLUDEMD1 = summary.md
FILES_INCLUDEMD2 = readme.md
FILES_INCLUDEMD3 = subdir/readme.md
FILES_INCLUDEMD4 = subdir/leaf/readme.md

LUA_REWRITELINKS = ../hugo_rewritelinks.lua
LUA_MAKEDEPS     = ../hugo_makedeps.lua
LUA_INCLUDEMD    = ../include_mdfiles.lua


test: test_rewritelinks test_makedeps test_includemd

test_rewritelinks: $(FILES_TRANSFORM)
	@$(PANDOC) -L $(LUA_REWRITELINKS) -t native $^                                                     \
	    | $(DIFF) expected_rewritelinks1.native -
	@$(PANDOC) -L $(LUA_REWRITELINKS) -M indexMD="foo" -t native $^                                    \
	    | $(DIFF) expected_rewritelinks2.native -
	@$(PANDOC) -L $(LUA_REWRITELINKS) -M indexMD="readme" -t native $^                                 \
	    | $(DIFF) expected_rewritelinks3.native -
	@$(PANDOC) -L $(LUA_REWRITELINKS) -M weight=42 -M indexMD="readme" -t native $^                    \
	    | $(DIFF) expected_rewritelinks4.native -

test_makedeps: $(FILES_MAKEDEPS1) $(FILES_MAKEDEPS2) $(FILES_MAKEDEPS3)
	@$(PANDOC) -L $(LUA_MAKEDEPS) -t native $(FILES_MAKEDEPS1)                                         \
	    | $(DIFF) expected_makedeps1.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="foo" -t native $(FILES_MAKEDEPS1)                        \
	    | $(DIFF) expected_makedeps2.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="readme" -t native $(FILES_MAKEDEPS1)                     \
	    | $(DIFF) expected_makedeps3.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M prefix="foobar" -M indexMD="readme" -t native $(FILES_MAKEDEPS1)  \
	    | $(DIFF) expected_makedeps4.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -t native $(FILES_MAKEDEPS2)                                         \
	    | $(DIFF) expected_makedeps5.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -t native $(FILES_MAKEDEPS3)                                         \
	    | $(DIFF) expected_makedeps6.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M warp="subdir" -t native $(FILES_MAKEDEPS1)                        \
	    | $(DIFF) expected_makedeps7.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M warp="leaf" -t native $(FILES_MAKEDEPS1)                          \
	    | $(DIFF) expected_makedeps8.native -

test_includemd: $(FILES_INCLUDEMD1) $(FILES_INCLUDEMD2) $(FILES_INCLUDEMD3) $(FILES_INCLUDEMD4)
	@$(PANDOC) -L $(LUA_INCLUDEMD) -t native $(FILES_INCLUDEMD1)                                       \
	    | $(DIFF) expected_inludemd1.native -
	@$(PANDOC) -L $(LUA_INCLUDEMD) -t native $(FILES_INCLUDEMD2)                                       \
	    | $(DIFF) expected_inludemd2.native -
	@$(PANDOC) -L $(LUA_INCLUDEMD) -t native $(FILES_INCLUDEMD3)                                       \
	    | $(DIFF) expected_inludemd3.native -
	@$(PANDOC) -L $(LUA_INCLUDEMD) -t native $(FILES_INCLUDEMD4)                                       \
	    | $(DIFF) expected_inludemd4.native -


expected: expected_rewritelinks1.native expected_rewritelinks2.native expected_rewritelinks3.native expected_rewritelinks4.native
expected_rewritelinks1.native: $(FILES_TRANSFORM)
	$(PANDOC) -L $(LUA_REWRITELINKS) -t native -o $@ $^
expected_rewritelinks2.native: $(FILES_TRANSFORM)
	$(PANDOC) -L $(LUA_REWRITELINKS) -M indexMD="foo" -t native -o $@ $^
expected_rewritelinks3.native: $(FILES_TRANSFORM)
	$(PANDOC) -L $(LUA_REWRITELINKS) -M indexMD="readme" -t native -o $@ $^
expected_rewritelinks4.native: $(FILES_TRANSFORM)
	$(PANDOC) -L $(LUA_REWRITELINKS) -M weight=42 -M indexMD="readme" -t native -o $@ $^

expected: expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native expected_makedeps5.native expected_makedeps6.native expected_makedeps7.native expected_makedeps8.native
expected_makedeps1.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -t native -o $@ $^
expected_makedeps2.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="foo" -t native -o $@ $^
expected_makedeps3.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="readme" -t native -o $@ $^
expected_makedeps4.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M prefix="foobar" -M indexMD="readme" -t native -o $@ $^
expected_makedeps5.native: $(FILES_MAKEDEPS2)
	$(PANDOC) -L $(LUA_MAKEDEPS) -t native -o $@ $^
expected_makedeps6.native: $(FILES_MAKEDEPS3)
	$(PANDOC) -L $(LUA_MAKEDEPS) -t native -o $@ $^
expected_makedeps7.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M warp="subdir" -t native -o $@ $^
expected_makedeps8.native: $(FILES_MAKEDEPS1)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M warp="leaf" -t native -o $@ $^

expected: expected_inludemd1.native expected_inludemd2.native expected_inludemd3.native expected_inludemd4.native
expected_inludemd1.native: $(FILES_INCLUDEMD1)
	$(PANDOC) -L $(LUA_INCLUDEMD) -t native -o $@ $^
expected_inludemd2.native: $(FILES_INCLUDEMD2)
	$(PANDOC) -L $(LUA_INCLUDEMD) -t native -o $@ $^
expected_inludemd3.native: $(FILES_INCLUDEMD3)
	$(PANDOC) -L $(LUA_INCLUDEMD) -t native -o $@ $^
expected_inludemd4.native: $(FILES_INCLUDEMD4)
	$(PANDOC) -L $(LUA_INCLUDEMD) -t native -o $@ $^


clean:
	rm -rf expected_rewritelinks1.native expected_rewritelinks2.native expected_rewritelinks3.native expected_rewritelinks4.native
	rm -rf expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native expected_makedeps5.native expected_makedeps6.native expected_makedeps7.native expected_makedeps8.native
	rm -rf expected_inludemd1.native expected_inludemd2.native expected_inludemd3.native expected_inludemd4.native

.PHONY: test test_rewritelinks test_makedeps test_includemd expected clean

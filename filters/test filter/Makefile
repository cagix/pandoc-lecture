DIFF ?= diff --strip-trailing-cr -u
PANDOC ?= pandoc

FILES_MAKEDEPS  = readme.md

LUA_MAKEDEPS     = ../hugo_makedeps.lua


test: test_makedeps

test_makedeps: $(FILES_MAKEDEPS)
	@$(PANDOC) -L $(LUA_MAKEDEPS) -t native $^                                            \
	    | $(DIFF) expected_makedeps1.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="foo" -t native $^                           \
	    | $(DIFF) expected_makedeps2.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="readme" -t native $^                        \
	    | $(DIFF) expected_makedeps3.native -
	@$(PANDOC) -L $(LUA_MAKEDEPS) -M prefix="foobar" -M indexMD="readme" -t native $^     \
	    | $(DIFF) expected_makedeps4.native -


expected: expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native
expected_makedeps1.native: $(FILES_MAKEDEPS)
	$(PANDOC) -L $(LUA_MAKEDEPS) -t native -o $@ $^
expected_makedeps2.native: $(FILES_MAKEDEPS)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="foo" -t native -o $@ $^
expected_makedeps3.native: $(FILES_MAKEDEPS)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M indexMD="readme" -t native -o $@ $^
expected_makedeps4.native: $(FILES_MAKEDEPS)
	$(PANDOC) -L $(LUA_MAKEDEPS) -M prefix="foobar" -M indexMD="readme" -t native -o $@ $^


clean:
	rm -rf expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native

.PHONY: test test_makedeps expected clean

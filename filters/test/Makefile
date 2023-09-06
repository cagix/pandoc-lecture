DIFF ?= diff --strip-trailing-cr -u
PANDOC ?= pandoc


test: test_rewritelinks test_makedeps test_includemd test_tabs test_code test_bsp test_cbox test_showme

test_rewritelinks: readme.md   expected_rewritelinks1.native expected_rewritelinks2.native expected_rewritelinks3.native expected_rewritelinks4.native expected_rewritelinks5.native
	@$(PANDOC) -L ../hugo_rewritelinks.lua -t native readme.md                                         \
	    | $(DIFF) expected_rewritelinks1.native -
	@$(PANDOC) -L ../hugo_rewritelinks.lua -M indexMD="foo" -t native readme.md                        \
	    | $(DIFF) expected_rewritelinks2.native -
	@$(PANDOC) -L ../hugo_rewritelinks.lua -M indexMD="readme" -t native readme.md                     \
	    | $(DIFF) expected_rewritelinks3.native -
	@$(PANDOC) -L ../hugo_rewritelinks.lua -M weight=42 -M indexMD="readme" -t native readme.md        \
	    | $(DIFF) expected_rewritelinks4.native -
	@$(PANDOC) -L ../hugo_rewritelinks.lua -M warp="subdir" -t native readme.md                        \
	    | $(DIFF) expected_rewritelinks5.native -

test_makedeps: readme.md subdir/readme.md subdir/leaf/readme.md   expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native expected_makedeps5.native expected_makedeps6.native expected_makedeps7.native expected_makedeps8.native
	@$(PANDOC) -L ../hugo_makedeps.lua -t native readme.md                                             \
	    | $(DIFF) expected_makedeps1.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -M indexMD="foo" -t native readme.md                            \
	    | $(DIFF) expected_makedeps2.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -M indexMD="readme" -t native readme.md                         \
	    | $(DIFF) expected_makedeps3.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -M prefix="foobar" -M indexMD="readme" -t native readme.md      \
	    | $(DIFF) expected_makedeps4.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -t native subdir/readme.md                                      \
	    | $(DIFF) expected_makedeps5.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -t native subdir/leaf/readme.md                                 \
	    | $(DIFF) expected_makedeps6.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -M warp="subdir" -t native readme.md                            \
	    | $(DIFF) expected_makedeps7.native -
	@$(PANDOC) -L ../hugo_makedeps.lua -M warp="leaf" -t native readme.md                              \
	    | $(DIFF) expected_makedeps8.native -

test_includemd: summary.md readme.md subdir/readme.md subdir/leaf/readme.md   expected_inludemd1.native expected_inludemd2.native expected_inludemd3.native expected_inludemd4.native
	@$(PANDOC) -L ../include_mdfiles.lua -t native summary.md                                          \
	    | $(DIFF) expected_inludemd1.native -
	@$(PANDOC) -L ../include_mdfiles.lua -t native readme.md                                           \
	    | $(DIFF) expected_inludemd2.native -
	@$(PANDOC) -L ../include_mdfiles.lua -t native subdir/readme.md                                    \
	    | $(DIFF) expected_inludemd3.native -
	@$(PANDOC) -L ../include_mdfiles.lua -t native subdir/leaf/readme.md                               \
	    | $(DIFF) expected_inludemd4.native -

test_tabs: tabs_plain.md tabs_group.md tabs_title.md   expected_tabs_plain.native expected_tabs_group.native expected_tabs_title.native
	@$(PANDOC) -L ../hugo.lua -t native tabs_plain.md                                                  \
	    | $(DIFF) expected_tabs_plain.native -
	@$(PANDOC) -L ../hugo.lua -t native tabs_group.md                                                  \
	    | $(DIFF) expected_tabs_group.native -
	@$(PANDOC) -L ../hugo.lua -t native tabs_title.md                                                  \
	    | $(DIFF) expected_tabs_title.native -

test_code: codeblocks.md   expected_codeblocks.native
	@$(PANDOC) -L ../hugo.lua -t native codeblocks.md                                                  \
	    | $(DIFF) expected_codeblocks.native -

test_bsp: bsp_span.md   expected_bsp_span.native
	@$(PANDOC) -L ../hugo.lua -t native bsp_span.md                                                    \
	    | $(DIFF) expected_bsp_span.native -

test_cbox: cbox_div.md   expected_cbox_div.native
	@$(PANDOC) -L ../hugo.lua -t native cbox_div.md                                                    \
	    | $(DIFF) expected_cbox_div.native -

test_showme: showme_div.md   expected_showme_div.native
	@$(PANDOC) -L ../hugo.lua -t native showme_div.md                                                    \
	    | $(DIFF) expected_showme_div.native -


expected: expected_rewritelinks1.native expected_rewritelinks2.native expected_rewritelinks3.native expected_rewritelinks4.native expected_rewritelinks5.native
expected_rewritelinks1.native: readme.md
	$(PANDOC) -L ../hugo_rewritelinks.lua -t native -o $@ $^
expected_rewritelinks2.native: readme.md
	$(PANDOC) -L ../hugo_rewritelinks.lua -M indexMD="foo" -t native -o $@ $^
expected_rewritelinks3.native: readme.md
	$(PANDOC) -L ../hugo_rewritelinks.lua -M indexMD="readme" -t native -o $@ $^
expected_rewritelinks4.native: readme.md
	$(PANDOC) -L ../hugo_rewritelinks.lua -M weight=42 -M indexMD="readme" -t native -o $@ $^
expected_rewritelinks5.native: readme.md
	$(PANDOC) -L ../hugo_rewritelinks.lua -M warp="subdir" -t native -o $@ $^

expected: expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native expected_makedeps5.native expected_makedeps6.native expected_makedeps7.native expected_makedeps8.native
expected_makedeps1.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -t native -o $@ $^
expected_makedeps2.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -M indexMD="foo" -t native -o $@ $^
expected_makedeps3.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -M indexMD="readme" -t native -o $@ $^
expected_makedeps4.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -M prefix="foobar" -M indexMD="readme" -t native -o $@ $^
expected_makedeps5.native: subdir/readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -t native -o $@ $^
expected_makedeps6.native: subdir/leaf/readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -t native -o $@ $^
expected_makedeps7.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -M warp="subdir" -t native -o $@ $^
expected_makedeps8.native: readme.md
	$(PANDOC) -L ../hugo_makedeps.lua -M warp="leaf" -t native -o $@ $^

expected: expected_inludemd1.native expected_inludemd2.native expected_inludemd3.native expected_inludemd4.native
expected_inludemd1.native: summary.md
	$(PANDOC) -L ../include_mdfiles.lua -t native -o $@ $^
expected_inludemd2.native: readme.md
	$(PANDOC) -L ../include_mdfiles.lua -t native -o $@ $^
expected_inludemd3.native: subdir/readme.md
	$(PANDOC) -L ../include_mdfiles.lua -t native -o $@ $^
expected_inludemd4.native: subdir/leaf/readme.md
	$(PANDOC) -L ../include_mdfiles.lua -t native -o $@ $^

expected: expected_tabs_plain.native expected_tabs_group.native expected_tabs_title.native
expected_tabs_plain.native: tabs_plain.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^
expected_tabs_group.native: tabs_group.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^
expected_tabs_title.native: tabs_title.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^

expected: expected_codeblocks.native
expected_codeblocks.native: codeblocks.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^

expected: expected_bsp_span.native
expected_bsp_span.native: bsp_span.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^

expected: expected_cbox_div.native
expected_cbox_div.native: cbox_div.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^

expected: expected_showme_div.native
expected_showme_div.native: showme_div.md
	$(PANDOC) -L ../hugo.lua -t native -o $@ $^


clean:
	rm -rf expected_rewritelinks1.native expected_rewritelinks2.native expected_rewritelinks3.native expected_rewritelinks4.native expected_rewritelinks5.native
	rm -rf expected_makedeps1.native expected_makedeps2.native expected_makedeps3.native expected_makedeps4.native expected_makedeps5.native expected_makedeps6.native expected_makedeps7.native expected_makedeps8.native
	rm -rf expected_inludemd1.native expected_inludemd2.native expected_inludemd3.native expected_inludemd4.native
	rm -rf expected_tabs_plain.native expected_tabs_group.native expected_tabs_title.native
	rm -rf expected_codeblocks.native
	rm -rf expected_bsp_span.native
	rm -rf expected_cbox_div.native
	rm -rf expected_showme_div.native

.PHONY: test test_rewritelinks test_makedeps test_includemd test_tabs test_code test_bsp test_cbox test_showme expected clean

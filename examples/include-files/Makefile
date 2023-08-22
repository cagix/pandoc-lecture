
.PHONY: all
## create a single file using the include-md-filter with sources in a different (sub-) folder
all:
	pandoc -L include_mdfiles.lua markdown/summary.md -s -t html -o test.html

.PHONY: clean
clean:
	rm -rf test.html

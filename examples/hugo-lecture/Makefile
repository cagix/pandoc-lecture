#################################################################################
# Makefile for building the lecture material (website and slides)
#################################################################################

## Run 'make' or 'make help' to display commonly used targets. "make slides" and
## "make web" should be the most useful targets (also, targets for individual
## files also exist but should only be used if you know what you are doing).
##
## (a) You can use the toolchain installed in the Docker image "pandoc-lecture",
##     which comes ready to use (no other dependencies).
## (b) Alternatively, you need to
##         (1) install all tools (Pandoc, Hugo, TexLive) manually to your
##             operating system, and
##         (2) clone the pandoc-lecture repo plus relearn theme locally to a
##             specific location (${HOME}/.local/share/pandoc/):
##             "git clone --depth 1 https://github.com/cagix/pandoc-lecture.git ${HOME}/.local/share/pandoc/"
##             "wget https://github.com/McShelby/hugo-theme-relearn/archive/refs/tags/${RELEARN}.tar.gz"
##             "tar -zxf ${RELEARN}.tar.gz --strip-components 1 -C ${HOME}/.local/share/pandoc/hugo/hugo-theme-relearn/"
##             (Alternatively, just use "make install_scripts_locally" using https://github.com/cagix/pandoc-lecture/)
##
## To build the mentioned Docker image or for the required packages for a native
## installation, see https://github.com/cagix/pandoc-lecture/docker.
##
## If you want to use the Docker image to build the lecture material, start the
## container interactively using "make runlocal" and run the desired Make targets
## in the interactive container shell.

## NOTE:
## The pdf slides that can be generated for certain chapters are named by taking
## the relative path of the respective source file and replacing any '/' with an
## '_' (e.g. A/B/C -> A_B_C).
## This must be reversible in order to find the prerequisites for each output
## file. Therefore, any subdirectory of the $(SRC_DIR) directory must NOT contain
## any '_'.

#--------------------------------------------------------------------------------
# Literature and other sources: Please adjust to your course!
#--------------------------------------------------------------------------------

## Readings data template
READINGS   = data/readings.yaml
BIBTEX     = example.bib

## Metadata (for Pandoc)
METADATA   = example.yaml

## Top level directory for source files
SRC_DIR    = .

## local.yaml allows to override settings in hugo.yaml
HUGO_LOCAL = $(wildcard local.yaml)

## Filename of "landing pages": usually "readme.md"
INDEX_MD   = readme
ROOT_DOC   = $(INDEX_MD).md

## String to be removed from target path, e.g. 'markdown'
WARP_DIR   =

#--------------------------------------------------------------------------------
# Tools
#--------------------------------------------------------------------------------
## Define tools to process various types of source files.
##
## Note: LaTeX needs to be called in the folder of the .tex file to be processed.
## In the rule that generates images from tex files, the variable "$<" is set to
## the current .tex file (incl. path in the working directory). Therefore, the
## working directory for the Docker container is set to the folder of the current
## .tex file. When called directly, we need to first change-dir to this folder.
PANDOC         = pandoc
HUGO           = hugo
DOT            = dot
LATEX          = cd $(dir $(realpath $<)) && latex

## Where do we find the content from https://github.com/cagix/pandoc-lecture,
## i.e. the resources for Pandoc and the themes for Hugo?
##     (a) If we run inside the Docker container or inside the GitHub action,
##         we find the files in ${XDG_DATA_HOME}/pandoc/.
##     (b) If we are running locally (native installation), we look for the
##         files at ${HOME}/.local/share/pandoc/.
## XDG_DATA_HOME can be set externally
XDG_DATA_HOME ?= $(HOME)/.local/share
PANDOC_DIRS    = --resource-path=".:$(XDG_DATA_HOME)/pandoc/:$(XDG_DATA_HOME)/pandoc/resources/"
HUGO_DIRS      = --themesDir "$(XDG_DATA_HOME)/pandoc/hugo"

## Define options for generating images from ".tex" files
LATEX_ARGS     = -shell-escape

## Define options for generating images from ".dot" files
DOT_ARGS       = -Tpng

## Define options to be used by Pandoc
PANDOC_ARGS    = --metadata-file=$(METADATA)  $(PANDOC_DIRS)

## Define options to be used by Hugo
HUGO_ARGS      = --config hugo.yaml,$(HUGO_LOCAL)  $(HUGO_DIRS)  --contentDir $(TEMP_DIR)  --destination $(WEB_OUTPUT_DIR)  --printPathWarnings #--panicOnWarning

#--------------------------------------------------------------------------------
# I/O Directories
#--------------------------------------------------------------------------------

## Top level directory for temporary files
TEMP_DIR          = temp
HUGO_TEMP_DIR     = resources
HUGO_LOCK         = .hugo_build.lock
ROOT_DEPS         = make.deps

## Output directory generated by Hugo
WEB_OUTPUT_DIR    = docs

## Output directory for generated slides
SLIDES_OUTPUT_DIR = pdf

#--------------------------------------------------------------------------------
# Helper lists
#--------------------------------------------------------------------------------

## TeX source and target files
## uncomment to convert .tex to .png
TEX_SOURCES             = $(shell find $(SRC_DIR) -type f -iname '*.tex')
TEX_TARGETS             = $(patsubst %.tex,%.png, $(TEX_SOURCES))

## Dot source and target files
## uncomment to convert .dot to .png
DOT_SOURCES             = $(shell find $(SRC_DIR) -type f -iname '*.dot')
DOT_TARGETS             = $(patsubst %.dot,%.png, $(DOT_SOURCES))

## Source and target files for slides
## NOTES:
## (1) The name for the target pdf file is generated from the relative
##     path under $(SRC_DIR) with '/' substituted by '_'.
## (2) Directories containing a '.noslides' file will not be considered for slides generation.
SLIDES_EXCLUDE_DIRS     = $(dir $(shell find $(SRC_DIR) -type f -iname '.noslides'))
SLIDES_MARKDOWN_SOURCES = $(filter-out $(addsuffix %, $(SLIDES_EXCLUDE_DIRS)), $(shell find $(SRC_DIR) -type f -iname '*.md'  ! -iname 'readme.md' ! -iname '*index.md'))
SLIDES_PDF_TARGETS      = $(addprefix $(SLIDES_OUTPUT_DIR)/,$(subst /,_, $(patsubst $(SRC_DIR)/%.md,%.pdf, $(SLIDES_MARKDOWN_SOURCES))))
## Convenience targets
SLIDES_SHORT_TARGETS    = $(patsubst $(SLIDES_OUTPUT_DIR)/%.pdf,%,$(SLIDES_PDF_TARGETS))

## Hugo: build a list of dependencies (markdown, images), fill WEB_MARKDOWN_TARGETS and WEB_IMAGE_TARGETS (and WEIGHT)
WEB_MARKDOWN_TARGETS    =
WEIGHT                  =
WEB_IMAGE_TARGETS       =

$(ROOT_DEPS): $(ROOT_DOC)
	@$(PANDOC) $(PANDOC_ARGS) -L hugo_makedeps.lua -M indexMD=$(INDEX_MD) -M prefix=$(TEMP_DIR) -M warp=$(WARP_DIR) -f markdown -t markdown $< -o $@
-include $(ROOT_DEPS)

#--------------------------------------------------------------------------------
# Secondary Expansion
#--------------------------------------------------------------------------------

## Enable secondary expansion for subsequent targets. This allows the use
## of automatic variables like '@' in the prerequisite definitions by
## expanding twice (e.g. $$(VAR)). For normal variable references (e.g.
## $(VAR)) the expansion behaviour is unchanged as the second expansion
## has no effect on an already fully expanded reference.

.SECONDEXPANSION:

#--------------------------------------------------------------------------------
# Phony Targets
#--------------------------------------------------------------------------------

.DEFAULT_GOAL:=help

##@ Helpers

## Display help
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: list_slides
list_slides: ## List available targets for individual slides
	$(foreach target,$(SLIDES_SHORT_TARGETS), $(info $(target)))
	@: ## Suppress 'Nothing to be done for ...' message

##@ Building

## Start Docker container "pandoc-lecture" into interactive shell
.PHONY: runlocal
runlocal: ## Start Docker container "pandoc-lecture" into interactive shell
	docker run  --rm -it  -v "$(shell pwd):/pandoc" -w "/pandoc"  -u "$(shell id -u):$(shell id -g)"  --entrypoint "bash"  pandoc-lecture

## Make everything
.PHONY: all
all: $(ROOT_DEPS) slides web ## Make everything

## Create all slides
.PHONY: slides
slides: $(SLIDES_PDF_TARGETS) ## Create all slides

## Generate pdf slides (shortened target name for convenience)
.PHONY: $(SLIDES_SHORT_TARGETS)
$(SLIDES_SHORT_TARGETS): $$(patsubst %,$(SLIDES_OUTPUT_DIR)/%.pdf,$$@)

## Create website
.PHONY: web
web: $$(WEB_IMAGE_TARGETS) $$(WEB_MARKDOWN_TARGETS) $(READINGS) $(HUGO_LOCAL) ## Create website
	$(HUGO) $(HUGO_ARGS)

## Create website and archive
.PHONY: web_zip
web_zip: web ## Create website and archive
	cd $(WEB_OUTPUT_DIR) && rm -rf site.zip && zip -r site.zip *

##@ Cleanup

.PHONY: clean
clean: ## Clean up intermediate files and directories
	rm -rf $(TEMP_DIR) $(HUGO_TEMP_DIR) $(HUGO_LOCK) $(READINGS) $(ROOT_DEPS)

.PHONY: distclean
distclean: clean ## Clean up all generated files and directories
	rm -rf $(SLIDES_OUTPUT_DIR) $(WEB_OUTPUT_DIR)

#--------------------------------------------------------------------------------
# File Targets
#--------------------------------------------------------------------------------

## Canned recipe for creating output folder
define create-folder
@mkdir -p $(dir $@)
endef

## Canned recipe for creating output folder and copy output file
define create-dir-and-copy
$(create-folder)
cp $< $@
endef

## Hugo: Create readings data template
$(READINGS): $(BIBTEX)
	$(PANDOC) -s -f biblatex -t markdown $< -o $@

## Aux: Create images from tex files
## uncomment to convert .tex to .png
#$(TEX_TARGETS): %.png: %.tex
#	$(LATEX) $(LATEX_ARGS) $(notdir $<)

## Aux: Create images from dot files
## uncomment to convert .dot to .png
#$(DOT_TARGETS): %.png: %.dot
#	$(DOT) $(DOT_ARGS) $< -o $@

## Hugo: Copy image files to $(TEMP_DIR)
$(WEB_IMAGE_TARGETS):
	$(create-dir-and-copy)

## Hugo: Process markdown with pandoc (preprocessing for hugo)
$(WEB_MARKDOWN_TARGETS):
	$(create-folder)
	$(PANDOC) $(PANDOC_ARGS)  -L hugo_rewritelinks.lua -s  -d relearn -M weight=$(WEIGHT) -M indexMD=$(INDEX_MD) -M warp=$(WARP_DIR) $< -o $@
#	$(PANDOC) $(PANDOC_ARGS) -d relearn -M weight=$(WEIGHT) -M indexMD=$(INDEX_MD) -M warp=$(WARP_DIR) $< -o $@

## Slides: Generate pdf slides
## Folder structure and names: path/name.md, path/<images>/, path_name.pdf
$(SLIDES_PDF_TARGETS): $$(patsubst $(SLIDES_OUTPUT_DIR)/%.pdf,$(SRC_DIR)/%.md, $$(subst _,/,$$@))
	$(create-folder)
	$(PANDOC) $(PANDOC_ARGS) -d beamer $< -o $@

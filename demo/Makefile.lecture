# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016-2018 Carsten Gips
# License: MIT



## Path to this repository (to be used as git sub-module)

DATADIR      = ..
FILTERDIR    = $(DATADIR)/filters
RESOURCEDIR  = $(DATADIR)/resources
RESOURCEPATH = .:./figs:$(DATADIR)



## Source file and lecture prefix
## either defined here (all files) or given at cmd line like `make SRC=vl02.md`

SRC         ?= $(wildcard vl*.md)
ID          ?= pm

SLIDES       = $(SRC:%.md=${ID}_%.pdf)
HTML         = $(SRC:%.md=${ID}_%.html)

TARGETDIR    = ../distr/



## Lecture options

BEAMEROPTIONS  = -f markdown -t beamer
BEAMEROPTIONS += --pdf-engine=pdflatex
BEAMEROPTIONS += --default-image-extension=pdf
BEAMEROPTIONS += -V theme:metropolis
BEAMEROPTIONS += -V themeoptions:numbering=none -V themeoptions:progressbar=foot
BEAMEROPTIONS += -V fontsize=smaller
BEAMEROPTIONS += --slide-level=2
BEAMEROPTIONS += --lua-filter=${FILTERDIR}/tex.lua
BEAMEROPTIONS += --include-in-header=${RESOURCEDIR}/beamer.tex
BEAMEROPTIONS += --data-dir=${DATADIR}
BEAMEROPTIONS += --resource-path=${RESOURCEPATH}


HTMLOPTIONS    = -f markdown -t html
HTMLOPTIONS   += --default-image-extension=png
HTMLOPTIONS   += --standalone --self-contained
HTMLOPTIONS   += --toc --toc-depth=1
HTMLOPTIONS   += --strip-comments
HTMLOPTIONS   += --lua-filter=${FILTERDIR}/html.lua
HTMLOPTIONS   += --css=${RESOURCEDIR}/html.css
# insert `<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS_CHTML-full" type="text/javascript" data-external="1"></script>`
# with data-external="1" to prevent incorporating MathJax into the generated HTML document when using --self-contained
HTMLOPTIONS   += --include-in-header=${RESOURCEDIR}/mathjaxurl.html
# use MathJax; URL points to blank dummy document to prevent incorporating MathJax into the generated HTML document when using --self-contained
HTMLOPTIONS   += --mathjax=${RESOURCEDIR}/dummy.js
HTMLOPTIONS   += --data-dir=${DATADIR}
HTMLOPTIONS   += --resource-path=${RESOURCEPATH}



## Targets

all: $(SLIDES) $(HTML)

$(SRC:.md=): %: ${ID}_%.pdf ${ID}_%.html

${ID}_%.pdf: %.md metadata.yaml
	pandoc ${BEAMEROPTIONS} -o $@ $^

${ID}_%.html: %.md metadata.yaml
	pandoc ${HTMLOPTIONS} -o $@ $^


install: $(TARGETDIR) $(SLIDES) $(HTML)
	mv ${SLIDES} $(TARGETDIR)
	mv ${HTML} $(TARGETDIR)

$(TARGETDIR):
	mkdir $@


clean:
	rm -f $(SLIDES) $(HTML)


.PHONY: all install clean





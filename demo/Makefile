# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016 Carsten Gips
# License: MIT



## Path to this repository (used as git sub-module)

PREFIX    = .pandoc/



## Source file and lecture prefix
## either defined here (all files) or given at cmd line like `make SRC=vl02.md`

SRC   ?= $(wildcard vl*.md)
ID    ?= pm

SLIDES = $(SRC:%.md=${ID}_%.pdf)
HTML   = $(SRC:%.md=${ID}_%.html)

TARGETDIR = ../distr/



## Lecture options

BEAMEROPTIONS  = -t beamer -f markdown --latex-engine=xelatex
BEAMEROPTIONS += --default-image-extension=pdf
# needs: xetex/xelatex, beamer (latex-package), metropolis (beamer-theme), fira sans und fira mono (font)
BEAMEROPTIONS += -V theme:metropolis
# needs adapted beamer template (see https://github.com/jgm/pandoc-templates/pull/211)
BEAMEROPTIONS += -V themeoptions:numbering=none -V themeoptions:progressbar=foot
BEAMEROPTIONS += -V fontsize=smaller
BEAMEROPTIONS += --standalone --slide-level=2
BEAMEROPTIONS += --filter=${PREFIX}/texnotes.py
BEAMEROPTIONS += --include-in-header=${PREFIX}/beamer.tex


HTMLOPTIONS  = -t html -f markdown
HTMLOPTIONS += --default-image-extension=png
HTMLOPTIONS += --standalone --self-contained --toc --toc-depth=1
HTMLOPTIONS += --filter=${PREFIX}/textohtml.py
HTMLOPTIONS += --include-in-header=${PREFIX}/html.css
# Mathe mit `mathml` (einzige funktionierende Variante für html; laut Doku geht mathjax nicht fuer self-contained!)
#HTMLOPTIONS += --mathml  # funktioniert mit Firefox (auch offline), aber nicht mit Chrome
#HTMLOPTIONS += --mathjax  # funktioniert mit allen Browsern, aber nicht self-contained/offline
#HTMLOPTIONS += --webtex  # sollte immer funktionieren (leichte Darstellungsfehler); beim Erstellen Online wg. Webzugriff (Beispiel: 113 KiB)
#HTMLOPTIONS += --katex  # funktioniert mit allen Browsern (auch offline); sehr langsam beim Erstellen (Online!) u. riesige HTML-Datei (Beispiel: 3.3 MiB)
HTMLOPTIONS += --mathjax=${PREFIX}/dummy.js  # insert dummy JS instead of MathJax; replace outcome with MathJax include line using sed



## Targets

all:	$(SLIDES) $(HTML)

$(SRC:.md=): %: ${ID}_%.pdf ${ID}_%.html

slides:	clean $(SLIDES)
html:	clean $(HTML)

${ID}_%.pdf:	%.md metadata.yaml
	pandoc ${BEAMEROPTIONS} -o $@ $^

${ID}_%.html: %.md metadata.yaml
	pandoc ${HTMLOPTIONS} -o $@ $^
	sed '/<script src="/s!data:application/x-javascript;base64,PCEtLQpBdXRob3I6IENhcnN0ZW4gR2lwcyA8Y2Fyc3Rlbi5naXBzQGZoLWJpZWxlZmVsZC5kZT4KQ29weXJpZ2h0OiAoYykgMjAxNiBDYXJzdGVuIEdpcHMKTGljZW5zZTogTUlUCi0tPgoKOzs7Cgo8LS0hIERPIE5PVCBDSEFOR0UgVEhJUyBGSUxFIC0tPgoK!https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML-full!' -i $@
# content in dummy.js results in '<script src="data:application/x-javascript;base64,PCEtLQpBdXRob3I6IENhcnN0ZW4gR2lwcyA8Y2Fyc3Rlbi5naXBzQGZoLWJpZWxlZmVsZC5kZT4KQ29weXJpZ2h0OiAoYykgMjAxNiBDYXJzdGVuIEdpcHMKTGljZW5zZTogTUlUCi0tPgoKOzs7Cgo8LS0hIERPIE5PVCBDSEFOR0UgVEhJUyBGSUxFIC0tPgoK" type="text/javascript"></script>' (line 47 in output)
# we need to replace this with the mathjax include line as pandoc would generate it:
# '<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML-full" type="text/javascript"></script>'
# new URL: https://github.com/jgm/pandoc/commit/8761d5775075b8a0eb12be2ded8c931156b09a18
	
	
install: $(TARGETDIR) $(SLIDES) $(HTML)
	mv ${SLIDES} $(TARGETDIR)
	mv ${HTML} $(TARGETDIR)

$(TARGETDIR):
	mkdir $@


clean:
	rm -f $(SLIDES) $(HTML)
	

.PHONY: clean





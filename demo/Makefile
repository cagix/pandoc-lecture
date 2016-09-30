# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016 Carsten Gips
# License: MIT



## Path to pandoc templates/includes and language settings

DATADIR   = /home/cagix/.pandoc/
PREFIX    = ${DATADIR}/lecture/
TEMPLATES = ${DATADIR}/templates/

LANG    = -V lang=de-DE -M lang=de-DE



## Source file and lecture prefix
## either defined here (all files) or given at cmd line like `make SRC=vl02.md`

SRC   ?= $(wildcard vl*.md)
ID    ?= pm

SLIDES = $(SRC:%.md=${ID}_%_slides.pdf)
HTML   = $(SRC:%.md=${ID}_%_handout.html)
EPUB   = $(SRC:%.md=${ID}_%_handout.epub)
PDF    = $(SRC:%.md=${ID}_%_handout.pdf)
TMP1   = __html.filled.html

TARGETDIR = ../distr/



## Lecture options

BEAMEROPTIONS  = -t beamer -f markdown --latex-engine=xelatex
BEAMEROPTIONS += --template=${TEMPLATES}/default.beamer
BEAMEROPTIONS += --default-image-extension=pdf
# needs: xetex/xelatex, beamer (latex-package), metropolis (beamer-theme), fira sans und fira mono (font)
BEAMEROPTIONS += -V theme:metropolis
# needs adapted beamer template (see https://github.com/jgm/pandoc-templates/pull/211)
BEAMEROPTIONS += -V themeoptions:numbering=none -V themeoptions:progressbar=foot
BEAMEROPTIONS += -V fontsize=smaller
BEAMEROPTIONS += --standalone --smart --slide-level=2
BEAMEROPTIONS += --filter=${PREFIX}/texnotes.py
BEAMEROPTIONS += --include-in-header=${PREFIX}/beamer.tex
BEAMEROPTIONS += ${LANG} --data-dir=${DATADIR}


PDFOPTIONS  = -f markdown --latex-engine=xelatex
PDFOPTIONS += --template=${TEMPLATES}/default.latex
PDFOPTIONS += --default-image-extension=pdf
PDFOPTIONS += -V documentclass=scrartcl -V beamerarticle
PDFOPTIONS += -V fontsize=9pt -V papersize=a4
PDFOPTIONS += -V geometry:left=1.5cm -V geometry:right=1.5cm -V geometry:top=1.5cm -V geometry:bottom=2.5cm
PDFOPTIONS += --standalone --smart --number-sections --toc --toc-depth=1
PDFOPTIONS += --include-in-header=${PREFIX}/beamer.tex
PDFOPTIONS += --include-in-header=${PREFIX}/handout.tex
#PDFOPTIONS += --listings --highlight-style=tango
PDFOPTIONS += -V colorlinks -V linkcolor=headcolor -V citecolor=headcolor -V urlcolor=headcolor  # use same color for URLs as for headers
PDFOPTIONS += ${LANG} --data-dir=${DATADIR}


HTMLOPTIONS  = -t html5 -f markdown
HTMLOPTIONS += --template=${TEMPLATES}/default.html5
HTMLOPTIONS += --default-image-extension=png
HTMLOPTIONS += --standalone --self-contained --smart --toc --toc-depth=1
HTMLOPTIONS += --filter=${PREFIX}/textohtml.py
HTMLOPTIONS += --include-in-header=${PREFIX}/html.css
# Mathe mit `mathml` (einzige funktionierende Variante für html; laut Doku geht mathjax nicht fuer self-contained!)
#HTMLOPTIONS += --mathml  # funktioniert mit Firefox (auch offline), aber nicht mit Chrome
#HTMLOPTIONS += --mathjax  # funktioniert mit allen Browsern, aber nicht self-contained/offline
#HTMLOPTIONS += --webtex  # sollte immer funktionieren (leichte Darstellungsfehler); beim Erstellen Online wg. Webzugriff (Beispiel: 113 KiB)
#HTMLOPTIONS += --katex  # funktioniert mit allen Browsern (auch offline); sehr langsam beim Erstellen (Online!) u. riesige HTML-Datei (Beispiel: 3.3 MiB)
HTMLOPTIONS += --mathjax=${PREFIX}/dummy.js  # insert dummy JS instead of MathJax; replace outcome with MathJax include line using sed
HTMLOPTIONS += ${LANG} --data-dir=${DATADIR}


EPUBOPTIONS  = -t epub3 -f html
EPUBOPTIONS += --template=${TEMPLATES}/default.epub3
EPUBOPTIONS += --default-image-extension=png
EPUBOPTIONS += --standalone --self-contained --smart
EPUBOPTIONS += --include-in-header=${PREFIX}/html.css
# https://github.com/jgm/pandoc-templates/pull/219#issuecomment-250673689
# JGM: In EPUB3, mathml is part of the spec, so we use that. In EPUB2, you can use --webtex.
# => Umweg über temporäres HTML
EPUBOPTIONS += ${LANG} --data-dir=${DATADIR}


EPUB2OPTIONS  = -t epub -f markdown
EPUB2OPTIONS += --template=${TEMPLATES}/default.epub
EPUB2OPTIONS += --default-image-extension=png
EPUB2OPTIONS += --standalone --self-contained --smart --toc --toc-depth=1
EPUB2OPTIONS += --filter=${PREFIX}/textohtml.py
EPUB2OPTIONS += --include-in-header=${PREFIX}/html.css
# https://github.com/jgm/pandoc-templates/pull/219#issuecomment-250673689
# JGM: In EPUB3, mathml is part of the spec, so we use that. In EPUB2, you can use --webtex.
EPUB2OPTIONS += --webtex  # needs online access
EPUB2OPTIONS += ${LANG} --data-dir=${DATADIR}



## Targets

all:	$(SLIDES) $(HTML) $(EPUB) $(PDF)

slides:	clean $(SLIDES)
html:	clean $(HTML)
epub:	clean $(EPUB)
pdf:	clean $(PDF)

${ID}_%_slides.pdf:	%.md
	pandoc ${BEAMEROPTIONS} -o $@ $<

${ID}_%_handout.html: %.md
	pandoc ${HTMLOPTIONS} -o $@ $<
	sed '/<script src="/s!data:application/x-javascript;base64,PCEtLQpBdXRob3I6IENhcnN0ZW4gR2lwcyA8Y2Fyc3Rlbi5naXBzQGZoLWJpZWxlZmVsZC5kZT4KQ29weXJpZ2h0OiAoYykgMjAxNiBDYXJzdGVuIEdpcHMKTGljZW5zZTogTUlUCi0tPgoKOzs7Cgo8LS0hIERPIE5PVCBDSEFOR0UgVEhJUyBGSUxFIC0tPgoK!https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML-full!' -i $@
# content in dummy.js results in '<script src="data:application/x-javascript;base64,PCEtLQpBdXRob3I6IENhcnN0ZW4gR2lwcyA8Y2Fyc3Rlbi5naXBzQGZoLWJpZWxlZmVsZC5kZT4KQ29weXJpZ2h0OiAoYykgMjAxNiBDYXJzdGVuIEdpcHMKTGljZW5zZTogTUlUCi0tPgoKOzs7Cgo8LS0hIERPIE5PVCBDSEFOR0UgVEhJUyBGSUxFIC0tPgoK" type="text/javascript"></script>' (line 47 in output)
# we need to replace this with the mathjax include line as pandoc 1.17.2 would generate it:
# '<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML-full" type="text/javascript"></script>'

${ID}_%_handout.epub: %.md
	pandoc ${HTMLOPTIONS} --webtex -o ${TMP1} $<  # needs online access
	pandoc ${EPUBOPTIONS} -o $@ ${TMP1}
	rm -f ${TMP1}
	
%.epub: %.md
	pandoc ${EPUB2OPTIONS} -o $@ $<  # needs online access

${ID}_%_handout.pdf: %.md
	pandoc ${PDFOPTIONS} -o $@ $<
	
	
install: $(TARGETDIR) $(SLIDES) $(HTML) $(EPUB) $(PDF)
	mv ${SLIDES} $(TARGETDIR)
	mv ${HTML} $(TARGETDIR)
	mv ${EPUB} $(TARGETDIR)
	mv ${PDF} $(TARGETDIR)

$(TARGETDIR):
	mkdir $@


clean:
	rm -f $(SLIDES) $(HTML) $(EPUB) $(PDF) ${TMP1}
	

.PHONY: clean





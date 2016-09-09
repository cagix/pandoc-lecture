# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016 Carsten Gips
# License: MIT



## Path to pandoc templates/includes and language settings

DATADIR = /home/cagix/.pandoc/
PREFIX  = ${DATADIR}/homework/

LANG    = -V lang=de-DE -M lang=de-DE



## Source file and lecture prefix
## either defined here (all files) or given at cmd line like `make SRC=b02.md`

SRC   ?= $(wildcard b*.md)
ID    ?= pm

PDF    = $(SRC:%.md=${ID}_%.pdf)
EVAL   = $(SRC:%.md=${ID}_%_eval.pdf)
TMP1   = __titlepage.filled.tex
TMP2   = __questions.filled.md

TARGETDIR = ../distr/



## Homework options

OPTIONS  = -f markdown --latex-engine=xelatex
OPTIONS += --default-image-extension=pdf
OPTIONS += -V documentclass=scrartcl
OPTIONS += --standalone --smart --number-sections
OPTIONS += --include-in-header=${PREFIX}/homework.tex
OPTIONS += --include-in-header=${TMP1}
OPTIONS += -V colorlinks -V linkcolor=headcolor -V citecolor=headcolor -V urlcolor=headcolor  # use same color for URLs as for headers
OPTIONS += ${LANG} --data-dir=${DATADIR}

PDFOPTIONS =  -V fontsize=10pt -V papersize=a4
PDFOPTIONS += -V geometry:left=2cm -V geometry:right=2cm -V geometry:top=2cm -V geometry:bottom=2cm
PDFOPTIONS += --filter ${PREFIX}/addpoints.py
#PDFOPTIONS += --listings --highlight-style=tango

EVALOPTIONS =  -V fontsize=9pt -V papersize=a4
EVALOPTIONS += -V geometry:left=1cm -V geometry:right=1cm -V geometry:top=1.5cm -V geometry:bottom=1.5cm



## Targets

all:	$(PDF) $(EVAL)
pdf:	clean $(PDF)
eval:	clean $(EVAL)


${ID}_%.pdf: %.md ${PREFIX}/titlepage.tex
	pandoc --standalone --filter ${PREFIX}/addpoints.py --template ${PREFIX}/titlepage.tex -o ${TMP1} $<
	pandoc ${OPTIONS} ${PDFOPTIONS} -o $@ $<
	rm -f ${TMP1}


${ID}_%_eval.pdf: %.md ${PREFIX}/titlepage.tex ${PREFIX}/evaluation.md
	pandoc --standalone --filter ${PREFIX}/addpoints.py --template ${PREFIX}/titlepage.tex -o ${TMP1} $<
	pandoc --standalone --filter ${PREFIX}/addpoints.py --template ${PREFIX}/evaluation.md -o ${TMP2} $<
	pandoc ${OPTIONS} ${EVALOPTIONS} -o $@ ${TMP2}
	rm -f ${TMP1} ${TMP2}

	
install: $(TARGETDIR) $(PDF)
	mv ${PDF} $(TARGETDIR)

$(TARGETDIR):
	mkdir $@


clean:
	rm -f $(PDF) ${EVAL} ${TMP1} ${TMP2}
	

.PHONY: clean





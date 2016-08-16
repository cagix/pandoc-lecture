

## Path to pandoc templates/includes and language settings

DATADIR = /home/cagix/.pandoc/
PREFIX  = ${DATADIR}/homework/

LANG    = -V lang=de-DE -M lang=de-DE



## Source file and lecture prefix
## either defined here (all files) or given at cmd line like `make SRC=b02.md`

SRC   ?= $(wildcard b*.md)
ID    ?= pm

PDF    = $(SRC:%.md=${ID}_%.pdf)
TMP    = __titlepage.filled.tex

TARGETDIR = ../distr/



## Homework options

PDFOPTIONS  = -f markdown --latex-engine=xelatex
PDFOPTIONS += --default-image-extension=pdf
PDFOPTIONS += -V documentclass=scrartcl
PDFOPTIONS += -V fontsize=10pt -V papersize=a4
PDFOPTIONS += -V geometry:left=2cm -V geometry:right=2cm -V geometry:top=2cm -V geometry:bottom=2.5cm
PDFOPTIONS += --standalone --smart --number-sections
PDFOPTIONS += --include-in-header=${PREFIX}/homework.tex
PDFOPTIONS += --filter ${PREFIX}/addpoints.py 
#PDFOPTIONS += --listings --highlight-style=tango
PDFOPTIONS += ${LANG} --data-dir=${DATADIR}



## Targets

all:	$(PDF) 

pdf:	clean $(PDF)


${ID}_%.pdf: %.md ${PREFIX}/titlepage.tex
	pandoc --standalone --filter ${PREFIX}/addpoints.py --template ${PREFIX}/titlepage.tex -o ${TMP} $<
	pandoc ${PDFOPTIONS} --include-in-header=${TMP} -o $@ $<
	rm -f ${TMP}

	
install: $(TARGETDIR) $(PDF) 
	mv ${PDF} $(TARGETDIR)

$(TARGETDIR):
	mkdir $@


clean:
	rm -f $(PDF) ${TMP}
	

.PHONY: clean





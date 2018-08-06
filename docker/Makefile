# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2018 Carsten Gips
# License: MIT



.PHONY: all
all: debianTexlive.df
	docker build -t debian-texlive -f debianTexlive.df .


.PHONY: clean
clean:
	docker rmi  debian-texlive


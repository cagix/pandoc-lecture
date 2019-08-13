
.PHONY: all
all: debianTexlive.df
	docker build -t debian-texlive -f debianTexlive.df .


.PHONY: clean
clean:
	docker rmi  debian-texlive


## Build linux/amd64 image for GitHub Action (default)
.PHONY: all
all:
	cd docker && make all

## Build linux/arm64 image
.PHONY: arm64
arm64:
	cd docker && make arm64


## Install Pandoc-Lecture and Hugo Relearn Theme to ${HOME}/.local/share/pandoc/ for local use
.PHONY: install_scripts_locally
install_scripts_locally:
	mkdir -p ${HOME}/.local/share/
	export XDG_DATA_HOME="${HOME}/.local/share"    && \
	sh docker/install-pandoc-lecture.sh            && \
	sh docker/install-relearn.sh


## Demo
.PHONY: demo-lecture
demo-lecture:
	cd demo && make -f Makefile.lecture all

.PHONY: demo-homework
demo-homework:
	cd demo && make -f Makefile.homework all

.PHONY: demo-exams
demo-exams:
	cd demo && make -f Makefile.exams all

.PHONY: demo-clean
demo-clean:
	cd demo && make -f Makefile.lecture  clean
	cd demo && make -f Makefile.homework clean
	cd demo && make -f Makefile.exams    clean

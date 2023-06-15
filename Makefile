## Build linux/amd64 image for GitHub Action (default)
.PHONY: all
all:
	cd docker && make -f Makefile all

## Build linux/arm64 image
.PHONY: arm64
arm64:
	cd docker && make -f Makefile arm64


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

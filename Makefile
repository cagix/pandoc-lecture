
# set to appropriate Pandoc version, or
# delete line to use docker image
PANDOC = pandoc
.EXPORT_ALL_VARIABLES: # make variables available in sub-makefiles



.PHONY: all
all: demo-lecture demo-homework demo-exams

.PHONY: clean
clean: demo-clean



.PHONY: docker
docker:
	cd docker && make all

.PHONY: docker-clean
docker-clean:
	cd docker && make clean



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

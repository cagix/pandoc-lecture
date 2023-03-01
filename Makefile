## Name the image
IMAGE = pandoc-lecture

## Build linux/amd64 image for GitHub Action (default)
.PHONY: all
all: Dockerfile
	docker build -t $(IMAGE) -f $< .

## Build linux/arm64 image
.PHONY: arm64
arm64: docker/Dockerfile.ubuntu
	docker build -t $(IMAGE) -f $< .

## Remove image
.PHONY: clean
clean:
	-docker rmi $(IMAGE)


## Start locally to shell in container
.PHONY: runlocal
runlocal:
	docker run  --rm -it  -v "$(shell pwd):/pandoc" -w "/pandoc"  -u "$(shell id -u):$(shell id -g)"  --entrypoint "bash"  $(IMAGE)


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

## Name the image
IMAGE = pandoc-lecture

## Build linux/amd64 image for GitHub Action (default)
.PHONY: all
all: amd64

## Build linux/amd64 image
.PHONY: amd64
amd64: Dockerfile
	docker build --build-arg ARCH=amd64 --no-cache -t $(IMAGE) -f $< .

## Build linux/arm64 image
.PHONY: arm64
arm64: Dockerfile
	docker build --build-arg ARCH=arm64 --no-cache -t $(IMAGE) -f $< .

## Remove image
.PHONY: clean
clean:
	-docker rmi $(IMAGE)


## Start Docker container "pandoc-lecture" into interactive shell
.PHONY: runlocal
runlocal:
	docker run  --rm -it  -v "$(shell pwd):/pandoc" -w "/pandoc"  -u "$(shell id -u):$(shell id -g)"  -e CI=true  --entrypoint "bash"  $(IMAGE)
## Where do we find the content from https://github.com/cagix/pandoc-lecture,
## i.e. the resources for Pandoc and the themes for Hugo?
##     (a) If we run inside the Docker container, the variable CI is set to
##         true and we find the files in ${XDG_DATA_HOME}/pandoc/.
##     (b) If we are running locally (native installation), then we look for
##         the contents at ${HOME}/.local/share/pandoc/.
## Note: $(CI) is a default environment variable that GitHub sets (see
## https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables)

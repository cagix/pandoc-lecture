## Name the image
IMAGE = my-first-action

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
	docker run  --rm -it  -v "$(shell pwd):/pandoc" -w "/pandoc"  --entrypoint "bash"  $(IMAGE)

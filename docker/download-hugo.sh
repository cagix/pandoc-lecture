#!/bin/sh

## Versions
export HUGO="0.114.1"
# set ARCH="amd64" or ARCH="arm64" externally

## Hugo: https://github.com/gohugoio/hugo/releases/latest/
## split into two steps: Download + Install to enable reuse in Docker and GitHub actions
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_${HUGO}_linux-${ARCH}.tar.gz

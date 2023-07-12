#!/bin/sh

## Versions
export PANDOC="3.1.5"
# set ARCH="amd64" or ARCH="arm64" externally

## Pandoc: https://github.com/jgm/pandoc/releases/latest/
## split into two steps: Download + Install to enable reuse in Docker and GitHub actions
wget https://github.com/jgm/pandoc/releases/download/${PANDOC}/pandoc-${PANDOC}-linux-${ARCH}.tar.gz

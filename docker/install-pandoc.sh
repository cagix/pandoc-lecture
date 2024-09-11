#!/bin/sh

## Versions
export PANDOC="3.4"
# set ARCH="amd64" or ARCH="arm64" externally
export ARCH="${ARCH:-amd64}"  # if not set, use 'amd64' as default

## Pandoc: https://github.com/jgm/pandoc/releases/latest/
wget https://github.com/jgm/pandoc/releases/download/${PANDOC}/pandoc-${PANDOC}-linux-${ARCH}.tar.gz

tar -zxf pandoc-*.tar.gz --strip-components 1 -C /usr/local/
rm pandoc-*.tar.gz

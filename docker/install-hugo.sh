#!/bin/sh

## Versions
export HUGO="0.119.0"
# set ARCH="amd64" or ARCH="arm64" externally
export ARCH="${ARCH:-amd64}"  # if not set, use 'amd64' as default

## Hugo: https://github.com/gohugoio/hugo/releases/latest/
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_${HUGO}_linux-${ARCH}.tar.gz

tar -zxf hugo_*.tar.gz -C /usr/local/bin/
rm hugo_*.tar.gz

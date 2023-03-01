#!/bin/sh


## graphviz (dot)
apk --no-cache add make bash zip graphviz ghostscript font-noto


## Hugo: https://github.com/gohugoio/hugo/releases/latest/
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_${HUGO}_linux-${ARCH}.tar.gz && tar -zxf hugo_*.tar.gz -C /usr/local/bin/ && rm hugo_*.tar.gz

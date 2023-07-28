#!/bin/sh

## Versions
export RELEARN="5.18.0"
# set XDG_DATA_HOME externally

## Hugo Relearn Theme: https://github.com/McShelby/hugo-theme-relearn/releases/latest/
wget https://github.com/McShelby/hugo-theme-relearn/archive/refs/tags/${RELEARN}.tar.gz

if [ ! -d ${XDG_DATA_HOME}/pandoc/hugo/ ]; then
    echo "checkout github.com/cagix/pandoc-lecture to ${XDG_DATA_HOME}/pandoc/ first! bailing out."
    exit 1
else
    tar -zxf ${RELEARN}.tar.gz --strip-components 1 -C ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/
    rm ${RELEARN}.tar.gz
fi

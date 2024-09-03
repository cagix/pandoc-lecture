#!/bin/sh

## Versions
export RELEARN="6.3.0"
# set XDG_DATA_HOME externally

## Hugo Relearn Theme: https://github.com/McShelby/hugo-theme-relearn/releases/latest/
# stopped working, see #157
#wget https://github.com/McShelby/hugo-theme-relearn/archive/refs/tags/${RELEARN}.tar.gz

if [ ! -d ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/ ]; then
    echo "checkout github.com/cagix/pandoc-lecture to ${XDG_DATA_HOME}/pandoc/ first! bailing out."
    exit 1
else
    # remove placeholder directory
    rm -rf ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/
    # clone theme
    git clone  --depth 1  --branch ${RELEARN}  https://github.com/McShelby/hugo-theme-relearn.git  ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/
    # remove .git/ folder after cloning
    rm -rf ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/.git/
fi

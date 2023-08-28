#!/bin/sh

## Versions
# set XDG_DATA_HOME externally

## Pandoc-Lecture: https://github.com/cagix/pandoc-lecture.git
git clone  --depth 1  https://github.com/cagix/pandoc-lecture.git  ${XDG_DATA_HOME}/pandoc/

# remove .git/ folder after cloning
rm -rf ${XDG_DATA_HOME}/pandoc/.git/

#!/bin/sh


## Pandoc-Lecture: https://github.com/cagix/pandoc-lecture.git
## (TODO: replace "git clone" w/ "wget release artefact")
git clone  --depth 1  https://github.com/cagix/pandoc-lecture.git  ${XDG_DATA_HOME}/pandoc/
cd ${XDG_DATA_HOME}/pandoc/  &&  rm -rf .git demo/ docker/


## Hugo Relearn Theme: https://github.com/McShelby/hugo-theme-relearn/releases/latest/
wget https://github.com/McShelby/hugo-theme-relearn/archive/refs/tags/${RELEARN}.tar.gz && tar -zxf hugo-theme-relearn-*.tar.gz --strip-components 1 -C ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/ && rm hugo-theme-relearn-*.tar.gz

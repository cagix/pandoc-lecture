#!/bin/sh


## Pandoc-Lecture
## (TODO: replace "git checkout" w/ "wget release artefact")
mkdir -p ${XDG_DATA_HOME}
git clone  --depth 1  https://github.com/cagix/pandoc-lecture.git  ${XDG_DATA_HOME}/pandoc/
cd ${XDG_DATA_HOME}/pandoc/  &&  rm -rf .git demo/ docker/


## Hugo Relearn Theme: https://github.com/McShelby/hugo-theme-relearn/releases/latest/
mkdir -p ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn
wget https://github.com/McShelby/hugo-theme-relearn/archive/refs/tags/${RELEARN}.tar.gz && tar -zxf hugo-theme-relearn-*.tar.gz --strip-components 1 -C ${XDG_DATA_HOME}/pandoc/hugo/hugo-theme-relearn/ && rm hugo-theme-relearn-*.tar.gz

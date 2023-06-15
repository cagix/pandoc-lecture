#!/bin/sh

## packages: https://tex.stackexchange.com/questions/245982/differences-between-texlive-packages-in-linux
## see https://pandoc.org/MANUAL.html#creating-a-pdf
## see https://github.com/Wandmalfarbe/pandoc-latex-template#texlive

## TexLive (extra packages)
apt-get update
apt-get install -y texlive-fonts-extra texlive-science
rm -rf /var/lib/apt/lists/*

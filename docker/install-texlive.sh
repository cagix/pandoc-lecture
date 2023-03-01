#!/bin/sh


## Download install-tl perl script (see https://tug.org/texlive/acquire-netinstall.html)
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
mkdir -p ./install-tl
tar --strip-components 1 -zxf install-tl-unx.tar.gz -C "$PWD/install-tl"


## Run the default installation with the our minimal profile
./install-tl/install-tl --profile=/root/texlive.profile


## Update TeX Live Manager
tlmgr update --self


## Cleanup installation artifacts
rm -rf ./install-tl ./install-tl-unx.tar.gz             \
       /opt/texlive/texdir/texmf-dist/doc               \
       /opt/texlive/texdir/readme-html.dir              \
       /opt/texlive/texdir/readme-txt.dir               \
       /opt/texlive/texdir/install-tl*

#!/bin/sh


## Install extra packages for Beamer/Metropolis
tlmgr install beamertheme-metropolis                \
              pgfopts                               \
              tcolorbox                             \
              environ                               \
              tikzfill


## Install extra packages for LaTeX conversion to .png
tlmgr install standalone                            \
              filemod                               \
              currfile                              \
              mathtools                             \
              gincltex                              \
              svn-prov                              \
              adjustbox                             \
              collectbox


## Install extra packages needed for Eisvogel template,
## cleanthesis style and pandoc-lecture
## trial and error: not included in pandoc/extra Docker image
tlmgr install xpatch                                \
              cleanthesis                           \
              exam                                  \
              blindtext                             \
              charter                               \
              helvetic

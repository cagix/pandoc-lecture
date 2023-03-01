#!/bin/sh


## Install packages needed by Pandoc
## see https://pandoc.org/MANUAL.html#creating-a-pdf ... plus some trial and error
## (already included in pandoc/extra Docker image)
tlmgr install amsfonts                              \
              amsmath                               \
              lm                                    \
              lm-math                               \
              unicode-math                          \
              iftex                                 \
              listings                              \
              fancyvrb                              \
              tools                                 \
              booktabs                              \
              graphics                              \
              hyperref                              \
              xcolor                                \
              ulem                                  \
              geometry                              \
              setspace                              \
              babel                                 \
              fontspec                              \
              selnolig                              \
              bidi                                  \
              mathspec                              \
              upquote                               \
              microtype                             \
              csquotes                              \
              natbib                                \
              biblatex                              \
              bibtex                                \
              biber                                 \
              parskip                               \
              xurl                                  \
              bookmark                              \
              footnotehyper                         \
              oberdiek                              \
              pdftexcmds                            \
              beamer                                \
              caption                               \
              cmap                                  \
              euler                                 \
              eurosym                               \
              logreq                                \
              memoir                                \
              multirow                              \
              pdflscape                             \
              pgf                                   \
              framed                                \
              embedfile                             \
              ifmtarg                               \
              babel-english                         \
              babel-german                          \
              hyphen-english                        \
              hyphen-german                         \
              soul                                  \
              etoolbox                              \
              trimspaces


## Install extra packages needed for Eisvogel template
## see https://github.com/Wandmalfarbe/pandoc-latex-template#texlive ... plus a _lot_ of trial and error :/
## (already included in pandoc/extra Docker image)
tlmgr install abstract                              \
              adjustbox                             \
              awesomebox                            \
              babel-german                          \
              background                            \
              bidi                                  \
              catchfile                             \
              collectbox                            \
              csquotes                              \
              enumitem                              \
              environ                               \
              epstopdf                              \
              etoolbox                              \
              everypage                             \
              filehook                              \
              fontawesome5                          \
              footmisc                              \
              footnotebackref                       \
              framed                                \
              fvextra                               \
              hardwrap                              \
              incgraph                              \
              letltxmacro                           \
              lineno                                \
              listingsutf8                          \
              ly1                                   \
              koma-script                           \
              mdframed                              \
              mweights                              \
              needspace                             \
              pagecolor                             \
              pgf                                   \
              sectsty                               \
              sourcecodepro                         \
              sourcesanspro                         \
              tcolorbox                             \
              titlesec                              \
              titling                               \
              transparent                           \
              trimspaces                            \
              ucharcat                              \
              ulem                                  \
              unicode-math                          \
              upquote                               \
              xecjk                                 \
              xurl                                  \
              zref

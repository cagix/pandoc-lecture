#!/bin/sh


## Ubuntu: base packages
apt-get -q --no-allow-insecure-repositories update              \
    && apt-get install --assume-yes --no-install-recommends     \
        software-properties-common                              \
        ca-certificates                                         \
        build-essential                                         \
        bash                                                    \
        librsvg2-bin                                            \
        libfreetype6                                            \
        fontconfig                                              \
        gnupg                                                   \
        gzip                                                    \
        perl                                                    \
        tar                                                     \
        wget                                                    \
        xzdec                                                   \
    && rm -rf /var/lib/apt/lists/*


## graphviz (dot)
apt-get -q --no-allow-insecure-repositories update              \
    && apt-get install --assume-yes --no-install-recommends     \
        git                                                     \
        make                                                    \
        bash                                                    \
        zip                                                     \
        graphviz                                                \
        ghostscript                                             \
        fonts-noto-core                                         \
    && rm -rf /var/lib/apt/lists/*


## Hugo: https://github.com/gohugoio/hugo/releases/latest/
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_${HUGO}_linux-${ARCH}.tar.gz && tar -zxf hugo_*.tar.gz -C /usr/local/bin/ && rm hugo_*.tar.gz


## Pandoc: https://github.com/jgm/pandoc/releases/latest/
wget https://github.com/jgm/pandoc/releases/download/${PANDOC}/pandoc-${PANDOC}-linux-${ARCH}.tar.gz && tar -zxf pandoc-*.tar.gz --strip-components 1 -C /usr/local/ && rm pandoc-*.tar.gz

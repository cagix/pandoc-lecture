#!/bin/sh

## split into two steps: Download + Install to enable reuse in Docker and GitHub actions
tar -zxf pandoc-*.tar.gz --strip-components 1 -C /usr/local/
rm pandoc-*.tar.gz

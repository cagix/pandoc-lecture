#!/bin/sh

## split into two steps: Download + Install to enable reuse in Docker and GitHub actions
tar -zxf hugo_*.tar.gz -C /usr/local/bin/
rm hugo_*.tar.gz

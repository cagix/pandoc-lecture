#!/bin/sh

## Ubuntu: base packages
apt-get clean && apt-get update
apt-get install -y ca-certificates bash git make gzip tar wget graphviz ghostscript
rm -rf /var/lib/apt/lists/*

#!/bin/sh

## Ubuntu: base packages
apt-get update
apt-get install -y software-properties-common ca-certificates build-essential bash git make gzip tar wget
rm -rf /var/lib/apt/lists/*

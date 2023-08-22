---
title: Summary
---


This document includes `chapt1/chapt11.md` and `chapt1/chapt12.md` using Markdown links (**on own paragraphs**).

## Chapter 1.1: Wuppie

[Chapter 1.1: Wuppie](chapt1/chapt11.md)

## Chapter 1.2: Fluppie

[Chapter 1.2: Fluppie](chapt1/chapt12.md)

## Chapter: Lorum Ipsum

Hmmm.

The preview in GitHub and VSCode will work - you can start the preview beginning with this start document and follow the links.

It should also be possible to compile a complete document using e.g. `pandoc -L include_mdfiles.lua markdown/summary.md -s -t html -o test.html`: All via Markdown link referenced local Markdown files should be included in the resulting file, also all image sources should be adapted automatically.

**Please note**: Each Markdown link must be in its own paragraph, otherwise it will not be taken into account by the filter.

Pandoc Markdown homework sheet template
=======================================

This project defines a skeleton repo for creating homework sheets and
corresponding evaluation sheet out of
[Pandoc Markdown](http://pandoc.org/MANUAL.html)
using a single source approach.


History
-------

Originally [TeX Live](https://www.tug.org/texlive/) and the
[exam class](https://www.ctan.org/pkg/exam) were used to produce
homework sheets in PDF format.

However, there are a few drawbacks:

*   The overhead stemming from the `exam` class is quite high in this scenario.
*   Generating an evaluation sheet from the homework sheet is not supported by
    the `exam` class.

Like in the [pandoc lecture project](https://github.com/cagix/pandoc-lecture),
much of the code required by the `exam` class (and also quite some TeX code)
can be omitted by using [Pandoc Markdown](http://pandoc.org/MANUAL.html). Thus
the homework sheets can be written in a much simpler way, saving quite some time.

Deriving an evaluation sheet from the homework sheet can be done by using
pandoc in combination with a customised template.

A customised pandoc filter adds up all points (like the functionality provided
by the `exam` class).

Since LaTeX is still used as back end, all TeX macros could be used.


Notes on Pandoc Filter
----------------------

The filter `addpoints.py` is used to calculate the overall sum of points.

It searches for any header having a `punkte`/`value` pair in its attribute
list. The `value` will be added to the overall sum.

Example for a task with 2 points:
```markdown
# Task A {punkte=2}
```

If there is a meta variable `points` available in the documents meta data, the
calculated sum will be compared to the value of the meta variable. If there is
any difference, a warning will be issued.

Example for a homework sheet with an expected overall sum of 10 points:
```markdown
---
title: "Blatt 1: Short Summary"
author: "Author, Institute"
points: 10
...
```

The filter collects all headers with a `punkte`/`value` attribute and writes
this list to the meta data of the document (meta variable `questions`). This
list is used in the evaluation sheet template to generate the appropriate
structures.


Installing and running
----------------------

1.  If you have not already done so, install:

    *   [git](https://git-scm.com/)
    *   [make](https://www.gnu.org/software/make/)
    *   [pandoc](http://pandoc.org/installing.html) 1.17.2 (or newer)
    *   [pandoc templates](https://github.com/jgm/pandoc-templates) 1.17.2 (or newer)
    *   [pandoc filter](https://github.com/jgm/pandocfilters)
    *   [TeX Live](http://www.tug.org/texlive/)

2.  Create a working directory for your project and change into it.

3.  Clone the pandoc templates repo using `git clone https://github.com/jgm/pandoc-templates templates`.

4.  Clone this repo using `git clone https://github.com/cagix/pandoc-homework homework`.

5.  Change to the `homework/` subdirectory. Adapt the `DATADIR` variable in the
    makefile: It should point to the working directory of the project, i.e. to
    the folder containing the two subfolders `templates` and `homework`.

    Build the demo using `make`.

    Have a look at the example `homework/demo/b01.md`. Some of the features
    are demonstrated here.



---

License
-------

Copyright (c) 2016, Carsten Gips

[MIT licensed](http://opensource.org/licenses/MIT)



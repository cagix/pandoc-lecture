Pandoc Markdown lecture template
================================

This project defines a skeleton repo for creating lecture slides and handouts
including lecture notes out of [Pandoc Markdown](http://pandoc.org/MANUAL.html>)
using a single source approach.


History
-------

Originally [TeX Live](https://www.tug.org/texlive/) and the
[beamer class](https://www.ctan.org/pkg/beamer) were used to produce
slides in PDF format for lecture. A nice handout as article (i.e. not
just 2 or 4 slides on a page) in PDF format with additional comments
could easily be generated out of the slide source code by adding the
`\usepackage{beamerarticle}` option.

However, there are a few drawbacks:

*   The TeX overhead is particularly high in this scenario: estimated 50 to 80
    percent of the slides source code is just TeX code (defining slides and
    header, defining bullet point lists, ...).
*   Comments, that should appear in the handout, are limited. There is a
    `\note` command available in `beamer`, but using it for larger texts
    including code listings and headers is rather inconvenient or even
    impossible.
*   Most students would read the handout using a tablet or an e-book reader,
    so PDF is not really a suitable format for handouts. HTML or even EPUB
    would be a much more suitable choice for this task. There are a number
    of projects addressing this (e.g. [LaTeX2HTML](http://www.latex2html.org/),
    [Hyperlatex](http://hyperlatex.sourceforge.net/), [TeX4ht](http://www.tug.org/tex4ht/)),
    but the resulting HTML is not really satisfying, and EPUB generation
    is not even supported.

Using [Pandoc Markdown](http://pandoc.org/MANUAL.html>) most of the standard
TeX structures can be written in a much shorter way. Since pandoc does not
parse Markdown contained in TeX environments, the `\begin{XXX}` and `\end{XXX}`
commands need to be replaced using redefinitions like
`\newcommand{\XXXbegin}{\begin{XXX}}`.

Also by introducing a `\notesbegin` and `\notesend` command in combination with
a custom pandoc filter, the lecture notes can be placed freely at any location
in the material. Using the filter the lecture notes do not appear in the slides
but in the handout. The lecture notes can contain any valid Markdown or TeX
code, even further (sub-) sections.

Pandoc can convert Markdown also to HTML and EPUB. Thus a single source can
be used to create lecture slides (PDF) and handouts (HTML/EPUB). Even slide
desks in HTML using e.g. [reveal.js](http://lab.hakim.se/reveal-js/) would
be possible.


Notes on Pandoc Filter
----------------------

Since LaTeX is still used as back end when creating slides, all TeX macros
could be used. To create HTML output, the TeX code needs to be replaced by
appropriate HTML code. This can be achieved by writing and using custom
filters, which transform the AST created by pandoc parsing the input document
before pandoc converts it to the specified output format.


Notes on TeX Math
-----------------

To deal with TeX math, a number of options exist:

*   MathML could work (even offline), but is not supported by at least
    one major browser.
*   Rendering the math to images and embedding it into the result.
    Works well (even offline), but there are some issues regarding the
    used font, font size and font/background colours.
*   JavaScript libraries like [MathJax](https://www.mathjax.org/) or
    [KaTeX](https://github.com/Khan/KaTeX) can be used to render math
    within the browser. However, you would need Internet connectivity, as
    currently pandoc can not embed MathJax into the generated output and
    embedding KaTeX yields in rather huge files.

Currently, [MathJax](https://www.mathjax.org/) is used for HTML output in
this project.

Since most current e-book readers do not support MathML and are usually used
without Internet connectivity, math is converted to embedded images using
the `--webtex` option of pandoc for EPUB output.


Installing and running
----------------------

1.  If you have not already done so, install:

    *   [git](https://git-scm.com/)
    *   [make](https://www.gnu.org/software/make/)
    *   [pandoc](http://pandoc.org/installing.html) 1.17.2 (or newer)
    *   [pandoc templates](https://github.com/jgm/pandoc-templates) (`master`
        branch: commit https://github.com/jgm/pandoc-templates/commit/35c788701551f5b5094d230f33a7668072124655
        or newer)
    *   [pandoc filter](https://github.com/jgm/pandocfilters)
    *   [TeX Live](http://www.tug.org/texlive/) including the
        [beamer class](https://www.ctan.org/pkg/beamer)

2.  Create a working directory for your project and change into it.

3.  Clone the pandoc templates repo using `git clone https://github.com/jgm/pandoc-templates templates`.

4.  Clone this repo using `git git@github.com:cagix/pandoc-lectures.git lecture`.

5.  Change to the `lecture/` subdirectory. Adapt the `DATADIR` variable in the
    makefile: It should point to the working directory of the project, i.e. to
    the folder containing the two subfolders `templates` and `lecture`.

    Build the demo using `make`.

    Have a look at the example `lecture/demo/vl01.md`. Some of the features
    are demonstrated here.



---

License
-------

Copyright (c) 2016, Carsten Gips

[MIT licensed](http://opensource.org/licenses/MIT)



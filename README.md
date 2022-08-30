# Pandoc Markdown Lecture Template

This project defines a skeleton repo for creating lecture material, i.e. slides and
handouts including lecture notes, homework sheets plus the corresponding evaluation
sheets and exams plus solution sheets out of [Pandoc Markdown](http://pandoc.org/MANUAL.html)
using a single source approach.


## History

### Slides and Handouts

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
    would be a much more appropriate choice for this task. There are a number
    of projects addressing this (e.g. [LaTeX2HTML](http://www.latex2html.org/),
    [Hyperlatex](http://hyperlatex.sourceforge.net/), [TeX4ht](http://www.tug.org/tex4ht/)),
    but the resulting HTML is not really satisfying, and EPUB generation
    is not even supported.

Using [Pandoc Markdown](http://pandoc.org/MANUAL.html) most of the standard
TeX structures can be written in a much shorter way. Since Pandoc does not
parse Markdown contained in TeX environments, all `\begin{XXX}` and `\end{XXX}`
commands need to be replaced using redefinitions like
`\newcommand{\XXXbegin}{\begin{XXX}}`.

Also by introducing a notes block/inline (using fenced Divs, new in Pandoc 2.x)
in combination with a custom Pandoc filter, the lecture notes can be placed
freely at any location in the material. Using the filter the lecture notes do
not appear in the slides but in the handout. The lecture notes can contain any
valid Markdown or TeX code, even further (sub-) sections.

Pandoc can convert Markdown also to HTML and EPUB. Thus a single source can
be used to create lecture slides (PDF) and handouts (HTML/EPUB). Even slide
desks in HTML using e.g. [reveal.js](http://lab.hakim.se/reveal-js/) would
be possible.


### Homework Sheets

Originally [TeX Live](https://www.tug.org/texlive/) and the
[exam class](https://www.ctan.org/pkg/exam) were used to produce
homework sheets in PDF format.

However, there are a few drawbacks:

*   The overhead stemming from the `exam` class is quite high in this scenario.
*   Generating an evaluation sheet from the homework sheet is not supported by
    the `exam` class.

Much of the code required by the `exam` class (and also quite some TeX code)
can be omitted by using [Pandoc Markdown](http://pandoc.org/MANUAL.html). Thus
the homework sheets can be written in a much simpler way, saving quite some time.

Deriving an evaluation sheet from the homework sheet can be done by using
Pandoc in combination with a customised template.

A Pandoc filter adds up all points (like the functionality provided
by the `exam` class).

Since LaTeX is still used as back end, all TeX macros could be used.


### Exams

Originally [TeX Live](https://www.tug.org/texlive/) and the
[exam class](https://www.ctan.org/pkg/exam) were used to produce
exams and corresponding solution sheets in PDF format.

Using [Pandoc Markdown](http://pandoc.org/MANUAL.html) the task of
creating exams with the `exam` class can be simplified.
Since LaTeX is still used as back end, all TeX macros could be used.


## Notes on Pandoc Filters

Since LaTeX is still used as back end when creating slides, all TeX macros
could be used.

Pandoc 2.x includes a Lua interpreter, thus there is no need anymore to install
a separate (matching!) python filter module.


### Slides and Handouts

To create HTML output, the TeX code needs to be replaced with appropriate HTML
code. This is achieved by the filter `html.lua`, which transforms the AST
created by Pandoc parsing the input document before Pandoc converts it to the
specified output format.

To remove the lecture notes from the beamer slides and to transform fenced Divs
and inline Spans to TeX macros, the filter `tex.lua` is used.


### Homework Sheets

The filter `addpoints.lua` is used to calculate the overall sum of points.

It searches for any header having a "`punkte`"/`value` pair in its attribute
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

The filter `questions.lua` collects all headers with a "`punkte`"/`value` attribute
and writes this list to the meta data of the document (meta variable `questions`).
This list is used in the evaluation sheet template to generate the appropriate
structures.


## Notes on TeX Math

To deal with TeX math, a number of options exist:

*   MathML could work (even offline), but is not supported by at least
    one major browser.
*   Rendering the math to images and embedding it into the result.
    Works well (even offline), but there are some issues regarding the
    used font, font size and font/background colours.
*   JavaScript libraries like [MathJax](https://www.mathjax.org/) or
    [KaTeX](https://github.com/Khan/KaTeX) can be used to render math
    within the browser. However, you would need Internet connectivity, as
    currently Pandoc can not embed MathJax into the generated output and
    embedding KaTeX yields in rather huge files.

Currently, [MathJax](https://www.mathjax.org/) is used for HTML output in
this project (option `--mathjax`). To prevent Pandoc from incorporating MathJax
into the generated self-contained HTML document (it is quite large and it won't
work properly this way), the URL to MathJax is included via a separate file.

Since most current e-book readers do not support MathML and are usually used
without Internet connectivity, math is converted to embedded images using
the `--webtex` option of Pandoc for EPUB output.


## Installing and running

1.  If you have not already done so, install:

    *   [git](https://git-scm.com/)
    *   [make](https://www.gnu.org/software/make/)

2.  Either install also the following programs and packages:

    *   [pandoc](http://pandoc.org/installing.html) 2.9.1 (or newer)
    *   [TeX Live](http://www.tug.org/texlive/)
    *   [beamer class](https://www.ctan.org/pkg/beamer) (slides only)
    *   [beamer theme: Metropolis](https://github.com/matze/mtheme) (for building the examples)
    *   [exam class](https://www.ctan.org/pkg/exam) (exams only)

    Or use the dockerfile contained in the `docker/` subdirectory to create a docker image,
    which should contain all the tools and tex packages mentioned above ... (about 800 MiB)

3.  Create a working directory for your project and change into it.

4.  Clone this repo using `git clone https://github.com/cagix/pandoc-lecture lecture`
    (or add it as git submodule to your project).

5.  Change to the `lecture/` directory. Adapt the `DATADIR` variable in the
    makefiles (`demo` subdir): It should point to the root directory of this
    project, i.e. to the folder containing the subfolders `filters`, `resources`
    and `demo`.

    Build the demo using `make -f Makefile.lecture` (slides and handout)
    or `make -f Makefile.homework` (homework sheet) or `make -f Makefile.exams`
    (exams).

    Have a look at the examples in `lecture/demo/`. Some of the features
    are demonstrated and explained in the markdown source.


## Notes and Versions

This project is supposed to be used with Pandoc 2.19 or later.


## Contributing

Questions, bug reports, feature requests and pull requests are very welcome.
Please be sure to read the [contributor guidelines](CONTRIBUTING.md) before
opening a new issue.


---

License
-------

This work by [Carsten Gips](https://github.com/cagix) and [contributors](https://github.com/cagix/pandoc-lecture/graphs/contributors) is licensed under [MIT](https://opensource.org/licenses/MIT).

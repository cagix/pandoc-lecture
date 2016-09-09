Pandoc Markdown exam template
=============================

This project defines a skeleton repo for creating exams and corresponding
solution sheets out of [Pandoc Markdown](http://pandoc.org/MANUAL.html)
using a single source approach.


History
-------

Originally [TeX Live](https://www.tug.org/texlive/) and the
[exam class](https://www.ctan.org/pkg/exam) were used to produce
exams and corresponding solution sheets in PDF format.

After successfully employing [Pandoc Markdown](http://pandoc.org/MANUAL.html)
in the [pandoc lecture project](https://github.com/cagix/pandoc-lecture) and
the [pandoc homework project](https://github.com/cagix/pandoc-homework) the
task of creating exams with the `exam` class can be simplified as well.

Since LaTeX is still used as back end, all TeX macros could be used.


Installing and running
----------------------

1.  If you have not already done so, install:

    *   [git](https://git-scm.com/)
    *   [make](https://www.gnu.org/software/make/)
    *   [pandoc](http://pandoc.org/installing.html) 1.17.2 (or newer)
    *   [pandoc templates](https://github.com/jgm/pandoc-templates) 1.17.2 (or newer)
    *   [TeX Live](http://www.tug.org/texlive/) including the
        [exam class](https://www.ctan.org/pkg/exam)

2.  Create a working directory for your project and change into it.

3.  Clone the pandoc templates repo using `git clone https://github.com/jgm/pandoc-templates templates`.

4.  Clone this repo using `git clone https://github.com/cagix/pandoc-exam exam`.

5.  Change to the `exam/` subdirectory. Adapt the `DATADIR` variable in the
    makefile: It should point to the working directory of the project, i.e. to
    the folder containing the two subfolders `templates` and `exam`.

    Build the demo using `make`.

    Have a look at the examples `exam/demo/exam.md` (defining meta data for the
    exam) and in the `exam/demo/md/` subfolder, where you find some examples
    for typical tasks like code analysis, programming tasks and multiple choice
    questions.



---

License
-------

Copyright (c) 2016, Carsten Gips

[MIT licensed](http://opensource.org/licenses/MIT)



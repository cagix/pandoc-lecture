---
title: "Pandoc Markdown Lecture Template"
---

This project defines a skeleton repo for creating lecture material, i.e. slides and
handouts including lecture notes, homework sheets plus the corresponding evaluation
sheets and exams plus solution sheets out of [Pandoc Markdown](http://pandoc.org/MANUAL.html)
using a single source approach.


# History

## Slides and Handouts

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

## Homework Sheets

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

## Exams

Originally [TeX Live](https://www.tug.org/texlive/) and the
[exam class](https://www.ctan.org/pkg/exam) were used to produce
exams and corresponding solution sheets in PDF format.

Using [Pandoc Markdown](http://pandoc.org/MANUAL.html) the task of
creating exams with the `exam` class can be simplified.
Since LaTeX is still used as back end, all TeX macros could be used.


# Installing and using Pandoc-Lecture

The project [Pandoc-Lecture](https://github.com/cagix/pandoc-lecture) defines a toolchain to generate slides (in PDF format) as well as a website for teaching material from a set of Markdown files. For each unit, the PDF and the HTML page are generated from the same Markdown file:

-   The slide sets (as PDF slide sets) are produced from the Markdown sources with [Pandoc](https://pandoc.org/) plus the [filters](https://github.com/cagix/pandoc-lecture/tree/master/filters), [definitions](https://github.com/cagix/pandoc-lecture/tree/master/resources) and [defaults](https://github.com/cagix/pandoc-lecture/tree/master/defaults) defined in [Pandoc-Lecture](https://github.com/cagix/pandoc-lecture) and with [TexLive](https://tug.org/texlive/).

-   The teaching material (as a website) is produced from the Markdown sources using [Pandoc](https://pandoc.org/) and the [filters](https://github.com/cagix/pandoc-lecture/tree/master/filters), [definitions](https://github.com/cagix/pandoc-lecture/tree/master/resources) and [defaults](https://github.com/cagix/pandoc-lecture/tree/master/defaults) defined in [Pandoc-Lecture](https://github.com/cagix/pandoc-lecture) as well as with [Hugo](https://gohugo.io/) and the [Hugo Relearn-Theme](https://github.com/McShelby/hugo-theme-relearn). The generated website can, e.g., be deployed as a _HTML Learning Module_ in the LMS _ILIAS_.

All required tools are specified in the various installation scripts in the folder [cagix/pandoc-lecture/docker/](https://github.com/cagix/pandoc-lecture/tree/master/docker).

There are three ways to use the toolchain defined by the [Pandoc-Lecture project](https://github.com/cagix/pandoc-lecture):

-   Online via GitHub action
-   Locally via Docker container
-   Locally via native installation

Installation and usage in these scenarios is described in the following sections.

## Using Online: GitHub action

You need a suitable build script, e.g. a Makefile, to apply Pandoc and the other tools to your Markdown files. Additionally, you need a GitHub workflow that utilises this Makefile and the [_composite_ GitHub-Action](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) defined in the Pandoc-Lecture project ([action.yaml](https://github.com/cagix/pandoc-lecture/blob/master/action.yaml)).

### Build Script

You can use your favourite build script technology. In this example we will demonstrate how to use a Makefile. The following code snippet shows two targets `web` and `slides` for calling Hugo and Pandoc, respectively. This example is quite abbreviated, you will find the complete (and working) text in [Programming Methods/PM Lecture/Makefile](https://github.com/Programmiermethoden/PM-Lecture/blob/master/Makefile).

To produce the teaching material as a website, invoke `make web`; and to produce the PDF slide sets, use `make slides`:

```makefile
## Create website
web: ...
	hugo $(HUGO_ARGS)

## Create all slides
slides: ...
	pandoc -d slides $< -o $@
```

### GitHub Workflow

To use your build script and the tools in a CI/CD pipeline on the GitHub runner for producing the teaching materials, you need to define a suitable [GitHub workflow](https://docs.github.com/en/actions/using-workflows). This workflow will first install the required tools using the [_composite_ GitHub-Action](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) in [action.yaml](https://github.com/cagix/pandoc-lecture/blob/master/action.yaml), and afterwards you can call your own build script from the workflow steps.

Our [action](https://github.com/cagix/pandoc-lecture/blob/master/action.yaml) will install Pandoc and Pandoc-Lecture in the GitHub runner. If the option `hugo` is set to `'true'` (string!), Hugo and Hugo Relearn theme will also be installed. If the option `texlive` is set to `'true'` (string!), TexLive will be installed along with all the packages needed to produce the Beamer PDF slides. If instead of `'true'` the value `'extra'` is given, additional packages such as additional fonts will be installed (cf. [docker/install-texlive-extra.sh](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-texlive-extra.sh)) - however, this requires _significantly_ more space and time during installation! With the option `graphviz` (value `'true'`, string!) you can also install [GraphViz](https://graphviz.org/) and [Dot](https://graphviz.org/doc/info/lang.html).

Here is an example workflow for your project with one job each for the production of the beamer PDF slides and the website for the teaching materials:

```yaml
name: WORKFLOWNAME
on:
  # push on master branch
  push:
    branches: [master]
  # manually triggered
  workflow_dispatch:

jobs:
  # build slides (pandoc): "make slides"
  slides:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: cagix/pandoc-lecture@master
        with:
          texlive: 'true'
      - run: make slides

      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_branch: _slides
          publish_dir: pdf/
          force_orphan: true

  # build lecture notes (hugo): "make web"
  hugo:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: cagix/pandoc-lecture@master
        with:
          hugo: 'true'
      - run: make web

      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_branch: _hugo
          publish_dir: docs/
          force_orphan: true
```

Usually, this workflow has to be saved as a YAML file "`WORKFLOWNAME.yaml`" in the `.github/workflows/` folder of your project (use an appropriate name for your file). Once pushed to your repository, the workflow will be automatically activated as a CI/CD pipeline on the GitHub server by the defined triggers (in this example, if changes are made to the `master` branch, or if it is manually triggered in the menu `Actions > WORKFLOWNAME > Run Workflow`). The slides created will be available in the `_slides` branch, the teaching materials created in the `_hugo` branch. (_Note_: Both branches will be overwritten the next time you run the workflow).

Depending on your settings, the ["cagix/pandoc-lecture"](https://github.com/cagix/pandoc-lecture) GitHub action must be enabled for your repository: `Settings > Actions > General > Action permissions`.

## Using locally: Docker container

For local use, the [Docker image](https://github.com/cagix/pandoc-lecture/blob/master/docker/Dockerfile) defined in the project can be used. You'll need to build this Docker image, also you'll need a suitable build script, e.g. a Makefile.

### Building the Docker Image

To create the image with the name `pandoc-lecture`, just clone the project locally, navigate to the sub-folder `docker/` and create the Docker image for your architecture via the provided Makefile. For Intel machines this will be the `amd64` target, for Apple M1 (also M2 and other ARM-based machines) accordingly `arm64`:

```sh
git clone https://github.com/cagix/pandoc-lecture.git
cd pandoc-lecture/
# Use either of the following steps
make amd64  # Intel
make arm64  # Apple M1/M2, ARM
```

Once the image has been created, the `pandoc-lecture/` folder can be deleted. To renew the image, e.g. after updating the definitions, the above steps have to be repeated.

### Working with the Docker Image

The entire toolchain is available in the Docker image named `pandoc-lecture`. To work with the toolchain, the Docker image needs to be launched and the local working directory has to be mounted into the container. An interactive shell inside the container can be used to access the mounted files and the toolchain in the container from there.

Here is an example of a Makefile for your local project (excerpt from [Programming Methods/PM Lecture/Makefile](https://github.com/Programmiermethoden/PM-Lecture/blob/master/Makefile), shortened):

```makefile
## Start Docker container "pandoc-lecture" into interactive shell
runlocal:
	docker run  --rm -it  -v "$(shell pwd):/pandoc" -w "/pandoc"  -u "$(shell id -u):$(shell id -g)"  --entrypoint "bash"  pandoc-lecture

## Create all slides
slides: ...
	pandoc -d slides $< -o $@
```

With `make runlocal`, issued in your local shell, the container will be launched and an interactive shell (Bash) inside the container will be started. Your local working directory will be mounted into the container, so all files in your local working directory are accessible inside the container. With the above Makefile, you can then produce the PDF slide sets in the interactive shell within the container using `make slides`. The generated PDF files are automatically available in the local working directory via the mount.

### Testing of the website in the local file system

The base URL for the deployment of the produced website has to be defined in the Hugo configuration file (`hugo.yaml`, variable `baseURL`).

However, this prevents the generated web pages from being displayed correctly when accessed from the local file system. You would first have to adapt the Hugo configuration to the local URL. However, since this configuration is versioned with Git together with all the other project files, you can easily commit this "broken" configuration by accident.

As an alternative, you can add an additional local file `local.yaml` to the project root, which will _not be versioned_ (create a corresponding entry in the `.gitignore`!). This file contains a single line `baseURL: "file://<path_to_project>/docs/"`, specifying the actual path in the local file system to your project. If this file is present, its definition of the `baseURL` overwrites the original configuration and you can view the generated web pages locally. For the deployment to the LMS, you just need to comment out the single line in the file, so the `baseURL` from the versioned global configuration will be used again.

Here is an excerpt from a suitable Makefile (see again [Programming Methods/PM Lecture/Makefile](https://github.com/Programmiermethoden/PM-Lecture/blob/master/Makefile)):

```makefile
## Define options to be used by Hugo
## local.yaml allows to override settings in hugo.yaml
HUGO_ARGS  = --config hugo.yaml,$(wildcard local.yaml)  --themesDir "$(XDG_DATA_HOME)/pandoc/hugo"

## Create website
web: ...
	hugo $(HUGO_ARGS)
```

_Note_: Since Hugo version 0.110.0, the configuration file for Hugo is supposed to have the name `hugo.yaml` (see also https://gohugo.io/getting-started/configuration/#hugotoml-vs-configtoml). However, since this name is already used for the Pandoc filter to preprocess Markdown files, there would be a name clash. Therefore, in the example [Programming Methods/PM Lecture/Makefile](https://github.com/Programmiermethoden/PM-Lecture/blob/master/Makefile), a different filename is used for the Hugo configuration (i.e. `hugo_conf.yaml`) and then is set explicitly as a parameter for Hugo in the Makefile (`--config hugo_conf.yaml`).

## Using locally: Native installation

Local use without Docker is also an option for Unix-like operating systems like Linux or macOS (_but is not recommended_). For this purpose, the specified tools have to be installed manually using the correct versions. The files linked below provide both the download URLs for the respective binaries and the required version numbers:

-   [Pandoc](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-pandoc.sh) and [Pandoc-Lecture](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-pandoc-lecture.sh)
-   For the web page:
    -   [Hugo](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-hugo.sh)
    -   [Hugo Relearn-Theme](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-relearn.sh)
-   For the PDF slide sets:
    -   [TeX-Live](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-texlive.sh)
-   If required, [GraphViz and Dot](https://github.com/cagix/pandoc-lecture/blob/master/docker/install-packages-ubuntu.sh)

The content of [Pandoc Lecture](https://github.com/cagix/pandoc-lecture) has to be copied into your local user folder `${HOME}/.local/share/pandoc/`. The content of [Hugo Relearn-Theme](https://github.com/McShelby/hugo-theme-relearn) is expected in `${HOME}/.local/share/pandoc/hugo/hugo-theme-relearn/`. Both steps can be achieved using the [Makefile in Pandoc Lecture](https://github.com/cagix/pandoc-lecture/blob/master/Makefile):

```sh
git clone https://github.com/cagix/pandoc-lecture.git
cd pandoc-lecture/
make install_scripts_locally
```

You can now work with your build script, e.g. a Makefile, in your local project. In the following example, you see a shortened excerpt from [Programming Methods/PM Lecture/Makefile](https://github.com/Programmiermethoden/PM-Lecture/blob/master/Makefile) to produce the teaching material as a website with `make web` or the PDF slide sets with `make slides`:

```makefile
## Create website
web: ...
	hugo $(HUGO_ARGS)

## Create all slides
slides: ...
	pandoc -d slides $< -o $@
```

The downside of this option would be that you need to manually maintain the installed tools (Pandoc, Hugo, TexLive) as well as the scripts from Pandoc-Lecture and Hugo Relearn-Theme. The versions must always match the specifications in [cagix/pandoc-lecture/docker/](https://github.com/cagix/pandoc-lecture/tree/master/docker)!

If you want to check the generated artefacts locally, follow the advice given in the "Testing the Web site in the local file system" section above.


# Contributing

Questions, bug reports, feature requests and pull requests are very welcome.

Please first check whether your request has already been dealt with in other (open or closed) issues. Feel free to reopen relevant closed issues to add your request there.

When submitting pull requests, please make sure that your **feature branch starts at the tip of the current `master` branch**. Upon acceptance (i.e. merging your pull request), your contribution automatically becomes subject to the licence of this repository (MIT).


# Credits

See the [credits](CREDITS.md) for a detailed list of contributing projects.


---

# License

This [work](https://github.com/cagix/pandoc-lecture) by
[Carsten Gips](https://github.com/cagix) and
[contributors](https://github.com/cagix/pandoc-lecture/graphs/contributors)
is licensed under [MIT](LICENSE.md).

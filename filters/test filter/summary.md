---
author: me
title: Thesis
---

# Summary.md

## This should work

Thanks everyone!

***

[File A](file-a.md)

***

![Image A (from Readme.md)](img/a.png)

![](img/a.png)


## Different (wrong) format

-   [wrong extension](file-c.png)
-   [not local](https://pandoc.org/lua-filters.html)
-   [still not local](https://pandoc.org/lua-filters.md)
-   [also not local](http://pandoc.org/lua-filters.md)
-   [not there and not here](wuppie.md)

***

since our filter works for `pandoc.Para` only, let's put these links into a paragraph:
[not there and not here](wuppie.md) and [still not local](https://pandoc.org/lua-filters.md).

***

## Recursive inclusion

***

[Subdir: File D](subdir/file-d.md)

***

[Subdir: Readme](subdir/leaf/readme.md)

***

::: slides
## Hidden Parts

This part will be visible while building the makefile dependencies, but will be removed for building
the website because of being marked as slides content. We can use this to include files in the build
process even if we do not want to have explicit links in the site ...

Use case: We want to use a Hugo-generated schedule, i.e. we do not provide links to all individual
lections in this readme or elsewhere, but need to define the scope of the semester/offering. So all
links to the lectures to be included can go here and will be hidden in the generated website. The
referenced pages will be available in the site, however.

This itemize will not be recognized and included:

-   [Syllabus](orga/syllabus.md)
-   [Ressourcen](orga/resources.md)
-   [Prüfungsvorbereitung](orga/exams.md)

But this will because of the new lines between each item:

-   [Syllabus](orga/syllabus.md)

-   [Ressourcen](orga/resources.md)

-   [Prüfungsvorbereitung](orga/exams.md)

:::

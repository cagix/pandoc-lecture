---
archetype: "home"
title: "PM S23"
---


## This should work

Thanks everyone!

[File A](file-a.md)

[File A](file-a.md)

![Image A (from Readme.md)](img/a.png)

![](img/a.png)


## Different (wrong) format

-   [wrong extension](file-c.png)
-   [not local](https://pandoc.org/lua-filters.html)
-   [still not local](https://pandoc.org/lua-filters.md)
-   [also not local](http://pandoc.org/lua-filters.md)


## Recursive inclusion

[File B](file-b.md)


## Subdirectories

[Subdir: File D](subdir/file-d.md)

[Subdir: File D](./subdir/file-d.md)


## Subdirectories, recursive

[Subdir: File E](subdir/file-e.md)


## Subdirectories, direct plus recursive

[Subdir/Leaf: Foo](subdir/leaf/foo.md)


## Links to Landing Pages

[subdir/readme](subdir/readme.md)

[readme](readme.md)


## Schedule

`{{< schedule >}}`{=markdown}

**Hinweise**: Abgabe der Hausaufgaben (PDF, ZIP, Link) jeweils bis zur angegebenen Deadline im ILIAS.
Peer-Feedback jeweils bis zur angegebenen Deadline im ILIAS.
Vorstellung der Lösungen im jeweiligen nachfolgenden Praktikumstermin.


## Schedule II

+-----------------------+------------------------------------------------------------------+-----------------------+
| Woche                 | Vorlesung                                                        | Praktikum/Übung       |
+=======================+==================================================================+=======================+
| W01 (07. April)       | >> Feiertag                                                      | >> Feiertag           |
+-----------------------+------------------------------------------------------------------+-----------------------+
| W02 (14. April)       | -   [**Subdir/File-D.md**](subdir/file-d.md)\                    |                       |
|                       |     *Hinweis: Kick-Off/Orga (Zoom)*                              |                       |
|                       | -   [**Subdir/File-E.md**](subdir/file-e.md)                     |                       |
+-----------------------+------------------------------------------------------------------+-----------------------+
| W03 (21. April)       | -   [**Single page 'Bar' in a leaf bundle**](subdir/leaf/bar.md) |                       |
|                       | -   [**Single page 'Foo' in a leaf bundle**](subdir/leaf/foo.md) |                       |
+-----------------------+------------------------------------------------------------------+-----------------------+

**Hinweise**: Abgabe der Hausaufgaben (PDF, ZIP, Link) jeweils bis zur angegebenen Deadline im ILIAS.
Peer-Feedback jeweils bis zur angegebenen Deadline im ILIAS.
Vorstellung der Lösungen im jeweiligen nachfolgenden Praktikumstermin.


## Schedule III

| Woche           | Vorlesung                                                                | Praktikum/Übung |
|-----------------|--------------------------------------------------------------------------|-----------------|
| W01 (07. April) | Feiertag                                                                 | Feiertag        |
| W02 (14. April) | [**Sub: D**](subdir/file-d.md), [**Sub: E**](subdir/file-e.md)           |                 |
|                 | *Hinweis: Kick-Off/Orga (Zoom)*                                          |                 |
| W03 (21. April) | [**Leaf: Bar**](subdir/leaf/bar.md), [**Leaf: Foo**](subdir/leaf/foo.md) |                 |


| Woche           | Vorlesung | Praktikum/Übung |
|-----------------|-----------|-----------------|
| W01 (07. April) | Feiertag  | Feiertag        |
| W02 (14. April) | AAA       |                 |
|                 | BBB       |                 |
| W03 (21. April) | CCC       |                 |
|                 | DDD       |                 |

**Hinweise**: Abgabe der Hausaufgaben (PDF, ZIP, Link) jeweils bis zur angegebenen Deadline im ILIAS.
Peer-Feedback jeweils bis zur angegebenen Deadline im ILIAS.
Vorstellung der Lösungen im jeweiligen nachfolgenden Praktikumstermin.



::: slides
## Hidden Parts

This part will be visible while building the makefile dependencies, but will be removed for building
the website because of being marked as slides content. We can use this to include files in the build
process even if we do not want to have explicit links in the site ...

Use case: We want to use a Hugo-generated schedule, i.e. we do not provide links to all individual
lections in this readme or elsewhere, but need to define the scope of the semester/offering. So all
links to the lectures to be included can go here and will be hidden in the generated website. The
referenced pages will be available in the site, however.

-   [Syllabus](orga/syllabus.md)
-   [Ressourcen](orga/resources.md)
-   [Prüfungsvorbereitung](orga/exams.md)
:::

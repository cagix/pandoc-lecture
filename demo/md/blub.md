
\myQuestion[5]{Space for anwers using a fenced div with class "solution"}

Here goes the question ...


Using a fenced div with class "solution" and **attribute "length"** we can separate
the question part and the answer part. The environment produces a blue/gray bar
on the left side, which length depends on the attribute `length` of the div.

Also we can use Markdown in there ...

Everything in the div will only appear in the solution sheet.
This requires the `exams.lua` filter.

```markdown
::: {.solution length=60mm}
This text will appear ONLY in the solution ...
:::
```

::: {.solution length=60mm}
This text will appear ONLY in the solution ...
\vspace{50mm}
:::

*Note*: The `length` attribute is used to determine the length of the blank space
in the exams sheet. However, in the solution sheet, the element is just as long as
needed by the given content. To avoid differences in the page layout between exam
and solution sheet you need to fill the unused solution space with `\vspace` as
shown in the example above ...


### Fenced div with class "solution" without attributes {.unnumbered}

The same fenced div *without* the attribute `length` will just draw the
blue/gray stripe to the left side and always present the content:

```markdown
::: {.solution}
This text will appear in the exam as well as in the solution ...

  Length          Height A        Height B        Class
 --------------  ------------    -------------   --------
  2.0             2.0             10.0            \x{A}
  5.0             4.0             40.0            B
  0.8             \x{0.4}         4.5             C
  1.4             2.0             15.0            A

:::
```

::: {.solution}
This text will appear in the exam as well as in the solution ...

  Length          Height A        Height B        Class
 --------------  ------------    -------------   --------
  2.0             2.0             10.0            \x{A}
  5.0             4.0             40.0            B
  0.8             \x{0.4}         4.5             C
  1.4             2.0             15.0            A

Unfortunately, Pandoc still uses `longtable`, which cannot be
used inside a minipage (which is used here to produce the
blue/gray marker on the left side). Thus we need to handle
markdown tables in the filter and translate it to simple
LaTeX `tabular` ...

:::

This is usefull for "Fill in the blank" questions.





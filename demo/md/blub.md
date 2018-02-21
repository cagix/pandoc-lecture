
\myQuestion[5]{Space for anwers using "solutionbegin" and "solutionend"}

Here goes the question ...


Using `\solutionbegin` and `\solutionend` we can separate the question part
and the answer part. The environment produces a gray bar on the left side,
which length depends on the parameter given to `\solutionbegin`.

Also we can use Markdown in there ...

Everything between `\solutionbegin` and `\solutionend` will not be printed in
the normal exam version, but will appear in the sample solution version.


\solutionbegin[84mm]
3P

Here should be the sample solution ...

\vspace{75mm}

\solutionend


### Fenced div with class "solution" and attribute "length" {.unnumbered}

Using the `exams.lua` filter, the same can be achived using a fenced div:

```markdown
::: {.solution length=60mm}
This text will appear ONLY in the solution ...
:::
```

::: {.solution length=60mm}
This text will appear ONLY in the solution ...
\vspace{50mm}
:::


### Fenced div with class "solution" without attributes {.unnumbered}

The same fenced div without the attribute `length` will just draw the gray
stripe to the left side and always present the content:

```markdown
::: {.solution}
This text will appear in the exam as well as in the solution ...

  Length          Height A        Height B        Class
 --------------  ------------    -------------   --------
  2.0             2.0             10.0            A
  5.0             4.0             40.0            B
  0.8             0.4             4.5             C
  1.4             2.0             15.0            A

:::
```

::: {.solution}
This text will appear in the exam as well as in the solution ...

```
  Length          Height A        Height B        Class
 --------------  ------------    -------------   --------
  2.0             2.0             10.0            A
  5.0             4.0             40.0            B
  0.8             0.4             4.5             C
  1.4             2.0             15.0            A
```

Unfortunately, Pandoc still uses `longtable`, which cannot be
used inside a minipage (which is used here to produce the
gray marker on the left side). Thus we will need to handle
markdown tables in the filter ...

:::

This is usefull for "Fill in the blank" questions.





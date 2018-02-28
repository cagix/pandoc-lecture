
# Multiple Choice with "mc" div {punkte=8}

Instead of using the TeX notation for starting a question you can use
a markdown header. It will be transformed into a exam question. Add
the points as attribute `punkte` to the header.

A level 1 header will be translated into a question with an extra
`\clearpage` before.

That is, the following markdown code
```markdown
# Multiple Choice with "mc" div {punkte=8}
```
will be transformed by the `exams.lua` filter into
```latex
\clearpage
\myQuestion[8]{Multiple Choice with \enquote{mc} div}
```

**Warning**: Don't do any fancy in the header! Results would be unpredictable!
(Emphasis and question marks should be OK, though. Inline code with backticks
does NOT work!)

\bigskip


Here goes the question ...

::: center
![nice figure](figs/somefig){width=60mm}\
:::

For multiple choice questions use a `mc` div, which will be transformed by
the `exams.lua` filter into a customized LaTeX table with a blue/gray bar
on the left side. The parameters are the column headers for correct and wrong
answers/choices.

Each line constitutes a possible answer. Use a span with class `ok` for
correct answers and a span with class `nok` for wrong answers. The content
will not appear in the normal exam version. In the sample solution, all
correct answers are marked.

(Keep in mind, in the end it is just a customized LaTeX table).

```markdown
::: {.mc ok="CorrecT" nok="wrOng" points="**je 0.5P** (*Summe 2P*)"}
  [... blablabla.]{.nok}
  [... **wuppie** :)]{.ok}
  [... *fluppie.*]{.nok}
  [... `foobar`.]{.nok}
:::
```

::: {.mc ok="CorrecT" nok="wrOng" points="**je 0.5P** (*Summe 2P*)"}
  [... blablabla.]{.nok}
  [... **wuppie** :)]{.ok}
  [... *fluppie.*]{.nok}
  [... `foobar`.]{.nok}
:::

Using a fenced div you can use markdown formatting inside the answers.

**Warning**: The `mc` div and all contained `ok`/`nok` spans are translated into a
LaTeX table. Make sure to **only** use `ok`/`nok` spans inside the `mc` div! Doing
otherwise will produce TeX errors ...











# Multiple Choice with "streifenMC" environment {punkte=8}

Instead of using the TeX notation for starting a question you can use
a markdown header now. It will be transformed into a exam question. Add
the points as attribute `punkte` to the header.

A level 1 header will be translated into a question with an extra
`\clearpage` before.

That is, the following markdown code
```markdown
# Multiple Choice with "streifenMC" environment {punkte=8}
```
will be transformed by the `exams.lua` filter into
```latex
\clearpage
\myQuestion[8]{Multiple Choice with \enquote{streifenMC} environment}
```

**Warning**: Don't do any fancy in the header! Results would be unpredictable!
(Emphasis and question marks should be OK, though. Inline code with backticks
does NOT work!)

\bigskip


Here goes the question ...

::: center
![nice figure](figs/somefig){width=60mm}\
:::

For multiple choice questions use the `streifenMC` environment, which is a
customized LaTeX table with a gray bar on the left side. The parameters are
the column headers for correct and wrong answers/choices.

Each line constitutes a possible answer and needs to be ended with "`\\\\`"
(remember, it is just a customized LaTeX table).

Correct answers must be started with `\wahr`, whereas wrong answers start
with `\falsch`. This will not appear in the normal exam version. In the sample
solution, all correct answers are marked.

```latex
\begin{streifenMC}{correct}{wrOng}
    \falsch \ldots blablabla. \\[5pt]
    \wahr \ldots wuppie :) \\[5pt]
    \falsch \ldots fluppie. \\[5pt]
    \falsch \ldots foobar.
\end{streifenMC}
\x{je 0.5P (2P)}
```



\Fortsetzung
\clearpage



Since this is a LaTeX environment, we cannot use Markdown in here ...


\begin{streifenMC}{correct}{wrOng}
    \falsch \ldots blablabla. \\[5pt]
    \wahr \ldots wuppie :) \\[5pt]
    \falsch \ldots fluppie. \\[5pt]
    \falsch \ldots foobar.
\end{streifenMC}
\x{je 0.5P (2P)}



### Fenced div with class "mc" {.unnumbered}

The same as above can be done now using a fenced div of class `mc`:

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








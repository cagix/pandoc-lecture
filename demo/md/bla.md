
## Space for *anwers* using fenced divs with class "solution" {punkte=5}

Instead of using the TeX notation for starting a question you can use
a markdown header. It will be transformed into a exam question. Add
the points as attribute `punkte` to the header.

A level 1 header will be translated into a question with an extra
`\clearpage` before.

That is, the following markdown code
```markdown
## Space for *anwers* using fenced divs with class "solution" {punkte=5}
```
will be transformed by the `exams.lua` filter into
```latex
\myQuestion[5]{{Space for \emph{anwers} using fenced divs with class
\enquote{solution} and \enquote{streifenend}}
```

**Warning**: Don't do any fancy in the header! Results would be unpredictable!
(Emphasis and question marks should be OK, though. Inline code with backticks
does NOT work!)

\bigskip


Here goes the question ...


Using a fenced div with class "solution" **without attributes** we can separate
the question part and the answer part. The environment produces a blue/gray bar
on the left side, which length depends on the amount of text within this
environment.

Also we can use Markdown in there ...

To produce a sample solution, use `\x{...}` or `[...]{.answer}` and provide
the solution as parameter/content. This will not be printed in the normal exam :)


```markdown
::: solution
*   Zeile 19: \x{12}
    \bigskip
*   Zeile 20: \x{A}
    \bigskip
*   Zeile 21: [42]{.answer}
    \bigskip
*   Zeile 22: \x{X}
    \bigskip

[**je 0.5P** (*Summe 2P*)]{.answer}
:::
```

::: solution
*   Zeile 19: \x{12}
    \bigskip
*   Zeile 20: \x{A}
    \bigskip
*   Zeile 21: [42]{.answer}
    \bigskip
*   Zeile 22: \x{X}
    \bigskip

[**je 0.5P** (*Summe 2P*)]{.answer}
:::





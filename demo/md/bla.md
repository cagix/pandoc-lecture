
## Space for `anwers` using "streifenbegin" and "streifenend" {punkte=5}

Instead of using the TeX notation for starting a question you can use
a markdown header now. It will be transformed into a exam question. Add
the points as attribute `punkte` to the header.

A level 1 header will be translated into a question with an extra
`\clearpage` before.

That is, the following markdown code
```markdown
## Space for anwers using streifenbegin and streifenend {punkte=5}
```
will be transformed by the `exams.lua` filter into
```latex
\myQuestion[5]{Space for anwers using streifenbegin and streifenend}
```


Here goes the question ...


Using `\streifenbegin` and `\streifenend` we can separate the question part
and the answer part. The environment produces a gray bar on the left side,
which length depends on the amount of text within this environment.

Also we can use Markdown in there ...

To produce a sample solution, use `\x{}` and provide the solution as parameter.
This will not be printed in the normal exam :)


\streifenbegin

*   Zeile 19: \x{12}
    \bigskip
*   Zeile 20: \x{A}
    \bigskip
*   Zeile 21: \x{42}
    \bigskip
*   Zeile 22: \x{X}

\x{je 0.5P (Summe 2P)}

\streifenend


\clearpage



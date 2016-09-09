
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

\solutionend








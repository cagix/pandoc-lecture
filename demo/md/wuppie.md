
\clearpage
\myQuestion[8]{Multiple Choice with "streifenMC" environment}

Here goes the question ...


For multiple choice questions use the `streifenMC` environment, which is a
customized LaTeX table with a gray bar on the left side. The parameters are
the column headers for correct and wrong answers/choices. 

Each line constitutes a possible answer and needs to be ended with "`\\\\`"
(remember, it is just a customized LaTeX table).

Correct answers must be started with `\wahr`, whereas wrong answers start
with `\falsch`. This will not appear in the normal exam version. In the sample 
solution, all correct answers are marked.

Since this is a LaTeX environment, we cannot use Markdown in here ... 


\begin{streifenMC}{correct}{wrOng}
    \falsch \ldots blablabla. \\[5pt]
    \wahr \ldots wuppie :) \\[5pt]
    \falsch \ldots fluppie. \\[5pt]
    \falsch \ldots foobar.
\end{streifenMC}
\x{je 0.5P (2P)}




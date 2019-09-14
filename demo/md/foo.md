
# Support for "choices" {punkte=8}

There are four environments to create multiple choice questions in the `exam` class: `choices`, `oneparchoices`,
`checkboxes`, and `oneparcheckboxes` (cf.
[exam documentation, Chap. 5 "Multiple choice ..."](http://www-math.mit.edu/~psh/exam/examdoc.pdf)).

Each of these environments can be created by using a corresponding div, which will be transformed by the `exams.lua`
filter into the LaTeX environment with a blue/gray bar on the left side. Using a fenced div you can use markdown
formatting inside the answers.

Each line constitutes a possible answer. Use a span with class `ok` (or `CorrectChoice`) for correct answers and
a span with class `nok` (or `choice`) for wrong answers. In the sample solution, all correct answers are marked.

*Note*: Since the `exam` class is used, you can also use the original environments as raw LaTeX, e.g. `\begin{choices}
... \end{choices}`. However, Pandoc would not parse any Markdown inside this environments ...


*   Choices

    ```markdown
    ::: choices
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.ok}
    :::
    ```

    ::: choices
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.ok}
    :::


*   Oneparchoices

    ```markdown
    ::: oneparchoices
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.CorrectChoice}
    :::
    ```

    ::: oneparchoices
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.CorrectChoice}
    :::


*   Checkboxes

    ```markdown
    ::: checkboxes
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.ok}
    :::
    ```

    ::: checkboxes
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.ok}
    :::


*   Oneparcheckboxes

    ```markdown
    ::: oneparcheckboxes
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.CorrectChoice}
    :::
    ```

    ::: oneparcheckboxes
    [... blablabla.]{.nok}
    [... **wuppie** :)]{.choice}
    [... *fluppie.*]{.nok}
    [... `foobar`.]{.CorrectChoice}
    :::

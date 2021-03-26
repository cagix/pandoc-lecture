$-- custom template to structure the HTML handouts



$if(titleblock)$
$titleblock$
$endif$


${ tldr.md() }
${ outcomes.md() }


$body$


${ quizzes.md() }
${ challenges.md() }
${ bib.md() }

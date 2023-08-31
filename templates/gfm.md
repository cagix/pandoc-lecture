$-- custom template to structure the GFM exports

$if(title)$
# $title$
$endif$


$if(tldr)$
## TL;DR

<details>

$tldr$

</details>
$endif$


$if(youtube)$
## Videos (YouTube)

<details>

$for(youtube)$
$if(youtube.name)$
- [$youtube.name$]($youtube.link$)
$else$
- $youtube.link$
$endif$
$endfor$

</details>
$endif$


$if(fhmedia)$
## Videos (HSBI-Medienportal)

<details>

$for(fhmedia)$
$if(fhmedia.name)$
- [$fhmedia.name$]($fhmedia.link$)
$else$
- $fhmedia.link$
$endif$
$endfor$

</details>
$endif$


$if(attachments)$
## Materialien

<details>

$for(attachments)$
$if(attachments.name)$
- [$attachments.name$]($attachments.link$)
$else$
- $attachments.link$
$endif$
$endfor$

</details>
$endif$


$if(outcomes)$
## Lernziele

<details>

$for(outcomes)$
$if(outcomes.k1)$
- K1: $outcomes.k1$
$endif$
$if(outcomes.k2)$
- K2: $outcomes.k2$
$endif$
$if(outcomes.k3)$
- K3: $outcomes.k3$
$endif$
$endfor$

</details>
$endif$


$body$


$if(quizzes)$
## Quizzes

<details>

$for(quizzes)$
$if(quizzes.name)$
- [$quizzes.name$]($quizzes.link$)
$else$
- $quizzes.link$
$endif$
$endfor$

</details>
$endif$


$if(challenges)$
## Challenges

<details>

$challenges$

</details>
$endif$


$-- TODO: we use "readings" but would probably want something like our Hugo shortcode "bib.html" or some proper Pandoc citeproc handling here ...
$-- this won't work now - leaving this open for later
$if(bib)$
## Literatur
$bib$

#### Bibliographie
${ references.md() }

$elseif(references)$
## Literatur
${ references.md() }

$else$
$--  nothing, just to complete pandoc's template syntax
$endif$
$-- TODO


## LICENSE
![](https://licensebuttons.net/l/by-sa/4.0/88x31.png)

Unless otherwise noted, this work is licensed under CC BY-SA 4.0.

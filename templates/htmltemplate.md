$if(titleblock)$
$titleblock$
$endif$


$if(tldr)$
# TL;DR {.tldr}

$tldr$


$if(screencast-iframe-url)$
<div id="screencast">
<iframe data-external="1" src="$screencast-iframe-url$" width="100%" height="100%" frameborder="0" allowfullscreen="allowfullscreen" allowtransparency="true" scrolling="no"></iframe>

$if(screencast-direct-link)$
[Direkt-Link FH-Medienportal]($screencast-direct-link$)
$endif$
</div>
$endif$
$endif$


$body$


$if(bib)$
# Literatur {.bib}

$bib$

**Bibliographie**

<div id="refs" class="references">
<!-- XXX Platzhalter für Literaturliste (References/Bibliography) -->
</div>
$endif$


$if(outcomes)$
# Lernziele

$if(outcomes.k1)$
## Kennen (K1)

$outcomes.k1$
$endif$

$if(outcomes.k2)$
## Verstehen (K2)

$outcomes.k2$
$endif$

$if(outcomes.k3)$
## Anwenden (K3)

$outcomes.k3$
$endif$

$endif$


$if(quizzes)$
# Quizzes ... {.quizzes}

$quizzes$
$endif$


$if(challenges)$
# Challenges ... {.challenges}

$challenges$
$endif$

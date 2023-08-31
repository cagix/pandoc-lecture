$if(titleblock)$
$titleblock$

$endif$
$for(header-includes)$
$header-includes$

$endfor$
$for(include-before)$
$include-before$

$endfor$
$if(toc)$
$table-of-contents$

$endif$

$if(tldr)$
## TL;DR

$tldr$
$endif$


$if(outcomes)$
## Lernziele
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
$endif$

$body$

$for(include-after)$

$include-after$
$endfor$

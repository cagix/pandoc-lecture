$-- h4 intentionally used wrongly: yields nice formatting in HTML compared to using pure bold
$-- formatted text; also it won't show up in TOC
$--
$-- if meta variable "bib" is set, use it as extra content (this would be the standard case)
$-- otherwise if meta variable "references" is set, just emit H1 to get a TOC entry and formatted
$-- text block (this would be the case for syllabus / orga material)
$-- in both cases emit a references div as target for pandoc to generate a list of references



$if(bib)$


# Literatur {.bib}
$bib$

#### Bibliographie
${ references.md() }


$elseif(references)$


# Literatur {.bib}
${ references.md() }


$else$

$--  nothing, just to complete pandoc's template syntax

$endif$

$-- if meta variable "tldr" is set, use it as extra content (this would be the standard case)
$-- otherwise if meta variable "screencast-iframe-url" is set, just emit H1 to get a TOC entry
$-- and formatted text block (this would be the case for syllabus / orga material)



$if(tldr)$


# TL;DR {.tldr}
$tldr$

${ screencast.md() }


$elseif(screencast-iframe-url)$


# TL;DR {.tldr}
${ screencast.md() }


$else$

$--  nothing, just to complete pandoc's template syntax

$endif$

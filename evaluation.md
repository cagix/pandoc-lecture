---
title: "Evaluation"
...




# Gruppeninformationen

1.  Name, Vorname: ...

\bigskip

2.  Name, Vorname: ...

\bigskip

3.  Name, Vorname: ...

\bigskip

Bewertet durch: ...




# Formale Bewertung

*   Einheitliche Formatierung des gesamten Codes (zB. K&R): bis zu -2P \dotfill [ \qquad ]

*   Doxygen-Dokumentation gemäß VL01/Orga: bis zu -4P \dotfill [ \qquad ]

*   Makefile mit (funktionierenden) Standard-Targets gemäß VL01/Orga: bis zu -2P \dotfill [ \qquad ]

*   Compiler (Abzüge kumulieren: nicht compilierfähiger Code: -6P):

    -   Warnungen/Fehler bei Aktivierung des geforderten Standards (zB. C11): bis zu -2P \dotfill [ \qquad ]

    -   Warnungen/Fehler bei `-Wall -pedantic -Werror`: bis zu -2P \dotfill [ \qquad ]

    -   Code lässt sich nicht compilieren: bis zu -2P \dotfill [ \qquad ]




# Inhaltliche Bewertung

$if(questions)$
$for(questions)$

##  Aufgabe "$questions$"

-   Testsuite: Alles OK? Tests rot (welche)?:

\smallskip

-   Code-Review (Befunde):

\bigskip
\bigskip

-   Bemerkungen, Nachfragen für Abnahme: ...
 
\bigskip
\bigskip

-   Vorstellung in Abnahme: Qualität der Antworten (führt ggf. zu Abzügen): 
 
\bigskip
\bigskip

\hfill\ Summe "$questions$": [ \qquad ]

$endfor$
$endif$




# Gesamt-Summe


| Teil                                                          | Summe      |
|:--------------------------------------------------------------|:-----------|
| Formale Bewertung (max. -14P)                                 | [ \qquad ] |
| Inhaltliche Bewertung (max. $if(points)$ ($points$P)$endif$)  | [ \qquad ] |
| **GESAMT**                                                    | [ \qquad ] |







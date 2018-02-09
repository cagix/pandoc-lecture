<!--
Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
Copyright: (c) 2016-2018 Carsten Gips
License: MIT
-->

---
title: "Evaluation"
...




# Gruppeninformationen

\begin{minipage}{118mm}
\begin{tabular}{cp{52mm}p{36mm}}\hline
    Nr. & Name & Vorname \\\hline
    1.  &&\\[11pt]
    2.  &&\\[11pt]
    3.  &&\\[11pt]\hline
\end{tabular}
\end{minipage}
\begin{minipage}{70mm}
\begin{tabular}{|l|l|}\hline
    Teil & Summe \\\hline\hline
    Formale Bewertung (max. -10P) & \\[11pt]
    Inhaltliche Bewertung $if(points)$(max. $points$P)$endif$ & \\[11pt]\hline
    \textbf{GESAMT} (min. 0P) & \\[11pt]\hline
\end{tabular}
\end{minipage}

\bigskip
Bewertet durch:




# Formale Bewertung

\begin{tabular}{|l|l|p{69mm}|l|}\hline
    Kriterium & bis zu & Notiz & Abzüge \\\hline\hline
    Einheitliche Formatierung des gesamten Codes (zB. K\&R) & -2P &&\\[11pt]\hline
    Doxygen-Dokumentation gemäß VL01/Orga vorhanden & -4P &&\\[11pt]\hline
    Makefile mit Standard-Targets gemäß VL01/Orga vorhanden & -2P &&\\[11pt]\hline
    Code lässt sich nicht kompilieren (`make all`) & -6P &&\\[11pt]
    \qquad Warnungen bei `-std=` (vgl. Vorgabe) & -2P && \\
    \qquad und `-Wall -pedantic` (\textbf{nur falls Code kompilierbar}) &&&\\[11pt]
    \qquad Test kompilieren nicht (\textbf{nur falls Code kompilierbar}) & -4P &&\\[5pt]\hline
\end{tabular}

Anmerkung: Cut-Off bei 10P: max. -10P Abzug




# Inhaltliche Bewertung

$if(questions)$
$for(questions)$

\begin{tabular}{|p{58mm}|p{107mm}|l|}\hline
    \textbf{$questions$} & Notiz & Punkte \\\hline\hline
    Testsuite: Alles OK? Tests rot (welche)? & & \\
    Code-Review (Befunde) & & \\
    Bemerkungen & & \\[5pt]
    && \\[22pt]\hline
    Nachfragen für Abnahme & & \\[22pt]\hline
\end{tabular}

$endfor$
$endif$









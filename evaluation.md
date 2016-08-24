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
    Formale Bewertung (max. -14P) & \\[11pt]
    Inhaltliche Bewertung (max. $if(points)$ ($points$P)$endif$) & \\[11pt]\hline
    \textbf{GESAMT} (min. 0P) & \\[11pt]\hline
\end{tabular}
\end{minipage}

\bigskip
Bewertet durch: 




# Formale Bewertung

\begin{tabular}{|l|l|p{69mm}|l|}\hline
    Kriterium & bis zu & Notiz & Abzüge \\\hline\hline
    Einheitliche Formatierung des gesamten Codes (zB. K\&R) & -2P &&\\[11pt]\hline
    Doxygen-Dokumentation gemäß VL01/Orga & -4P &&\\[11pt]\hline
    Makefile mit Standard-Targets gemäß VL01/Orga & -2P &&\\[11pt]\hline
    Code lässt sich nicht kompilieren & -6P &&\\[11pt]
    Warnungen bei `-std=` (vgl. Vorgabe) & -2P && \\
    und `-Wall -pedantic` (\textbf{nur falls Code kompilierbar}) &&&\\[5pt]\hline
\end{tabular}

Anmerkung: Code compiliert: max. -10P; Code compiliert **nicht**: max. -14P




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









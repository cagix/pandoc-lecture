---
title: "Evaluation"
...




# Gruppeninformationen

\begin{center}
\begin{tabular}{cp{6cm}p{6cm}}\hline
    Nr. & Name & Vorname \\\hline
    1.  &&\\[11pt]
    2.  &&\\[11pt]
    3.  &&\\[11pt]\hline
\end{tabular}
\end{center}

\bigskip
Bewertet durch: 




# Formale Bewertung

\begin{tabular}{|l|l|p{68mm}|l|}\hline
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

##  Aufgabe "$questions$"

\begin{tabular}{|l|p{107mm}|l|}\hline
    Kriterium & Notiz & Punkte \\\hline\hline
    Testsuite: Alles OK? Tests rot (welche)? & & \\
    Code-Review (Befunde) & & \\
    Bemerkungen & & \\[22pt]\hline
    Nachfragen für Abnahme & & \\[22pt]\hline
\end{tabular}

$endfor$
$endif$




# Gesamt-Summe

\begin{center}
\begin{tabular}{|lp{10mm}|l|}\hline
    Teil && Summe \\\hline\hline
    Formale Bewertung (max. -14P) && \\[11pt]
    Inhaltliche Bewertung (max. $if(points)$ ($points$P)$endif$) && \\[11pt]\hline
    \textbf{GESAMT} (min. 0P) && \\[11pt]\hline
\end{tabular}
\end{center}







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
    Compiler: Warnungen/Fehler bei `-std=` (vgl. Vorgabe) & -2P &&\\[11pt]
    Compiler: Warnungen/Fehler bei `-Wall -pedantic -Werror` & -2P &&\\[11pt]
    Compiler: Code lässt sich nicht compilieren & -2P &&\\[11pt]\hline
    \multicolumn{3}{|r|}{\textbf{Summe Formale Bewertung}} & \\[11pt]\hline
\end{tabular}

Hinweis: Abzüge bzgl. Compiler kumulieren! 
Beispiele: Nicht compilierfähiger Code: -6P (schliesst `-std=` und `-Wall ...`
ein), Warnungen bei `-Wall ...`: -4P (schliesst `-std=` ein).




# Inhaltliche Bewertung

$if(questions)$
$for(questions)$

##  Aufgabe "$questions$"

\begin{tabular}{|l|p{107mm}|l|}\hline
    Kriterium & Notiz & Punkte \\\hline\hline
    Testsuite: Alles OK? Tests rot (welche)? & & \\[11pt]\hline
    Code-Review (Befunde) & & \\[22pt]\hline
    Bemerkungen, Nachfragen für Abnahme & & \\[22pt]\hline
    Vorstellung in Abnahme & & \\[11pt]\hline
    \multicolumn{2}{|r|}{\textbf{Summe "$questions$"}} & \\[11pt]\hline
\end{tabular}

$endfor$
$endif$




# Gesamt-Summe

\begin{center}
\begin{tabular}{|lp{10mm}|l|}\hline
    Teil && Summe \\\hline\hline
    Formale Bewertung (max. -14P) && \\[11pt]
    Inhaltliche Bewertung (max. $if(points)$ ($points$P)$endif$) && \\[11pt]\hline
    \textbf{GESAMT} && \\[11pt]\hline
\end{tabular}
\end{center}







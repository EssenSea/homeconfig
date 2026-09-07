latex-mode

;; --- Environments ---
(begin "\\begin{" (p "environment") "}" n> q n> "\\end{" p "}")
(ali "\\begin{align}" n> "\\label{" q "}" n> p n> "\\end{align}")
(desc "\\begin{description}" n> "\\item[" p "]" q n> "\\end{description}")
(enum "\\begin{enumerate}" n> "\\item " q n> "\\end{enumerate}")
(it "\\begin{itemize}" n> "\\item " q n> "\\end{itemize}")
(eq "\\begin{equation}" n> "\\label{" p "}" n> q n> "\\end{equation}")

;; --- Sections ---
(sec "\\section{" (p "name") "}" n> "\\label{sec:" p "}" n> q)
(sub "\\subsection{" (p "name") "}" n> "\\label{subsec:" p "}" n> q)

;; --- Theorems / blocks ---
(thm "\\begin{thm}[" p "]" n> "  \\label{thm:" p "}" n> "  " q n> "\\end{thm}")
(corr "\\begin{cor}[" p "]" n> "  \\label{cor:" p "}" n> "  " q n> "\\end{cor}")
(lem "\\begin{lem}[" p "]" n> "  \\label{lem:" p "}" n> "  " q n> "\\end{lem}")
(bl "\\begin{block}{" p "}" n> "  " q n> "\\end{block}")
(al "\\begin{alertblock}{" p "}" n> "  " q n> "\\end{alertblock}")
(alg "\\begin{algorithmic}" n> q n> "\\end{algorithmic}")
(lst "\\begin{lstlisting}" n> q n> "\\end{lstlisting}")
(cols "\\begin{columns}" n> "  \\begin{column}{." p "\\textwidth}" n> "  " q n> "  \\end{column}" n> n> "  \\begin{column}{." p "\\textwidth}" n> n> "  \\end{column}" n> "\\end{columns}")

;; --- Math ---
(frac "\\frac{" p "}{" p "}" q)
(binom "\\binom{" (p "n") "}{" p "}" q)
(int "\\int_{" p "}^{" p "}" q)
(sum "\\sum_{" p "}^{" p "}" q)
(prod "\\prod_{" p "}^{" p "}" q)
(bigcap "\\bigcap_{" p "}^{" p "}" q)
(bigcup "\\bigcup_{" p "}^{" p "}" q)

;; --- Inline markup ---
(e "\\emph{" p "}" q)
(b "\\textbf{" p "}" q)
(lr "\\left(" q " \\right)")

;; --- Floats ---
(fig "\\begin{figure}[ht]" n> "  \\centering" n> "  \\includegraphics[" (p "options") "]{figures/" (p "path.pdf") "}" n> "  \\caption{\\label{fig:" p "} " q "}" n> "\\end{figure}")
(subfig "\\begin{figure}[ht]" n> "  \\centering" n> "  \\subfigure[" p "]" n> "  {\\label{fig:" p "}" n> "    \\includegraphics[width=." p "\\textwidth]{" p "}}" n> n> "  \\caption{" p "}" n> "\\label{fig:" p "}" n> "\\end{figure}")
(sf "\\subfigure[" p "]{" n> "  \\label{fig:" p "}" n> "  \\includegraphics[width=." p "\\textwidth]{" p "}}" n> q)

;; --- Lists / items ---
(- "\\item " q)
(if "\\IF {$" (p "cond") "$}" n> "  " q n> "\\ELSE" n> "\\ENDIF")

;; --- Document structure ---
(doc "\\documentclass[" p "]{" p "}" n> q)
(article "\\documentclass[" (p "options") "]{article}" n> n> "\\author{" p "}" n> n> "\\begin{document}" n> q n> "\\end{document}")
(moderncv "\\documentclass[" p "]{moderncv}" n> n> "\\firstname{" p "}" n> "\\familyname{" p "}" n> n> "\\moderncvstyle{" p "}" n> "\\moderncvcolor{" p "}" n> n> "\\begin{document}" n> q n> "\\end{document}")

;; --- Cross references / glossaries ---
(ca "\\caption{" q "}")
(lab "\\label{" q "}")
(c "\\cite{" p "} " q)
(lref "\\labelcref{" q "}")
(g "\\gls{" p "}" q)
(gp "\\glspl{" p "}" q)
(G "\\Gls{" p "}" q)
(gl "\\newglossaryentry{" p "}{name=" p "}")
(ac "\\newacronym{" p "}{" p "}{" p "}")

;; --- Packages / commands ---
(pkg "\\usepackage{" q "}")
(cmd "\\newcommand{\\" p "}" p "{" q "}")
(ig "\\includegraphics" p "{" q "}")
(note "\\note{" q "}")
(q "\\question{" q "}")
(fr "\\begin{frame}" p n> "  " p n> "  " q n> "\\end{frame}")
(movie "\\begin{center}" n> "\\includemovie[" n> "  label=test," n> "  controls=false," n> "  text={\\includegraphics[width=4in]{" p "}}" n> "]{4in}{4in}{" p "}" n> n> "\\movieref[rate=3]{test}{Play Fast}" n> "\\movieref[rate=1]{test}{Play Normal Speed}" n> "\\movieref[rate=0.2]{test}{Play Slow}" n> "\\movieref[resume]{test}{Pause/Resume}")

;; --- moderncv entries ---
(cvcomp "\\cvcomputer{" p "}{" p "}{" p "}{" p "}" n> q)
(cventry "\\cventry{" p "}{" p "}{" p "}{" p "}{" p "}" n> q)
(cvlang "\\cvlanguage{" p "}{" p "}{" p "}" n> q)
(cvline "\\cvline{" p "}{" p "}" n> q)
(cvditem "\\cvlistdoubleitem{" p "}{" p "}" n> q)
(cvitem "\\cvlistitem{" p "}" n> q)

;; --- German quotes ---
(gqq "\\glqq{}" q "\\grqq{}")
(gq "\\glq{}" q "\\grq{}")
(py "\\lstset{language=python}" n> "\\begin[language=python]{lstlisting}" n> q n> "\\end{lstlisting}")
(code "\\begin{lstlisting}" n> q n> "\\end{lstlisting}")

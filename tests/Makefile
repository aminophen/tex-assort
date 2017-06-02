KANJI = -kanji=utf8

.PHONY: test files cleanup
test:
	perl ../dviinfox.pl font.dvi >font.lg2.tmp
	diff font.lg2.tmp font.lg2
	perl ../dviinfox.pl font.xdv >font.lg7.tmp
	diff font.lg7.tmp font.lg7
	perl ../dviinfox.pl -f font.dvi >font-f.lg2.tmp
	diff font-f.lg2.tmp font-f.lg2
	perl ../dviinfox.pl -f font.xdv >font-f.lg7.tmp
	diff font-f.lg7.tmp font-f.lg7
	perl ../dviinfox.pl -p font.dvi >font-p.lg2.tmp
	diff font-p.lg2.tmp font-p.lg2
	perl ../dviinfox.pl -p font.xdv >font-p.lg7.tmp
	diff font-p.lg7.tmp font-p.lg7
	perl ../dviinfox.pl playtate.dvi >playtate.lg3.tmp
	diff playtate.lg3.tmp playtate.lg3
	perl ../dviinfox.pl native.xdv >native.lg7.tmp
	diff native.lg7.tmp native.lg7
	rm -f *.tmp

files: font.dvi font.xdv playtate.dvi native.xdv

playtate.dvi: playtate.tex
	ptex $(KANJI) $<

.SUFFIXES: .tex .dvi .xdv
.tex.dvi:
	latex $<
.tex.xdv:
	xelatex -no-pdf $<

cleanup:
	rm -f *.dvi *.log *.aux *.toc *.out *.pdf

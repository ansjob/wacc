DOCUMENT_NAME = report
all: $(DOCUMENT_NAME).pdf 

PDFTEXFLAGS = "--shell-escape"

$(DOCUMENT_NAME).pdf: $(DOCUMENT_NAME).tex sources.tex
	pdflatex $(PDFTEXFLAGS) $(DOCUMENT_NAME).tex
	bibtex $(DOCUMENT_NAME)
	pdflatex $(PDFTEXFLAGS) $(DOCUMENT_NAME).tex
	pdflatex $(PDFTEXFLAGS) $(DOCUMENT_NAME).tex

open : $(DOCUMENT_NAME).pdf
	google-chrome $(DOCUMENT_NAME).pdf

clean:
	@rm -f *.blg *.log *.aux *.bbl $(DOCUMENT_NAME).pdf


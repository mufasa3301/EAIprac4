# Ensure that the report is created by default.
all: report.pdf

# The PDF files that must not be deleted on clean.
save_files = report.pdf

# Everything after this point is automatic.

## Find all the figures from the GnuPlot files.
#gnuplot_figures = $(shell grep output *gp | egrep -v "^\#" | cut -d \' -f 2)
## This rule ensures that all the GnuPlot scripts are called.
## The only problem is that all GnuPlot scripts are run whenever one of
##  them is changed.
## The third and fourth for loops line the x-axis labels up with the tics.
#$(gnuplot_figures) : $(wildcard *gp)
#	for i in $^; do gnuplot $$i; done
#	for i in $(gnuplot_figures); do \
#		#echo $$i ; \
#	 	cat $$i | sed s/"Rounded false def"/"Rounded true def"/ > abc; \
#		mv abc $$i; done
#	#for i in $(gnuplot_figures:.eps=.tex); do if [ -e $$i ]; then cat	\
#	#	$$i | sed s/"strut{} "/"strut{}"/g > abc; mv abc $$i; fi; done
#	#for i in $(gnuplot_figures); do if [ -e $$i ]; then \
#	#	cat $$i | sed s/"true true 0 ( "/"true true 0 ("/g > abc; mv abc $$i; fi; done

# In conjunction with the relevant implicit rule at the end of this
#  file, all Inkscape files are found and converted to PDFs.
inkscape_figures = $(wildcard drawings/*.svgz)

# In conjunction with the relevant implicit rule at the end of this
#  file, all EPS files are found and converted to PDFs.
eps_figures = $(wildcard *.eps)

# Implicit rule to convert from eps to pdf.
%.pdf : %.eps ; epstopdf $^ ; pdfcrop $@ $@
# Implicit rule to convert from svgz to pdf.  The export text to path
#  option does not seem to be required for pdf files.  
%.pdf : %.svgz ; inkscape -D $^ -A $@
# Implicit rule to convert from svgz to eps.
%.eps : %.svgz ; inkscape -T $^ -E $@

# Rule to make the report.
# The Inkscape and GnuPlot dependencies are for the relevant .pdf files.
# The report will be recompiled whenever any of the .cls files changes.
#report.pdf : report.tex *.cls abbreviations.tex report.bbl
report.pdf : $(eps_figures:.eps=.pdf) $(inkscape_figures:.svgz=.pdf) *.tex *.cls *.bib	\
  *.bst
	pdflatex report &> /dev/null
	makeglossaries report &> /dev/null
	bibtex report &> /dev/null
	pdflatex report &> /dev/null
	pdflatex --synctex=1 report &> /dev/null
#	ps2pdf -dUseFlateCompression=true -dOptimize=true -dEmbedAllFonts=true report.pdf
#	mv report.pdf.pdf report.pdf

report_small.pdf : report.pdf
	ps2pdf -dUseFlateCompression=true -dOptimize=true -dEmbedAllFonts=true	\
	  -dPDFSETTINGS=/ebook report.pdf report_small.pdf

# Remove temporary files.
# The for loop ensures that the files I need to keep are not deleted.
clean :
	for i in $(save_files); do if [ -e $$i ]; then mv $$i $$i.bak; fi; done
	rm -f $(gnuplot_figures:.eps=.tex) killme* diff.tex *synctex.gz *.abr *.acn *.acr  \
	  *.alg *.aux *.bbl *.blg *.dvi *.glg *.glo *.gls *.ini *.ist *.lof *.log *.lot    \
	  *.out *.pdf *.tmp *.toc
	for i in $(save_files); do if [ -e $$i.bak ]; then mv $$i.bak $$i; fi; done
	rm `find -iname "*.svgz"  | sed s/svgz/pdf/`
	find -iname "doc_data.txt" -delete
	find -iname "\#*" -delete
	find -iname "*~" -delete

# Make a backup.
backup : report.pdf clean
	rm -f ../`pwd | rev | cut -d \/ -f1 | rev`_`date +%Y%m%d_%H%M`.*
	#tar cf ../`pwd | rev | cut -d \/ -f1 | rev`_`date +%Y%m%d_%H%M`.tar	./
	#pbzip2 ../`pwd | rev | cut -d \/ -f1 | rev`_`date +%Y%m%d_%H%M`.tar
	zip -qr ../`pwd | rev | cut -d \/ -f1 | rev`_`date +%Y%m%d_%H%M`.zip ./ 
	#rar -r a ../`pwd | rev | cut -d \/ -f1 | rev`_`date +%Y%m%d_%H%M`.rar ./

all: slides.pdf

slides.pdf: slides.Rmd
	R -e "rmarkdown::render('slides.Rmd')"

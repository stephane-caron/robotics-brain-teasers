# Adapted from https://blog.nanax.fr/post/2018-05-04-pandoc-latex/
# Copyright 2016–2024 erdnaxe, licensed under a CC-BY-4.0 International License

SHELL=/bin/bash

SRC = $(filter-out README.md,$(wildcard *.md))
BIB = references.bib
BUILDDIR = build/

DEPS = $(wildcard *.sty *.tex *.jpg *.png)
HTML_TARGETS = $(addprefix $(BUILDDIR),$(addsuffix .html,$(SRC:.md=)))
PDF_TARGETS = $(addprefix $(BUILDDIR),$(addsuffix .pdf,$(SRC:.md=)))

# HTML5 settings
HTML_PARAMETERS = --katex= --standalone --to=html5

# Change LaTeX engine
PDF_PARAMETERS = --pdf-engine=xelatex

# Custom LaTeX header
PDF_PARAMETERS += --include-in-header=templates/header.tex

# Bibliography
PDF_PARAMETERS += --bibliography=references.bib

# Table of contents
# PDF_PARAMETERS += --toc

# Link citations with pandoc-citeproc
PDF_PARAMETERS += -M link-citations=true

all: builddir $(HTML_TARGETS) $(PDF_TARGETS) index

builddir:
	mkdir -p $(BUILDDIR)
	cp -r figures/ $(BUILDDIR)

index: builddir $(PDF_TARGETS)
	@cp -f "$(CURDIR)/templates/katex.min.css" "$(BUILDDIR)/"
	@cp -f "$(CURDIR)/templates/katex.min.js" "$(BUILDDIR)/"
	@cp -f "$(CURDIR)/templates/header.html" "$(BUILDDIR)/index.html"
	@(cd $(BUILDDIR); for f in *.pdf; do \
		echo "            <li>$${f/.pdf/}: <a href=\"$${f/.pdf/.html}\">HTML</a>, <a href=\"$$f\">PDF</a></li>" >> index.html; \
		done)
	@cat "$(CURDIR)/templates/footer.html" >> $(BUILDDIR)/index.html

$(BUILDDIR)%.html : %.md $(DEPS)
	@mkdir -p $(BUILDDIR) # Make sure build dir exists
	pandoc $(HTML_PARAMETERS) $< -o $@

$(BUILDDIR)%.pdf : %.md $(DEPS)
	@mkdir -p $(BUILDDIR) # Make sure build dir exists
	pandoc $(PDF_PARAMETERS) $< -o $@

clean:
	@rm -f $(BUILDDIR)/index.html
	@rm -f $(PDF_TARGETS)
	@rmdir $(BUILDDIR)

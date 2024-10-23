# Adapted from https://blog.nanax.fr/post/2018-05-04-pandoc-latex/
# Copyright 2016–2024 erdnaxe, licensed under a CC-BY-4.0 International License

SHELL=/bin/bash

SRC = $(wildcard problems/*.md)
BIB = references.bib
BUILDDIR = build

DEPS = $(wildcard *.sty *.tex *.jpg *.png)
HTML_TARGETS = $(addprefix $(BUILDDIR)/,$(SRC:.md=.html))
PDF_TARGETS = $(addprefix $(BUILDDIR)/,$(SRC:.md=.pdf))

# HTML5 settings
HTML_PARAMETERS = --katex= --standalone --to=html5

# PDF settings
PDF_PARAMETERS = --pdf-engine=xelatex
PDF_PARAMETERS += -V "documentclass:article"
PDF_PARAMETERS += -V "fontsize:12pt"
PDF_PARAMETERS += --include-in-header=templates/header.tex

all: builddir $(HTML_TARGETS) $(PDF_TARGETS) index

builddir:
	mkdir -p $(BUILDDIR)/problems
	cp -r figures/ $(BUILDDIR)/

index: builddir $(PDF_TARGETS)
	cp -f "$(CURDIR)/templates/katex.min.css" "$(BUILDDIR)/"
	cp -f "$(CURDIR)/templates/katex.min.js" "$(BUILDDIR)/"
	cp -f "$(CURDIR)/templates/header.html" "$(BUILDDIR)/index.html"
	(cd $(BUILDDIR); for f in problems/*.pdf; do \
		bf=$$(basename $$f); \
		echo "            <li>$${bf/.pdf/}: <a href=\"$$f\">PDF</a> (<a href=\"$${f/.pdf/.html}\">HTML</a>)</li>" >> index.html; \
		done)
	cat "$(CURDIR)/templates/footer.html" >> $(BUILDDIR)/index.html

$(BUILDDIR)/%.html : %.md $(DEPS)
	pandoc $(HTML_PARAMETERS) $< -o $@

$(BUILDDIR)/%.pdf : %.md $(DEPS)
	pandoc $(PDF_PARAMETERS) $< -o $@

clean:
	rm -rf $(BUILDDIR)

open:
	firefox $(BUILDDIR)/index.html

# Adapted from https://blog.nanax.fr/post/2018-05-04-pandoc-latex/
# Copyright 2016–2024 erdnaxe, licensed under a CC-BY-4.0 International License
# Copyright 2024 Inria

SHELL=/bin/zsh

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

build: builddir $(PDF_TARGETS)
	cp -f "$(CURDIR)/templates/katex.min.css" "$(BUILDDIR)/"
	cp -f "$(CURDIR)/templates/katex.min.js" "$(BUILDDIR)/"
	cp -f "$(CURDIR)/templates/header.html" "$(BUILDDIR)/index.html"
	(cd $(BUILDDIR); for f in problems/*.pdf; do \
		bf=$$(basename $$f); \
		echo "            <li><a href=\"$$f\">$${bf/.pdf/}</a></li>" >> index.html; \
		done)
	cat "$(CURDIR)/templates/footer.html" >> $(BUILDDIR)/index.html

builddir:
	mkdir -p $(BUILDDIR)/problems
	cp -r figures/ $(BUILDDIR)/

$(BUILDDIR)/%.html : %.md $(DEPS)
	pandoc $(HTML_PARAMETERS) $< -o $@

$(BUILDDIR)/%.pdf : %.md $(DEPS)
	pandoc $(PDF_PARAMETERS) $< -o $@

clean:
	rm -rf $(BUILDDIR)

open:
	firefox $(BUILDDIR)/index.html

watch:
	while [ 1 ]; do; inotifywait $(SRC) && make build; done

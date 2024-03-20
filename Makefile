# Adapted from https://blog.nanax.fr/post/2018-05-04-pandoc-latex/
# Copyright 2016–2024 erdnaxe, licensed under a CC-BY-4.0 International License

SRC = $(filter-out README.md,$(wildcard *.md))
BIB = references.bib
BUILDDIR = build/

DEPS = $(wildcard *.sty *.tex *.jpg *.png)
TARGET = $(addprefix $(BUILDDIR),$(addsuffix .pdf,$(SRC:.md=)))

# Change LaTeX engine
PARAMETERS = --pdf-engine=xelatex

# Custom LaTeX header
PARAMETERS += --include-in-header=templates/header.tex

# Bibliography
PARAMETERS += --bibliography=references.bib

# Table of contents
# PARAMETERS += --toc

# Link citations with pandoc-citeproc
PARAMETERS += -M link-citations=true

all: $(TARGET)
	@mkdir -p $(BUILDDIR)
	@cp -f "$(CURDIR)/templates/header.html" "$(BUILDDIR)/index.html"
	@(cd $(BUILDDIR); for f in *.pdf; do \
		echo "            <li><a href=\"$$f\">$$f</a></li>" >> index.html; \
		done)
	@cat "$(CURDIR)/templates/footer.html" >> $(BUILDDIR)/index.html

$(BUILDDIR)%.pdf : %.md $(DEPS)
	@mkdir -p $(BUILDDIR) # Make sure build dir exists
	pandoc $(PARAMETERS) $< -o $@

clean:
	@rm -f $(BUILDDIR)/index.html
	@rm -f $(TARGET)
	@rmdir $(BUILDDIR)

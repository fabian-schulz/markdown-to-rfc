IMAGE ?= ghcr.io/fabian-schulz/markdown-to-rfc:latest

# Tools (override on command line if needed)
DOCKER ?= docker

# Docker Executables
KRAMDOC ?= $(DOCKER) run --rm -v "$(PWD):/workspace" -w /workspace $(IMAGE) kramdown-rfc
XML2RFC ?= $(DOCKER) run --rm -v "$(PWD):/workspace" -w /workspace $(IMAGE) xml2rfc

# Local Executables (xml2rfc requires many fonts for pdfs)
# KRAMDOC ?= kramdown-rfc
# XML2RFC ?= xml2rfc

# Source and derived file lists
EXCLUDE_MD ?= README.md
MD := $(filter-out $(EXCLUDE_MD),$(wildcard *.md))
XML := $(MD:.md=.xml)

# Derive from XML for correct time stamps
HTML := $(XML:.xml=.html)
PDF := $(XML:.xml=.pdf)
TEXT := $(XML:.xml=.txt)

.PHONY: all clean pdf text html

all:  pdf text html

pdf: $(PDF)

text: $(TEXT)

html: $(HTML)

PREFIX := rfc

# MD -> XML
%.xml: %.md
	@printf "\033[34m%s: Generating %s from %s...\033[0m\n" "$(PREFIX)" "$@" "$<"
	@$(KRAMDOC) $< > $@

# XML -> HTML
%.html: %.xml
	@printf "\033[34m%s: Converting %s -> %s...\033[0m\n" "$(PREFIX)" "$<" "$@"
	@$(XML2RFC) --html $< > $@

# XML -> TEXT
%.txt: %.xml
	@printf "\033[34m%s: Converting %s -> %s...\033[0m\n" "$(PREFIX)" "$<" "$@"
	@$(XML2RFC) --text $< > $@

# XML -> PDF
%.pdf: %.xml
	@printf "\033[34m%s: Converting %s -> %s...\033[0m\n" "$(PREFIX)" "$<" "$@"
	@$(XML2RFC) --pdf $< > $@

# Clear generated files
clean:
	rm -f $(XML) $(HTML) $(PDF) $(TEXT)

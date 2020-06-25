SRC = $(wildcard *.md)
RECIPES_SRC = $(wildcard recipes/*.md)
RECIPES_IMG_SRC = $(wildcard recipes/images/*)

RECIPES_HTML=$(RECIPES_SRC:%.md=build/%.html)
RECIPES_IMG=$(RECIPES_IMG_SRC:%=build/%)
PDFLAGS = -s --template template.html -f markdown-smart -t html

all: build/index.html $(RECIPES_HTML) $(RECIPES_IMG)

build/index.html: index.md template.html
	pandoc $(PDFLAGS) -o build/index.html index.md --metadata title="Lannysport"

build/recipes/%.html: recipes/%.md
	pandoc $(PDFLAGS) -o $@ $< --filter ./prettify_fractions.py

build/recipes/images/%.jpg: recipes/images/%.jpg
	cp $< $@

clean:
	rm -r build/

$(shell mkdir -p build/recipes/images)

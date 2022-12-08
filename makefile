SRC = $(wildcard *.md)
RECIPES_SRC = $(wildcard recipes/*.md)
RECIPES_IMG_SRC = $(wildcard recipes/images/*)
WRITING_SRC = $(wildcard writing/*.md)

RECIPES_HTML=$(RECIPES_SRC:%.md=build/%.html)
RECIPES_IMG=$(RECIPES_IMG_SRC:%=build/%)
WRITING_HTML=$(WRITING_SRC:%.md=build/%.html)

PDFLAGS = -s --template template.html -f markdown-smart -t html

all: build/index.html $(RECIPES_HTML) $(RECIPES_IMG) $(WRITING_HTML)

install:
	cp -r build/* ${out}

build/index.html: index.md template.html
	pandoc $(PDFLAGS) -o build/index.html index.md --metadata title="Lannysport"

build/recipes/%.html: recipes/%.md
	pandoc $(PDFLAGS) -o $@ $< --filter ./prettify_fractions.py

build/recipes/images/%.jpg: recipes/images/%.jpg
	cp $< $@

build/writing/%.html: writing/%.md
	mkdir -p build/writing
	pandoc $(PDFLAGS) -o $@ $<

clean:
	rm -r build/

$(shell mkdir -p build/recipes/images)

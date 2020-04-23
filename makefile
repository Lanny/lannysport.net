SRC = $(wildcard *.md)
RECIPES_SRC = $(wildcard recipes/*.md)
RECIPES_HTML=build/$(RECIPES_SRC:.md=.html)
PDFLAGS = -s --template template.html -f markdown-smart -t html

all: build/index.html $(RECIPES_HTML)

build/index.html: index.md template.html
	pandoc $(PDFLAGS) -o build/index.html index.md --metadata title="Lannysport"

build/recipes/%.html: recipes/%.md
	pandoc $(PDFLAGS) -o $@ $<

clean:
	rm -r build/

$(shell mkdir -p build/ build/recipes)

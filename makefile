SRC = $(wildcard *.md)
HTML=build/$(SRC:.md=.html)
PDFLAGS = -s --template template.html -f markdown-smart -t html 

all: $(HTML)

build/index.html: index.md template.html
	pandoc $(PDFLAGS) -o build/index.html index.md --metadata title="Lannysport"

clean:
	rm -r build/

.PHONY: install
install: $(HTML)
	cp -r build/* /opt/lannysport

$(shell mkdir -p build/)

SRC = $(wildcard *.md)
HTML=build/$(SRC:.md=.html)
PDFLAGS = -s --template template.html -f markdown -t html 

all: $(HTML)

build/%.html: %.md
	pandoc $(PDFLAGS) -o $@ $<

clean:
	rm -r build/

.PHONY: install
install: $(HTML)
	cp -r build/* /opt/lannysport

$(shell mkdir -p build/)

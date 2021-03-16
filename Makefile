NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

.PHONY: all append-timestamp build build-json clean

all: clean build append-timestamp
	@echo "$(OK_COLOR)==> Done!$(NOCOLOR)"

append-timestamp: build
	@echo "$(OK_COLOR)==> Appending timestamp to index.html!$(NOCOLOR)"
	@echo "<!-- Deploy Timestamp: $(shell date --iso-8601=seconds) -->" >> public/index.html
	@echo "<!-- SHA: $(GITHUB_SHA) -->" >> public/index.html

build-json:
	@echo "$(OK_COLOR)==> Converting csv files into a single json… $(NO_COLOR)"
	@cat src/data/*.csv | jq -sRf src/csvtojson.jq > src/data/data.json

build: clean build-json
	@echo "$(OK_COLOR)==> Building static page… $(NO_COLOR)"
	@mkdir public
	@cp src/index.html public/index.html
	@cp src/script.js public/script.js
	@cp src/data/data.json public/data.json

clean:
	@echo "$(OK_COLOR)==> Cleaning project… $(NO_COLOR)"
	@rm -rf ./src/data/data.json
	@rm -rf ./public

TOOL 		:= $(TOOL)
VERSION := $(VERSION)

base: base-build base-publish

base-build:
	docker build -t teamon/alpine-asdf-pre:3.6 .

base-publish:
	docker push teamon/alpine-asdf-pre:3.6

builder:
	docker build -t asdf-pre-builder builder

tool: tool-build tool-package tool-upload

tool-build:
	mkdir -p "_build/$(TOOL)"
	docker run --rm -it -v "$$(pwd)/_build:/build" asdf-pre-builder "$(TOOL)" "$(VERSION)"

tool-package:
	cd "_build/$(TOOL)" && tar czf "$(VERSION).tgz" "$(VERSION)"

tool-upload:
	aws s3 cp "_build/$(TOOL)/$(VERSION).tgz" "s3://asdf-pre/alpine/$(TOOL)/$(VERSION).tgz" --acl public-read

test:
	docker build -t asdf-pre-test test
	docker run --rm -it asdf-pre-test /bin/bash -c "elixir --version"

ls:
	aws s3 ls --recursive --human-readable "s3://asdf-pre"

build-all:
	./script/configure.sh && make -j 8 -f script/Makefile.tools all

.PHONY: base base-build base-publish builder tool tool-package tool-upload test ls

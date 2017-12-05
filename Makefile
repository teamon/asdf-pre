TOOL 		:= $(TOOL)
VERSION := $(VERSION)

base: base-build base-publish

base-build:
	docker build -t teamon/alpine-asdf-pre:3.6 .

base-publish:
	docker push teamon/alpine-asdf-pre:3.6

builder:
	docker build -t asdf-pre-builder builder

tool: tool-package tool-upload

tool-build: 	_build/$(TOOL)/$(VERSION)
tool-package: _build/$(TOOL)/$(VERSION).tgz
tool-upload:
	aws s3 cp "_build/$(TOOL)/$(VERSION).tgz" "s3://asdf-pre/alpine/$(TOOL)/$(VERSION).tgz" --acl public-read

tool-available:
	aws s3 ls "s3://asdf-pre/alpine/$(TOOL)/$(VERSION).tgz"

build-debug:
	docker run --rm -it -v "$$(pwd)/_build:/build" --entrypoint /bin/bash asdf-pre-builder

_build/$(TOOL)/$(VERSION):
	mkdir -p "_build/$(TOOL)"
	docker run --rm -it -v "$$(pwd)/_build:/build" asdf-pre-builder "$(TOOL)" "$(VERSION)"

_build/$(TOOL)/$(VERSION).tgz: _build/$(TOOL)/$(VERSION)
	cd "_build/$(TOOL)" && tar czf "$(VERSION).tgz" "$(VERSION)"

test:
	script/test.sh

ls:
	aws s3 ls --recursive --human-readable "s3://asdf-pre"

.PHONY: base base-build base-publish builder tool tool-package tool-upload test ls

TOOL 		:= $(TOOL)
VERSION := $(VERSION)
IMAGE   := teamon/alpine-asdf-pre:3.6
S3 			:= s3://asdf-pre/alpine

base: base-build base-publish

base-build:
	docker build -t $(IMAGE) .

base-publish:
	docker push $(IMAGE)


tool: tool-package tool-upload

tool-build: 	_build/$(TOOL)/$(VERSION)
tool-package: _build/$(TOOL)/$(VERSION).tgz
tool-upload:
	aws s3 cp \
		"_build/$(TOOL)/$(VERSION).tgz" \
		"$(S3)/$(TOOL)/$(VERSION).tgz" \
		--acl public-read

tool-available:
	aws s3 ls "$(S3)/$(TOOL)/$(VERSION).tgz"

debug:
	mkdir -p "_build/$(TOOL)"
	docker run --rm -it \
		-v "$$(pwd)/_build:/build" \
		-v "$$(pwd)/script:/script" \
		$(IMAGE) \
		/bin/bash

_build/$(TOOL)/$(VERSION):
	mkdir -p "_build/$(TOOL)"
	docker run --rm -it \
		-v "$$(pwd)/_build:/build" \
		-v "$$(pwd)/script:/script" \
		$(IMAGE) \
		/script/build.sh "$(TOOL)" "$(VERSION)"

_build/$(TOOL)/$(VERSION).tgz: _build/$(TOOL)/$(VERSION)
	cd "_build/$(TOOL)" && tar czf "$(VERSION).tgz" "$(VERSION)"

test:
	script/test.sh

ls:
	aws s3 ls --recursive --human-readable $(S3)

.PHONY: base base-build base-publish tool tool-upload debug test ls

#!/bin/bash

tools="erlang nodejs"
targets=""

echo "all: build-all" > script/Makefile.tools
for tool in $tools; do
  versions=$(asdf list-all $tool)

  for version in $versions; do
    # targets="$targets _build/$tool/$version.tgz"
    targets="$targets _build/$tool/$version"

    echo -e "_build/$tool/$version.tgz: _build/$tool/$version"  >> script/Makefile.tools
    echo -e "\tTOOL=$tool VERSION=$version make tool-package"   >> script/Makefile.tools
    echo                                                        >> script/Makefile.tools
    echo -e "_build/$tool/$version:"                            >> script/Makefile.tools
    echo -e "\tTOOL=$tool VERSION=$version make tool-build"     >> script/Makefile.tools
    echo                                                        >> script/Makefile.tools
  done
done

echo "build-all: $targets" >> script/Makefile.tools

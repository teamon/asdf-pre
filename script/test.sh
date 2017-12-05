#!/bin/sh

set -e

mkdir -p test && cd test

command=""
case $TOOL in
  "nodejs")
    echo "$TOOL $VERSION" > .tool-versions
    command="node --version"
    ;;
  "elixir")
    echo "erlang 20.1" > .tool-versions
    echo "elixir $VERSION" >> .tool-versions
    command="elixir --version"
    ;;
  "erlang")
    echo "$TOOL $VERSION" > .tool-versions
    command="erl -eval 'halt()'"
    ;;
esac

docker run --rm -it -v $(pwd):/test \
  teamon/alpine-asdf-pre:3.6 \
  /bin/bash -c "cd test && asdf-pre install && $command"

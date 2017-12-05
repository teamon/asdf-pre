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
    echo "erlang $TEST_ERLANG_VERSION" > .tool-versions
    echo "elixir $VERSION" >> .tool-versions
    command="elixir --version"
    ;;
  "erlang")
    echo "$TOOL $VERSION" > .tool-versions
    command="erl -eval 'halt()'"
    ;;
esac

docker run --rm -v $(pwd):/test \
  teamon/alpine-asdf-pre \
  /bin/bash -c "cd test && asdf-pre install && $command"

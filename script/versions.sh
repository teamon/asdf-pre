#!/bin/bash

tools="erlang elixir nodejs"
for tool in $tools; do
  versions=$(asdf list-all $tool)
  for version in $versions; do
    echo "  - TOOL=$tool VERSION=$version"
  done
done

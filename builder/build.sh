#!/bin/sh

set -e

tool="$1"
version="$2"

asdf plugin-add $tool
asdf install $tool $version

mkdir -p /build/$tool
mv /asdf/.asdf/installs/$tool/$version /build/$tool/$version

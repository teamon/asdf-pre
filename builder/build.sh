#!/bin/sh

set -e

tool="$1"
src_version="$2"
dst_version="$2"

asdf plugin-add $tool

# tool-specific adjustments
case $tool in
  "nodejs")
    export NODEJS_CHECK_SIGNATURES=no
    src_version="ref:v$src_version"
    ;;

  *)
    ;;
esac

echo "==> Building $tool $src_version => $dst_version"

asdf install $tool $src_version

mkdir -p /build/$tool
mv /asdf/.asdf/installs/$tool/$src_version /build/$tool/$dst_version

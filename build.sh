#!/bin/bash
set -ex

for MANYLINUX in "2014"; do
  docker build --rm -t mtgupf/essentia-builds:manylinux${MANYLINUX}_x86_64 -f Dockerfile-manylinux${MANYLINUX}_x86_64 .
done

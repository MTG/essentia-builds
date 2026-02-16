#!/bin/bash
set -ex

for MANYLINUX in "_2_28"; do
  docker build --rm -t mtgupf/essentia-builds:manylinux${MANYLINUX}_$PLATFORM -f Dockerfile-manylinux${MANYLINUX}_x86_64 .
done

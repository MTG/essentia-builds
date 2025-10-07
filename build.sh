#!/bin/bash
set -ex

for MANYLINUX in "_2_28"; do
    for PLATFORM in "i686" "x86_64"; do
        docker build --rm -t mtgupf/essentia-builds:manylinux${MANYLINUX}_$PLATFORM -f Dockerfile-manylinux${MANYLINUX}_$PLATFORM .
    done
done

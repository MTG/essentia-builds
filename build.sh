#!/bin/bash
set -ex

for PLATFORM in "i686" "x86_64"; do
    docker build --rm -t manylinux1_$PLATFORM -f Dockerfile-$PLATFORM .
done

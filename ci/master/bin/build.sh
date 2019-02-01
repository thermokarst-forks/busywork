#!/bin/bash

set -e -v

# tell conda to "relax" (https://github.com/conda/conda/issues/7788#issuecomment-446051125)
echo "allow_conda_downgrades: true" >> ~/.condarc

conda upgrade -q -y -c defaults --override-channels conda
conda install -q -y -c defaults --override-channels conda-build conda-verify

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
cd ./source
git fetch --tags
conda build -q $CHANNELS \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c defaults \
  --override-channels --output-folder $BUILD_DIR ci/recipe

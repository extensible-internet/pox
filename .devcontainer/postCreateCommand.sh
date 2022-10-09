#/usr/bin/env bash

cd ext
git clone git@github.com:extensible-internet/ei.git

cd ei
scripts/build_all.sh --install --with-tests --clean --parallel

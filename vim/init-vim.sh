#!/bin/bash

mkdir -p bundle

git clone https://github.com/gmarik/vundle.git bundle/vundle
vim +BundleInstall +qall

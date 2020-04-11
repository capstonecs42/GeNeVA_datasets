#!/bin/bash

set -e

function download () {
    URL=$1
    TGTDIR=.
    if [ -n "$2" ]; then
        TGTDIR=$2
        mkdir -p $TGTDIR
    fi
    echo "Downloading ${URL} to ${TGTDIR}"
    wget $URL -P $TGTDIR
}


# get CoDraw GitHub repository
if [ ! -d raw-data/CoDraw/asset ]
then
    git clone https://github.com/capstonecs42/CoDraw.git raw-data/CoDraw
fi

# get CoDraw individual json files
if [ ! -d raw-data/CoDraw/output ]
then
    cd raw-data/CoDraw
    if [ ! -f dataset/CoDraw_1_0.json ]
    then
        if [ ! -f gdown.pl ]
        then
            wget https://raw.githubusercontent.com/circulosmeos/gdown.pl/master/gdown.pl
            chmod +x gdown.pl
        fi
        ./gdown.pl https://drive.google.com/file/d/0B-u9nH58139bTy1XRFdqaVEzUGs/view dataset/CoDraw_1_0.json
    fi
    python script/preprocess.py dataset/CoDraw_1_0.json
    rm dataset/CoDraw_1_0.json
    cd ../../
fi

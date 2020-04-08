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

# GloVe data
if [ ! -f raw-data/GloVe/glove.840B.300d.txt ]
then
    download http://nlp.stanford.edu/data/glove.840B.300d.zip
    mkdir --parents raw-data/GloVe
    unzip glove.840B.300d.zip glove.840B.300d.txt -d raw-data/GloVe
    rm -f glove.840B.300d.zip
fi

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

# get CoDraw background image and object names
if [ ! -f raw-data/CoDraw/background.png ]
then
    ./gdown.pl https://drive.google.com/file/d/1tJjvMFRSCR5lkQBpKnlP6XKrXwcQS2sU/view?usp=sharing ./bg_names.zip
    unzip -j bg_names.zip AbstractScenes_v1.1/Pngs/background.png -d raw-data/CoDraw
    unzip -j bg_names.zip AbstractScenes_v1.1/VisualFeatures/10K_instance_occurence_58_names.txt -d raw-data/CoDraw
    rm bg_names.zip
fi

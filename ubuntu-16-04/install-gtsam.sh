#!/bin/bash

PREFIX=/usr/ANPLprefix
PROJECT_DIR=~/ANPL/code/3rdparty
FROM_GIT=True
GTSAM_VER="3.2.1"
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX -DGTSAM_BUILD_TESTS=OFF -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF -DCMAKE_BUILD_TYPE=Release"
LINK="https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-$GTSAM_VER.zip"
GIT_LINK="https://bitbucket.org/gtborg/gtsam/ -b fix/boost158gtsam3"


sudo apt-get install libboost-all-dev libtbb-dev -y


sudo rm -rf $PROJECT_DIR/gtsam-$GTSAM_VER

if [ "$FROM_GIT" = True ]; then
    cd $PROJECT_DIR
    git clone $GIT_LINK gtsam-$GTSAM_VER
else
    # download file to Download folder
    cd ~/Downloads
    wget -O gtsam-$GTSAM_VER.zip $LINK
    unzip gtsam-$GTSAM_VER.zip -d $PROJECT_DIR
    rm -f ~/Downloads/gtsam-$GTSAM_VER.zip
fi

cd $PROJECT_DIR/gtsam-$GTSAM_VER

#from https://collab.cc.gatech.edu/borg/gtsam/#quickstart

mkdir build && cd build
cmake $CMAKE_FLAGS ..
make -j7
sudo make install -j7


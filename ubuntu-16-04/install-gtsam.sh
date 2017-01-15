#!/bin/bash


#check matlab version
MATLAB_VER=`matlab -e | grep -E -o R[0-9]+[ab] |uniq`
CMAKE_FLAGS=""
PREFIX=~/prefix
PROJECT_DIR=~/ANPL/code/3rdparty
GTSAM_VER="3.2.1"
FROM_GIT=True

install-modules.sh
install-gcc5.sh

#if there is matlab install on the machine
if [ ! -z "$MATLAB_VER" ]; then
	#flags for matlab
    CMAKE_FLAGS="-DGTSAM_INSTALL_MATLAB_TOOLBOX=ON -DMEX_COMMAND=/usr/local/MATLAB/$MATLAB_VER/bin/mex $CMAKE_FLAGS"
fi

CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX $CMAKE_FLAGS"

sudo rm -rf $PROJECT_DIR/gtsam-$GTSAM_VER

if [ ! "$FROM_GIT" = True ]; then
    # download file to Download folder
    cd ~/Downloads
    wget -O gtsam-$GTSAM_VER.zip "https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-$GTSAM_VER.zip"
    unzip gtsam-$GTSAM_VER.zip -d $PROJECT_DIR
    rm -f ~/Downloads/gtsam-$GTSAM_VER.zip
else
    cd $PROJECT_DIR
    git clone https://bitbucket.org/gtborg/gtsam/ -b fix/boost158gtsam3 gtsam-$GTSAM_VER
fi

cd $PROJECT_DIR/gtsam-$GTSAM_VER

#from https://collab.cc.gatech.edu/borg/gtsam/#quickstart

mkdir build && cd build
cmake $CMAKE_FLAGS -DCMAKE_CXX_FLAGS="-DBOOST_ALL_NO_LIB -DBOOST_ALL_DYN_LINK -DBOOST_LOG_DYN_LINK" ..
make -j7
sudo make install -j7

echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:~/prefix/lib">>~/.bashrc
if [ ! -z "$MATLAB_VER" ]; then
    #save matlab the path for gtsam toolbox
    sudo matlab -nodesktop -nosplash -r "addpath(genpath('$PREFIX/gtsam_toolbox'));savepath;exit;"
fi
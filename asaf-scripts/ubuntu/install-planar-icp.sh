#!/bin/bash

PREFIX=/usr/ANPLprefix
PROJECT_DIR=~/ANPL/code/3rdparty
FOLDER_NAME=planar_icp
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release"

install-csm.sh

sudo rm -rf $PROJECT_DIR/$FOLDER_NAME

cd $PROJECT_DIR
git clone https://bitbucket.org/ANPL/planar_icp $FOLDER_NAME
cd $FOLDER_NAME

mkdir build && cd build
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:~/prefix/lib/pkgconfig/
cmake $CMAKE_FLAGS ..
make -j7
sudo make install -j7

sudo mkdir -p $PREFIX/include/$FOLDER_NAME
cd $PROJECT_DIR/$FOLDER_NAME/cpp
sudo cp -f *.h $PREFIX/include/$FOLDER_NAME
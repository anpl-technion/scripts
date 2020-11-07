PREFIX=/usr/ANPLprefix
FROM_GIT=true
OMPL_VER="1.4.2"
PROJECT_DIR=~/ANPL/code/3rdparty
PROJECT_NAME=ompl
SUB_PROJECT_NAME=ompl
FOLDER_NAME=$PROJECT_NAME-$OMPL_VER
FILE_NAME=$FOLDER_NAME.zip
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DOMPL_BUILD_DEMOS=OFF -DOMPL_BUILD_PYBINDINGS=OFF -DOMPL_BUILD_PYTESTS=OFF -DOMPL_REGISTRATION=OFF -DOMPL_BUILD_TESTS=OFF"

GIT_LINK="https://github.com/ompl/omplapp.git -b 1.4.2"
SUB_GIT_LINK="https://github.com/ompl/ompl.git -b 1.4.2"
FILE_LINK=https://bitbucket.org/ompl/ompl/downloads/ompl-$OMPL_VER-Source.zip
if [ "$#" -eq  "0" ]; then
    FROM_APT=true
else
    if [ "$#" -eq  "1" ]; then
        FROM_APT=$(echo $1 | sed "s/^--apt=\(.*\)$/\1/")
    else
        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        echo "'${0##*/}' Too many arguments provided. Please rerun script"    
        exit  
    fi
fi

if [ $FROM_APT = true ]; then
    # sudo apt-get autoremove libompl-dev 
    sudo apt-get install libompl-dev -y
    exit
fi

#from: http://ompl.kavrakilab.org/download.html
sudo rm -rf $PROJECT_DIR/$FOLDER_NAME

if [ "$FROM_GIT" = true ]; then
    cd $PROJECT_DIR
    git clone $GIT_LINK $FOLDER_NAME
    cd $FOLDER_NAME
    git clone $SUB_GIT_LINK $SUB_PROJECT_NAME
else

    cd ~/Downloads
    wget -O $FILE_NAME $FILE_LINK
    unzip $FILE_NAME -d $PROJECT_DIR
    rm -f ~/Downloads/$FILE_NAME
    cd $PROJECT_DIR/
    mv $FOLDER_NAME-Source $FOLDER_NAME
fi

#Hack that make omplapp find libccd and libfcl
cd ~/Downloads
wget https://raw.githubusercontent.com/dartsim/dart/master/cmake/FindCCD.cmake
wget https://raw.githubusercontent.com/dartsim/dart/master/cmake/FindFCL.cmake
mv FindCCD.cmake FindFCL.cmake $PROJECT_DIR/$FOLDER_NAME/CMakeModules

cd $PROJECT_DIR/$FOLDER_NAME
mkdir build && cd build
cmake $CMAKE_FLAGS ..
make -j7       
sudo make install -j7


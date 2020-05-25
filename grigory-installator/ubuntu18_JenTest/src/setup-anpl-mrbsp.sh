#!/bin/bash
WS_NAME=mrbsp_ws
WS_PATH=~/ANPL/infrastructure/$WS_NAME
WS_SRC=$WS_PATH/src
PREFIX=/usr/ANPLprefix
if [ "$#" -ne  "2" ]; then
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "'${0##*/}' Error: not all arguments provided. Please rerun script"    
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"   
	exit 0 
else
	for i in "$@"; do
	case $i in
	    -b=*|--branch=*)
		    BRANCH="${i#*=}" && shift # past argument=value
	    ;;
		-i=*|--infrastructure=*)
		    PROJECT_NAME="${i#*=}" && shift # past argument=value
		;;
	    *)
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		echo "'${0##*/}' ${i}: Unknown argument provided. Please rerun script"    
		exit 
		;;
	esac
	done
fi

#from http://wiki.ros.org/catkin/Tutorials/create_a_workspace
# 2 Prerequisitesoos
sudo rm -rf $WS_PATH

mkdir -p $WS_PATH/src && cd $WS_PATH
source /opt/ros/$ROS_DISTRO/setup.bash
catkin init
catkin build && wait $!

cd $WS_SRC

if [ ! -d "$WS_SRC/pioneer_keyop" ]; then
  git clone https://bitbucket.org/ANPL/pioneer_keyop
fi
TMP=0
if [ ! -d "$WS_SRC/$PROJECT_NAME" ]; then
  git clone -b $BRANCH https://bitbucket.org/ANPL/$PROJECT_NAME.git $WS_SRC/$PROJECT_NAME && TMP=1
	if [ $TMP -eq 1 ]; then
	echo "'${0##*/}' SUCCEED"
else
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"    
 	echo "'${0##*/}' FAILED"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	exit
fi 
fi


echo "source $WS_PATH/devel/setup.bash" >> ~/.bashrc
source $WS_PATH/devel/setup.bash

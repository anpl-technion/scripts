#!/bin/bash
echo -e "\033[0;36mWelcome to ANPL's Multi-Robot Belief Space Planner open source installator!"
echo -e "Before installation please check if you have account @BitBucket and have full access to ANPL repository. If you don't please contact Vadim to get an access.\033[0m"
while true; do
    read -p "Do you wish to continue?[Y/n]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if ([ -z "$ROS_DISTRO" ] || [ -z "$(which git)" ]); then
	echo -e "Some of the dependecies is not presented on computer. Please make sure you installed ROS and GIT and then relaunch the script. "
	exit
fi

echo -e "\033[0;42m Choosing Infrastructure \033[0m"
read -p "Choose which infrastructure you want: 
	1 - (anpl_mrbsp[NEW])
	2 - (mrbsp_ros[OLD]):    " NUM
echo
case $NUM in
	[1]* ) PROJECT_NAME=anpl_mrbsp
		echo -e "\033[0;42m Choosing Branch \033[0m"
		read -p "Choose which branch you want:
		1 - (master[Lidar-gtsam3])
		2 - (gtsam4[Lidar-gtsam4]):   " NUM
		echo
		case $NUM in
			[1]* ) BRANCH=master;;
			[2]* ) BRANCH=gtsam4;;
       			* ) echo "Please answer 1 or 2. Rerun setup-anpl-mrbsp.sh"
			exit ;;
		esac;;
	[2]* ) PROJECT_NAME=mrbsp_ros
		echo -e "\033[0;42m Choosing Branch \033[0m"
		read -p "Choose which branch you want:
		1 - (t-bsp-julia[Lidar])
		2 - (or-vi_project[ORB-vsion]):   " NUM
		echo
		case $NUM in
			[1]* ) BRANCH=t-bsp-julia;;
        	[2]* ) BRANCH=or-vi_project;;
       		* ) echo "Please answer 1 or 2. Rerun setup-anpl-mrbsp.sh"
			exit ;;
		esac;;
        * ) echo "Please answer 1 or 2. Rerun sutup-anpl-mrbsp.sh"
	exit ;;
esac


cd src/
echo "export PATH=$PATH:$(pwd)" >> ~/.bashrc
source ~/.bashrc


bash install-ros-melodic.sh
bash install-gtsam4.sh
sleep 1
echo "ROS_DISTRO = " $ROS_DISTRO
sleep 1
bash install-ros-packages.sh 
bash setup-anpl-mrbsp.sh --infrastructure=$PROJECT_NAME --branch=$BRANCH

source ~/.bashrc

# carkin belief:
bash install-libspdlog.sh --apt=false #(apt=false, from git) - mrbsp_utils wanted it
bash install-octomap.sh 	#(apt ros-melodic-octomap) - mrbsp_msgs wanted it [sudo update and upgrade]
bash install-libccd.sh --apt=false #(AG need it - apt=false)
bash install-libfcl.sh --apt=true #(AG need it - apt=true)
bash install-ompl.sh   --apt=true #(AG need it, apt=true)

LINES_TO_BE_COMMENTED=('list(APPEND CMAKE_MODULE_PATH ${ANPL_PREFIX}/share/cmake)' 'set(OMPL_PREFIX ${ANPL_PREFIX})')
PATH_AG_CMAKE=~/ANPL/infrastructure/mrbsp_ws/src/anpl_mrbsp/action_generator/CMakeLists.txt
for line in "${LINES_TO_BE_COMMENTED[@]}"
do
	sed -i "s|${line}|#${line}|" $PATH_AG_CMAKE
done

bash install-diverse-short-path.sh 	#(AG need it)
bash install-csm.sh --apt=false		#(git=true)

LINES_TO_BE_COMMENTED=('#ifndef min' '#define min(a,b) ((a) < (b) ? (a) : (b))' '#endif' '#ifndef max' '#define max(a,b) ((a) > (b) ? (a) : (b))')
PATH_JSON_C_BITS=/usr/ANPLprefix/include/json-c/bits.h
for line in "${LINES_TO_BE_COMMENTED[@]}"
do
	sudo sed -i "s|${line}|//${line}|" $PATH_JSON_C_BITS
done
#sudo echo "#endif" >> $PATH_JSON_C_BITS
echo "#endif" | sudo tee -a $PATH_JSON_C_BITS

bash install-planar-icp.sh --branch=$BRANCH #(branch gtsam4)
sudo cp -r cmake /usr/ANPLprefix/share/

sudo apt-get install xterm -y

if [ -f "~/.ignition/fuel/config.yaml" ]; then 
	sed -i "s+https://api.ignitionfuel.org+https://api.ignitionrobotics.org+g" ~/.ignition/fuel/config.yaml
fi

echo -e "\033[0;36m ++++  End of installation ++++    \033[0m"


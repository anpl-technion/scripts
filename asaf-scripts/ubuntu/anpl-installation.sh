#!/bin/bash

echo "Welcome to ANPL enviroment installation"
echo "Enter installation type: admin [a] or user [u]:"

read installation_type

if [ $installation_type == 'a' ]; then
  echo "starting admin installation"
  ./setup-ubuntu-env.sh
  ./install-git.sh
  ./install-dos2unix.sh
  ./clone-scripts.sh
  ./setup-scripts-env-ubuntu.sh
  #gnome-terminal -e "admin-installation.sh"
  echo "Quit and run in a new terminal: \"admin-installation.sh\""

elif [ $installation_type == 'u' ]; then
  echo "starting user installation"
  ./setup-ubuntu-env.sh
  ./clone-scripts.sh
  ./setup-scripts-env-ubuntu.sh
  #gnome-terminal -e "user-installation.sh"
  echo "Quit and run in a new terminal: \"user-installation.sh\""

else
  echo "Wrong input. quitting..."
  exit 1

fi
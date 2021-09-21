#!/bin/bash

echo "[Update the package lists and upgrade them]"
sudo apt update
sudo apt upgrade -y
sudo apt install curl -y

echo "[-------------------------------------------------------> ROS <--------------------------------------------------------]"
echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
fi

echo "[Update the package lists and upgrade them]"
sudo apt update -y
sudo apt upgrade -y

echo "[Install the ros-desktop-full]"
sudo apt install -y ros-noetic-desktop-full

echo "[Environment setup and getting rosinstall]"
source /opt/ros/noetic/setup.sh
sudo apt-get install python3-rosdep python3-rosinstall-generator python3-vcstool build-essential

echo "[Install Catkin tool]"
sudo apt install -y python3-catkin-lint python3-pip
pip3 install osrf-pycommon
sudo apt install -y python3-catkin-tools

sudo rosdep init
rosdep update

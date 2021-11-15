#!/bin/bash

echo "[Update the package lists and upgrade them]"
sudo apt update
sudo apt upgrade -y
sudo apt install curl terminator git snap gnupg2 lsb-release -y

echo "[Install VSCode and GitKraken]"
sudo snap install --classic code
sudo snap install --classic gitkraken

echo "[Install Docker]"
https://docs.docker.com/engine/install/ubuntu/
https://docs.docker.com/engine/install/linux-postinstall/
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker 
# docker run hello-world

echo "[Install ROS Noetic]"
# http://wiki.ros.org/noetic/Installation/Ubuntu
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
fi

sudo apt update
sudo apt install -y ros-noetic-desktop-full
source /opt/ros/noetic/setup.sh
sudo apt-get install -y python3-rosdep python3-rosinstall-generator python3-vcstool build-essential python3-pip
sudo pip3 install -U catkin_tools

sudo rosdep init
rosdep update

echo "[Install ROS2 Foxy]"
# https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html
locale  # check for UTF-8

sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo sed -i -e 's/ubuntu .* main/ubuntu focal main/g' /etc/apt/sources.list.d/ros2.list
sudo apt update
sudo apt install -y ros-foxy-desktop

echo "[Install CUDA]"
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_network
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda

echo "[Install NVIDIA Container]"
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
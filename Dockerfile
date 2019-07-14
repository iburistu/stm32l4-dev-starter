# This docker image is built on ubuntu
FROM ubuntu:latest
# Install sudo and add user `docker`
RUN apt-get update -y && apt-get install sudo -y &&adduser --disabled-password --gecos '' docker && adduser docker sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# Switch to docker user
USER docker
# Set dependency work directory
WORKDIR /home/docker/deps/
# Install dependencies
RUN sudo apt-get install gcc g++ autoconf automake libusb-1.0-0-dev gcc-arm-none-eabi libnewlib-arm-none-eabi cmake build-essential wget unzip -y && sudo wget -N http://web.eece.maine.edu/~hummels/classes/ece486/src/stmdevel.zip && sudo unzip -d stmdevel stmdevel.zip && cd stmdevel/build && sudo make && sudo make install
# Set development work directory
WORKDIR /home/docker/src/
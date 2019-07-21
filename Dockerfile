# This docker image is built on ubuntu
FROM ubuntu:latest AS builder
# Install sudo and add user `docker`
RUN apt-get update -y \
    && apt-get install sudo -y \
    && adduser --disabled-password --gecos '' docker \
    && adduser docker sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
# Switch to docker user
USER docker
# Set dependency work directory
WORKDIR /home/docker/deps/
# Install dependencies
RUN sudo apt-get -y \
    install \
    gcc \
    g++ \
    autoconf \
    automake \
    libusb-1.0-0-dev \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    make \
    wget \
    unzip

# Retrieve source and build libece486 library
RUN sudo wget -N http://web.eece.maine.edu/~hummels/classes/ece486/src/stmdevel.zip \
    && sudo unzip -d stmdevel stmdevel.zip \
    && cd stmdevel/build \
    && sudo make \ 
    && sudo make install

# Retrieve prebuilt libraries
WORKDIR /usr/local/stmdev/lib/

RUN sudo wget -N https://github.com/iburistu/stm32l4-dev-starter/releases/download/v1.0/prebuilt.zip \
    && sudo unzip prebuilt.zip \
    && sudo chmod -x * \
    && sudo rm prebuilt.zip

# Second stage: copy all built files into a clean ubuntu image and minimize dependencies
FROM ubuntu:latest
RUN apt-get update \
    && apt-get -y install \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    make \
    vim \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/stmdev /usr/local/stmdev
# Set development work directory
WORKDIR /home/docker/src/
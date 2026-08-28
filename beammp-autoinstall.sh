#!/bin/bash

set -e

echo "beammp-autoinstall version 1.1.0"

############################################################
### Container manager check | Package install if missing ###
if
  command -v podman > /dev/null 2>&1; then CONTAINER_MANAGER="podman"
  elif
  command -v docker > /dev/null 2>&1; then CONTAINER_MANAGER="docker"
    
  else
    if
      # Handle the most stupid problem I've seen: openjdk on gentoo installs /usr/bin/apt.
      # It throws off the package-manager detection... this is ridicolous 
      (command -v apt | command -v emerge) > /dev/null 2>&1; then sudo sh -c "$PORTAGE"
      elif
      command -v apt > /dev/null 2>&1; then sudo sh -c "$APT"
      elif
      command -v pacman > /dev/null 2>&1; then sudo sh -c "$PACMAN"
      elif
      command -v emerge > /dev/null 2>&1; then sudo sh -c "$PORTAGE"
    fi
fi
###########################################################
######################## Variables ########################
APT="apt install podman-docker -y"
PACMAN="pacman -S --needed --noconfirm docker"
PORTAGE="emerge -qU app-containers/podman"

BUILD="$CONTAINER_MANAGER build --no-cache -t beammp-build:test ."
RUN="$CONTAINER_MANAGER run --name beammp-container --replace beammp-build:test"
COPY="$CONTAINER_MANAGER cp beammp-container:/home/BeamMP-Launcher ."
STOP="$CONTAINER_MANAGER stop beammp-container"
###########################################################
################### Dockerfile creation ###################
tee Dockerfile > /dev/null << 'EOF'
# Base image
FROM ubuntu:24.04

# Install apt-utils because otherwise shit happens, and install dependencies
RUN apt-get update && apt-get full-upgrade -y && apt-get install -y \
    apt-utils \
    git \
    curl \
    cmake \
    build-essential \
    pkg-config \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# We run what we need to run
RUN cd /tmp && \
    git clone https://github.com/microsoft/vcpkg.git && \
    git clone https://github.com/BeamMP/BeamMP-Launcher.git && \
    ./vcpkg/bootstrap-vcpkg.sh && \
    export VCPKG_ROOT="$(pwd)/vcpkg" && \
    export PATH=$VCPKG_ROOT:$PATH && \
    mkdir -p ./BeamMP-Launcher/bin && \
    cd ./BeamMP-Launcher/ && \
    cmake . -B bin -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-linux && \
    cmake --build bin --parallel && \
    cp bin/BeamMP-Launcher /home/
EOF
###########################################################
##### Build the container, execute it, copy file to . #####
    echo "Building container, cloning packages and compiling launcher..."
sh -c "$BUILD" || sudo sh -c "$BUILD"
    echo "Done! Now we mount the container and copy the launcher"
sh -c "$RUN" > /dev/null || sudo sh -c "$RUN" > /dev/null
sh -c "$COPY" > /dev/null || sudo sh -c "$COPY" > /dev/null
sh -c "$STOP" > /dev/null || sudo sh -c "$STOP" > /dev/null
    echo "Done! You will find the launcher in the folder you executed the script from!"
    echo "You can now close the terminal"
rm Dockerfile

###########################################################
###### Script made by pure spite, by @gabriele2000 ########

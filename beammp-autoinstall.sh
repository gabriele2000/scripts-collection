#!/bin/bash

set -e

################## Package manager check ##################
if
    (command -v apt || command -v pacman) > /dev/null 2>&1; then CONTAINER_MANAGER="docker"
    elif
        command -v emerge > /dev/null 2>&1; then CONTAINER_MANAGER="podman"
    
    else
        exit 1
fi
###########################################################
######################## Variables ########################
APT="apt install docker -y"
PACMAN="pacman -S --needed --noconfirm docker"
GENTOO="emerge -qU app-containers/podman"

BUILD="$CONTAINER_MANAGER build -t beammp-build:test ."
RUN="$CONTAINER_MANAGER run --name beammp-container --replace beammp-build:test"
COPY="$CONTAINER_MANAGER cp beammp-container:/home/BeamMP-Launcher ."
STOP="$CONTAINER_MANAGER stop beammp-container"
###########################################################
##################### Package install #####################
if
    (command -v docker || command -v podman) > /dev/null 2>&1; then true
    
    elif
        command -v apt > /dev/null 2>&1; then sudo sh -c "$APT"
    elif
        command -v pacman > /dev/null 2>&1; then sudo sh -c "$PACMAN"
    elif
        command -v emerge > /dev/null 2>&1; then sudo sh -c "$GENTOO"            
    
    else
        exit 1
fi
###########################################################
################### Dockerfile creation ###################
tee Dockerfile > /dev/null << 'EOF'
# Base image
FROM ubuntu:22.04

# Let's install the dependencies using the package manager
RUN apt-get update && apt-get install -y \
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
sh -c "$BUILD" > /dev/null || sudo sh -c "$BUILD" > /dev/null || exit 2
    echo "Done! Now we mount the container and copy the launcher"
sh -c "$RUN" > /dev/null || sudo sh -c "$RUN" > /dev/null || exit 3
sh -c "$COPY" > /dev/null || sudo sh -c "$COPY" > /dev/null || exit 4
sh -c "$STOP" > /dev/null || sudo sh -c "$STOP" > /dev/null || exit 5
    echo "Done! You will find the launcher in the folder you executed the script from!"
    echo "You can now close the terminal"
###########################################################
###################### Handle errors ######################
errors()
{
    case $1 in
        1) message="Valid package manager not found";;
        2) message="Build failed inside docker container";;
        3) message="Failed to run the container, file will not be copied";;
        4) message="Failed to copy the built Launcher from the container... are permissions ok?";;
        5) message="Failed to stop the container";;
    esac
  
    echo "$message" >&2
    exit "$1"
}
###########################################################
###### Script made by pure spite, by @gabriele2000 ########

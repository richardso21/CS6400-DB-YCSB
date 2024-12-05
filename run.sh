#!/bin/bash

set -e # Exit on error

# Ensure that all submodules are installed and up-to-date
git submodule update --init --recursive

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, please install Docker first."
    exit
fi

# If `--force-run`, then build and run the container regardless
if [ "$1" == "--force-run" ]; then
    echo "Force run flag detected. Removing existing container if it exists..."
    docker rm -f db-ycsb-container
    echo "Building and running the container..."
    docker build -t db-ycsb-image .
    docker run -it --name db-ycsb-container db-ycsb-image
elif [ "$(docker ps -aq -f name=db-ycsb-container)" ]; then
    # otherwise, start the existing container
    echo "Container db-ycsb-container already exists. Starting the container..."
    docker start -i db-ycsb-container
else
    echo "Container db-ycsb-container does not exist. Building and running the container..."
    docker build -t db-ycsb-image .
    docker run -it --name db-ycsb-container db-ycsb-image
fi

#!/bin/bash

# Ensure that all submodules are installed and up-to-date
git submodule update --init --recursive

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, please install Docker first."
    exit
fi

# Check if the container already exists
if [ "$(docker ps -aq -f name=db-ycsb-container)" ]; then
    echo "Container db-ycsb-container already exists. Starting the container..."
    docker start -i db-ycsb-container
else
    echo "Container db-ycsb-container does not exist. Building and running the container..."
    # Build the Docker image for amd64 architecture
    docker build --platform linux/amd64 -t db-ycsb-image .
    docker run -it --platform linux/amd64 --name db-ycsb-container db-ycsb-image
fi

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

# Parse flags
YCSB_NATIVE=false
FORCE_RUN=false

for arg in "$@"
do
    case $arg in
        --native)
        echo "Running the container natively (get ready for compiler errors if running on Apple Silicon!)..."
        echo "NOTE: If a container already exists, the existing arch type will be used."
        echo "(Use with --force-run to rebuild w/ native arch.)"
        YCSB_NATIVE=true
        shift
        ;;
        --force-run)
        echo "Force run flag detected."
        FORCE_RUN=true
        shift
        ;;
    esac
done

function run_container() {
    if [ "$YCSB_NATIVE" == "true" ]; then
        docker build -t db-ycsb-image .
        docker run \
            --mount type=bind,source="$(pwd)"/,target=/app \
            -it --name db-ycsb-container db-ycsb-image
    else
        docker build --platform linux/amd64 -t db-ycsb-image .
        docker run \
            --mount type=bind,source="$(pwd)"/,target=/app \
            -it --platform linux/amd64 --name db-ycsb-container db-ycsb-image
    fi
}

# If `--force-run`, then build and run the container regardless
if [ "$FORCE_RUN" == "true" ]; then
    echo "Removing existing container if it exists..."
    docker rm -f db-ycsb-container
    echo "Building and running the container..."
    run_container
elif [ "$(docker ps -aq -f name=db-ycsb-container)" ]; then
    # otherwise, start the existing container
    echo "Container db-ycsb-container already exists. Starting the container..."
    docker start -i db-ycsb-container
else
    echo "Container db-ycsb-container does not exist. Building and running the container..."
    run_container
fi

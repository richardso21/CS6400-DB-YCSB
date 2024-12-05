FROM ubuntu:latest

# Update the package list and install core packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    vim \
    git

# Install packages specific to the YCSB & YCSB-cpp projects
RUN apt-get install -y \
    cmake make autoconf \
    openjdk-17-jdk \
    maven \
    librocksdb-dev \
    libleveldb-dev \
    libaio-dev \
    python-is-python3

# Install gcc-12 for terarkdb compilation
RUN apt-get install -y gcc-12 g++-12

# Remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# # build terarkdb for cpp tests (TODO: make this conditional based on what test is being run)
# WORKDIR /app/YCSB-cpp/terarkdb/terarkdb
# RUN WITH_TESTS=OFF WITH_ZNS=OFF ./build.sh

# Set the working directory
WORKDIR /app

# Define the command to run the application
CMD ["bash"]

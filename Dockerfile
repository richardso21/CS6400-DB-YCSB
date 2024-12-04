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
    libaio-dev

# Use gcc-12 instead of 13 (for terarkdb)
RUN apt-get install -y gcc-12 g++-12
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100

# Remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# build terarkdb for cpp tests
WORKDIR /app/YCSB-cpp/terarkdb/terarkdb
RUN WITH_TESTS=OFF WITH_ZNS=OFF ./build.sh

# Set the working directory
WORKDIR /app

# Define the command to run the application
CMD ["bash"]

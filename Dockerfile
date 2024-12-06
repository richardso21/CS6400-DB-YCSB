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

# build terarkdb for cpp tests (compiles on gcc-12)
# WORKDIR /app/YCSB-cpp/terarkdb/terarkdb
# RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100
# RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100
# RUN WITH_TESTS=OFF WITH_ZNS=OFF ./build.sh

# Compile all relevant Java DBs
# WORKDIR /app/YCSB
# RUN mvn -pl site.ycsb:mapdb-binding -am clean package -Psource-run
# RUN mvn -pl site.ycsb:mapdb-binding -am package -Psource-run
# RUN mvn -pl site.ycsb:halodb-binding -am package -Psource-run
# RUN mvn -pl site.ycsb:rocksdb-binding -am package -Psource-run

# Set the working directory
WORKDIR /app

# Define the command to run the application
CMD ["bash"]

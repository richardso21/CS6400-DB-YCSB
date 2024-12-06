#!/bin/bash
# This script is used to build all DB bindings used in this project
# It should be RUN ONLY ONCE, in the Docker container!

set -e

# Ensure that this is being run in the Docker container
if [ ! -f /.dockerenv ]; then
    echo "This script should only be run in the Docker container."
    exit
fi

# maven build all DB bindings
cd YCSB
mvn -pl site.ycsb:xodus-binding,site.ycsb:mapdb-binding,site.ycsb:halodb-binding,site.ycsb:rocksdb-binding -am clean package -Psource-run
cd /app

# # build terarkdb w/ gcc-12
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100
# cd YCSB-cpp/terarkdb/terarkdb && WITH_TESTS=OFF WITH_ZNS=OFF ./build.sh

# # reset back
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 101
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 101
# cd /app

# CS6400 Semester Project: Exposing the “Bleeding-Edge” of Modern Embedded Key-Value Databases

- _Members: Richard So, Nandha Sundaravadivel, Drumil Deliwala, Saatvik Agrawal_

### In this Project
- **YCSB (forked from brianfrankcooper/YCSB)**: Java YCSB Project containing our custom bindings for MapDB, Xodus & HaloDB
- **YCSB (forked from ls4154/YCSB-cpp)**: C++ YCSB Project containing our custom bindings for TerarkDB, UnQLite, & Speedb
- **YCSB.py**: Script to simplify running YCSB benchmarks against our custom Java bindings
- **YCSB-cpp.py**: Script to simplify running YCSB benchmarks against our custom C++ bindings

### Prerequisites
  - Docker
  - (Optional) x86-64 architecture (for compatibility with some Java bindings)
    - Apple Silicon is compatible, but benchmarks will be emulated via Rosetta

### Running The Project
1. Enter the docker container by running `./run.sh`
    - This will recursively clone all submodules, spin up the docker container,
      and mount the current directory to `/app`
2. Compile YCSB Bindings (this will take a few minutes)
 `./build_bindings.sh`
    - Specifically, this builds all Java bindings through maven, terarkdb, and speedb
3. Run benchmarks!

### Running Benchmarks
- For Java projects: `python3 YCSB.py [-h] -w {a,b,c,d,e,f} -db {rocksdb,xodus,halodb,mapdb}`
- For C++ Projects: `python3 YCSB-cpp.py [-h] -w {a,b,c,d,e,f} -db {rocksdb,unqlite,terarkdb,speedb}`

- `-w` refers to the benchmark workload [sequence character](https://github.com/brianfrankcooper/YCSB/tree/master/workloads)

### Collecting data for graphing
- For C++ projects: ```python get_data.py```
- For Java projects: Comment out the 1 line under each comment saying # C++. Then, uncomment the 1 line under each comment saying # Java. Then run ```python get_data.py```
Then, use this gist to input the dict outputted by the script: https://gist.github.com/SaatvikAgrawal/6c78464ab4d49ac19e9c61f367fd0d6a

### Key Takeaways
- RocksDB remains a solid choice for most (if not all) workloads
- Bold claims made by competitors/forks (namely TerarkDB) are overstated
- C++ bindings are naturally faster than Java counterparts
  - Probably isn't worth the overhead of linker errors or managing CMake (with the exception of UnQLite)
- Choose MapDB or UnQLite for a simple API with low resource footprint
- Speedb seems to be the only promising alternative to RocksDB out of our tested bindings
# CS6400 Semester Project: Exposing the “Bleeding-Edge” of Modern Embedded Key-Value Databases

### In this Project
- **YCSB (forked from brianfrankcooper/YCSB)**: Java YCSB Project containing our custom bindings for MapDB, Xodus & HaloDB
- **YCSB (forked from ls4154/YCSB-cpp)**: C++ YCSB Project containing our custom bindings for TerarkDB & UnQLite
- **YCSB.py**: Script to simplify running YCSB benchmarks against our custom Java bindings
- **YCSB-cpp.py**: Script to simplify running YCSB benchmarks against our custom C++ bindings

### Running The Project
1. Enter the docker container by running ```./run.sh``` 
2. Compile YCSB Bindings (this will take a few minutes)
 ```./build_bindings.sh```
3. Run benchmarks!

### Running Benchmarks
- For Java projects: `python3 YCSB.py [-h] -w {a,b,c,d,e,f} -db {rocksdb,xodus,halodb,mapdb}`
- For C++ Projects: `python3 YCSB-cpp.py [-h] -w {a,b,c,d,e,f} -db {rocksdb,unqlite,terarkdb}`

- `-w` refers to the benchmark workload [sequence character](https://github.com/brianfrankcooper/YCSB/tree/master/workloads) 
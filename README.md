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

### Collecting data for graphing
- For C++ projects: ```python get_data.py```
- For Java projects: Comment out the 1 line under each comment saying # C++. Then, uncomment the 1 line under each comment saying # Java. Then run ```python get_data.py```
Then, use this gist to input the dict outputted by the script: https://gist.github.com/SaatvikAgrawal/6c78464ab4d49ac19e9c61f367fd0d6a

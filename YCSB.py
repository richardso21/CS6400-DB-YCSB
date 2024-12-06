import argparse, subprocess

parser = argparse.ArgumentParser(description="Command line tool")

parser.add_argument('-w', type=str, required=True, choices=['a', 'b', 'c', 'd'. 'e', 'f'],
                    help="Workload character")

parser.add_argument('-db', type=str, choices=['rocksdb', 'xodus', 'halodb', 'mapdb'],
                    help="Specify the database (e.g., 'rocksdb')")


args = parser.parse_args()

move_cmd = "cd YCSB"
load_workload_cmd = f"bin/ycsb.sh load {args.db} -P workloads/workload{args.w}"
run_workload_cmd = f"bin/ycsb.sh load {args.db} -P workloads/workload{args.w}"

if args.db == "rocksdb":
    load_workload_cmd += f"rocksdb.dir=/tmp/rocksdb-ycsb-data"

combinator = " && "
complete_cmd = combinator.join([move_cmd, load_workload_cmd, run_workload_cmd])

result = subprocess.call(complete_cmd, shell=True)
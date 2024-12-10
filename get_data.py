import subprocess
import re
import csv
import argparse

workloads = ['a', 'b', 'c', 'd', 'e', 'f']
# Java
# databases = ['rocksdb', 'xodus', 'halodb', 'mapdb']
# C++
databases = ["rocksdb", "unqlite", "terarkdb"]


def run_ycsb(workload, database):
    # Java
    # command = f"python /app/YCSB.py -w {workload} -db {database}"
    # C++
    command = f"python /app/YCSB-cpp.py -w {workload} -db {database}"

    result = subprocess.run(command.split(), capture_output=True, text=True, check=True)
    output = result.stdout
    print(output)
    return output

def get_data(output):
    metrics = {}
    patterns = {
        "Throughput" : r"\[OVERALL\], Throughput\(ops\/sec\), ([\d.]+)",
        "99th_read" : r"\[READ\], 99thPercentileLatency\(us\), ([\d.]+)",
        "99th_read_modify_write" : r"\[READ-MODIFY-WRITE\], 99thPercentileLatency\(us\), ([\d.]+)",
        "99th_update" : r"\[UPDATE\], 99thPercentileLatency\(us\), ([\d.]+)",
        "99th_insert" : r"\[INSERT\], 99thPercentileLatency\(us\), ([\d.]+)",
        "99th_scan" : r"\[SCAN\], 99thPercentileLatency\(us\), ([\d.]+)"
    }
    for key, pattern in patterns.items():
        match = re.search(pattern, output)
        if match:
            metrics[key] = float(match.group(1))
        else:
            metrics[key] = None
    return metrics

results = []
data_per_workload = {workload : [] for workload in workloads}

for workload in workloads:
    for database in databases:
        print(f"Running workload {workload} on database {database}")
        metrics = get_data(run_ycsb(workload, database))
        metrics["workload"] = workload
        metrics["database"] = database
        # print(metrics)
        data_per_workload[workload].append(metrics)
print(data_per_workload)

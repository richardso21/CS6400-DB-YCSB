import argparse
import subprocess
import os

DB_BINDINGS = [
    "rocksdb",
    "unqlite",
    "terarkdb",
]

# SETUP_CMDS = {
#     "terarkdb": "cd terarkdb/terarkdb && WITH_TESTS=OFF WITH_ZNS=OFF ./build.sh"
# }

# GCC_VERSION_OVERRIDE = {
#     "terarkdb": 12,
#     "speedb": 13
# }

WORKLOADS = list("abcdef")


def run_command(cmd: str, quiet : bool = False, error_ok : bool = False):
    # highlight the running command in green
    print(f"\033[92m {cmd}\033[00m")
    retcode = subprocess.call(
        cmd,
        shell=True,
        stdout=subprocess.DEVNULL if quiet else None,
        stderr=subprocess.DEVNULL if quiet else None
    )
    # raise exception if return code is abnormal and unexpected
    if not error_ok and retcode != 0:
        raise RuntimeError(f"Command `{cmd}` failed with return code: {retcode}")

# def swap_compiler_version(version: int):
#     # swap the default compiler version to the specified version
#     run_command("update-alternatives --remove-all gcc", error_ok=True)
#     run_command("update-alternatives --remove-all g++", error_ok=True)
#     run_command(f"update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-{version} 1")
#     run_command(f"update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-{version} 1")

def run_ycsb_benchmark(db: str, workload: str, quiet : bool = False):
    # enter the `YCSB` directory
    os.chdir("YCSB-cpp")

    # # swap the compiler version if specified
    # if db in GCC_VERSION_OVERRIDE:
    #     swap_compiler_version(GCC_VERSION_OVERRIDE[db])

    # # prep for workload through a setup command (e.g. compiling terarkdb)
    # if db in SETUP_CMDS:
    #     run_command(SETUP_CMDS[db], quiet)

    # build ycsb executable with specified db binding
    run_command("mkdir -p build", quiet)
    os.chdir("build")
    run_command("make clean", quiet=quiet, error_ok=True)

    binds = [f"-DBIND_{db.upper()}=1"]
    for i in DB_BINDINGS:
        if i == db:
            continue
        binds.append(f"-DBIND_{i.upper()}=0")

    run_command(f"cmake {" ".join(binds)} .. && make -j", quiet=quiet)

    # some db's (e.g. rocksdb) require a defined properties file to be specified
    properties_file = f"-P ../{db}/{db}.properties" if db != "unqlite" else ""

    # load & run the the workload on db
    run_command(f"./ycsb -load -db {db} -P ../workloads/workload{workload} {properties_file} -s")
    run_command(f"./ycsb -run -db {db} -P ../workloads/workload{workload} {properties_file} -s")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("-db", "--db", type=str, required=True, choices=DB_BINDINGS)
    _ = parser.add_argument("-w", "--workload", type=str, required=True, choices=WORKLOADS)
    _ = parser.add_argument("-q", "--quiet", action="store_true")
    args = parser.parse_args()

    run_ycsb_benchmark(args.db, args.workload, args.quiet)

#!/usr/bin/env python3
from dsigparser import parse_ping, parse_cpu_tput
import os

figure_name="fig13-batch-size"

subbars = [
    ("sign", "sign"),
    ("net", "transmit"),
    ("verif", "verify"),
]

batch_sizes = [2**i for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]

print("Dsig latencies for different EdDSA batch sizes:")
for bs in batch_sizes:
    path = os.path.join("logs/",
            figure_name,
            'latency',
            f'batchsize-of-{bs}',
            "proc1.txt")
    data = parse_ping(path)
    print(f'    -batches of size {bs}:')
    for lat, latname in subbars:
        print(f'        - median to {latname}: {data[lat][50]}μs')

print("Dsig signing throughput for different EdDSA batch sizes:")
for bs in batch_sizes:
    path = os.path.join("logs/",
            figure_name,
            'cpu-tput',
            f'batchsize-of-{bs}',
            "proc1.txt")
    data = parse_cpu_tput(path)
    print(f'    -batches of {bs}: {data["sign"]}kSig/s')
    
print("Dsig verification throughput for different EdDSA batch sizes:")
for bs in batch_sizes:
    path = os.path.join("logs/",
            figure_name,
            'cpu-tput',
            f'batchsize-of-{bs}',
            "proc1.txt")
    data = parse_cpu_tput(path)
    print(f'    -batches of {bs}: {data["verify"]}kSig/s')

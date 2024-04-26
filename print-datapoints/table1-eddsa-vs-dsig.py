#!/usr/bin/env python3
from dsigparser import parse_ping, parse_cpu_tput
import os

figure_name="table1-eddsa-vs-dsig"

schemes = ['eddsa-dalek', 'dsig']

subbars = [
    ("sign", "sign"),
    ("net", "transmit"),
    ("verif", "verify"),
]

for scheme in schemes:
    path = os.path.join("logs/",
            figure_name,
            scheme + "-latency",
            "proc1.txt")
    data = parse_ping(path)
    print(f'-data for {scheme}:')
    for lat, latname in subbars:
        print(f'    - median latency to {latname}: {data[lat][50]}μs')

    path = os.path.join("logs/",
            figure_name,
            scheme + "-cpu-tpu",
            "proc1.txt")
    data = parse_cpu_tput(path)
    print(f'    -throughput to sign: {data["sign"]}kops')
    print(f'    -throughput to verify: {data["verify"]}kops')

    if scheme == 'dsig':
        sig_size = 1584 # Printed at the start of the logs (fixed)
        print(f'    -size of signatures: {sig_size}B')
    else:
        print(f'    -size of signatures: {64}B')
    if scheme == 'dsig':
        background_per_batch = 4160 # Printed at the start of the logs (fixed)
        batch_size = 128
        print(f'    -background traffic per signature: {background_per_batch/batch_size}B')
    else:
        print(f'    -background traffic per signature: {0}B')

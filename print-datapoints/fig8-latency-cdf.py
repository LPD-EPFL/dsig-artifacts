#!/usr/bin/env python3
from dsigparser import parse_ping
import os

figure_name="fig8-latency-cdf"

schemes = [
    'eddsa-dalek',
    'eddsa-sodium',
    'dsig',
    'dsig-badhint',
]

subbars = [
    ("rsign", "sign"),
    ("net", "transmit"),
    ("rverif", "verify"),
]

path = os.path.join("../logs/", figure_name, "eddsa-dalek", "proc1.txt")
data = parse_ping(path)
netoffset = data['net'][50]

percentiles = [0.1] + list(range(1,100)) + [99.9]

for h in hashes:
    for scheme in schemes:
        path = os.path.join("../logs/",
                figure_name,
                scheme,
                "proc1.txt")
        data = parse_ping(path, network_offset=netoffset)
        print(f'{scheme}:')
        cumul = 0
        for lat, latname in subbars:
            print(f'\t- median to {latname}: {data[lat][50]}μs')
            cumul += data[lat][50]
        print(f'\t- percentiles for total:')
        for i in percentiles:
            print(f'\t\t- {i}%: {data['one-way'][i]}μs')
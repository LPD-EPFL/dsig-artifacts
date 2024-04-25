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

netoffset = parse_ping('logs/pony-ping-dalek-msg8-1.txt')['net'][50] - 0.06

percentiles = [0.1] + list(range(1,100)) + [99.9]

for h in hashes:
    for scheme in schemes:
        for k in [12,16,32,64] if 'hors' in scheme else [2,4,8,16]:
            config = f'{k}-secrets' if 'hors' in scheme else f'{k}-depth'
            path = os.path.join("../logs/",
                    figure_name,
                    f'{h}-hash',
                    scheme,
                    config,
                    "proc1.txt")
            data = parse_ping(path)
            print(f'{scheme} with {h} and {config}:')
            cumul = 0
            for lat, latname in subbars:
                print(f'\t- median to {latname}: {data[lat][50]}μs')
                cumul += data[lat][50]
            print(f'\t- total percentiles:')
            for i in percentiles:
                print(f'\t\t- {i}%: {data['one-way'][i]}μs')

                
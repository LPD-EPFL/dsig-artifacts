#!/usr/bin/env python3
from dsigparser import parse_ping
import os

figure_name="fig6-choice-of-hbss"

hashes = [
    "sha256",
    "haraka",
]

schemes = [
    'hors-factorized',
    'hors-merkle',
    'hors-merkle+prefetching',
    'wots',
]

subbars = [
    ("rsign", "sign"),
    ("net", "transmit"),
    ("rverif", "verify"),
]

for h in hashes:
    for scheme in schemes:
        for k in [12,16,32,64] if 'hors' in scheme else [2,4,8,16]:
            config = f'{k}-secrets' if 'hors' in scheme else f'{k}-depth'
            path = os.path.join("logs/",
                    figure_name,
                    f'{h}-hash',
                    scheme,
                    config,
                    "proc1.txt")
            data = parse_ping(path)
            print(f'median latencies of {scheme} with {h} and {config}:')
            cumul = 0
            for lat, latname in subbars:
                print(f'    - {latname}: {data[lat][50]}μs')
                cumul += data[lat][50]
            print(f'    - total: {cumul}μs')

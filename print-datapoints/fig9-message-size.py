#!/usr/bin/env python3
from dsigparser import parse_ping
import os

figure_name="fig9-message-size"

schemes = [
    'eddsa-sodium',
    'eddsa-dalek',
    'dsig',
]

subbars = [
    ("sign", "sign"),
    ("net", "transmit"),
    ("verif", "verify"),
]

path = os.path.join("logs/", figure_name,
        "msgs-of-8B", "eddsa-dalek", "proc1.txt")
data = parse_ping(path)
netoffset = data['net'][50]

for scheme in schemes:
    for sz in [8,16,32,64,128,256,512,1024,2048,4096,8192]:
        path = os.path.join("logs/",
                figure_name,
                f'msgs-of-{sz}B',
                scheme,
                "proc1.txt")
        data = parse_ping(path, network_offset=netoffset)
        print(f'{scheme} with messages of {sz} B, median total: {data["one-way"][50]}')

    path = os.path.join("logs/",
            figure_name,
            "msgs-of-8192B",
            scheme,
            "proc1.txt")
    data = parse_ping(path, network_offset=netoffset)
    print(f'{scheme} with messages of 8192 B:')
    cumul = 0
    for lat, latname in subbars:
        print(f'    - median to {latname}: {data[lat][50]}μs')
        cumul += data[lat][50]
    print(f'    - median for total: {data["one-way"][50]}μs')

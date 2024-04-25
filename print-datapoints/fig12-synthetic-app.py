#!/usr/bin/env python3
from dsigparser import parse_tput
import os

figure_name="fig12-synthetic-app"

schemes = [
    'no-crypto',
    'eddsa-dalek',
    'dsig',
]

processing_times = [
    1000,15000
]

msg_sizes = [
    32,128,512,2048,8192,32768,131072
]

for proc_time in processing_times:
    print(f'For a processing time of {proc_time/1000}μs:')
    for scheme in schemes:
        for msg_size in msg_sizes:
            path = os.path.join("logs/",
                    figure_name,
                    f'{proc_time}ns-processing-time',
                    f'msgs-of-{msg_size}B',
                    scheme,
                    "proc1.txt")
            data = parse_tput(path)
            tput = data['tput']
            print(f'\t- {scheme} with messages of {msg_size} B: {tput}ksig/s')
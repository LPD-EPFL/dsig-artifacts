#!/usr/bin/env python3
from dsigparser import parse_tput
import os
from glob import glob

figure_name="fig11-scalability"

schemes = [
    'eddsa-dalek',
    'dsig',
]

for scaling in ['verifiers', 'signers']:
    print(f'Scaling {scaling}:')
    for scheme in schemes:
        for scale in range(1,12+1):
            path = os.path.join("logs/",
                    figure_name,
                    f'scaling-{scaling}',
                    f'{scale}-{scaling}',
                    scheme,
                    'run*'
                    "proc1.txt")
            paths = glob(paths)
            best_tput = 0
            for path in paths:
                data = parse_tput(path)
                tput = data['tput']
                if(tput > best_tput):
                    best_tput = tput
            out = best_tput / 1000 * verifiers
            if scheme == 'dsig':
                out /= 2 # dsig has two threads per process
            print(f'    - {scheme} with {scale} {scaling}: {out}kSig/s')

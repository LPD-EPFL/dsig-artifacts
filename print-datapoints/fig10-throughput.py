#!/usr/bin/env python3
from dsigparser import parse_ping
import os
from glob import glob

figure_name="fig10-throughput"

schemes = [
    'eddsa-dalek',
    'eddsa-sodium',
    'dsig',
]

ingress_types = [
    "constant-intervals",
    "random-intervals",
]

for ing_type in ingress_types:
    for scheme in schemes:
        path = os.path.join("logs/",
                figure_name,
                scheme,
                ing_type,
                "*-interval-of-*ns',
                "proc1.txt")
        paths = glob(path)
        paths = sorted(paths, key=lambda p: (len(p), p), reverse=True)
        raw = []
        for path in paths:
            data = parse_tput(path)
            lat = data['one-way'][50]
            tput = data['tput']
            raw.append((tput / 1000, lat))
        xsys = []
        best_latency = 2**128
        for tput, lat in sorted(raw, key=lambda xy: xy[0], reverse=True):
            if(lat > best_latency * 1.1):
                continue
            if(lat < best_latency):
                best_latency = lat
            xsys.append((tput, lat))
        xsys.append((0, best_latency))
        xsys = sorted(xsys, key=lambda xy: xy[0])
        print(f'tput-latency datapoints for {scheme} with {ing_type}:')
        for tput, lat in xsys:
            print(f'\t- {tput}ksig/s, {lat}μs')
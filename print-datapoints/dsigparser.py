#!/usr/bin/env python3

import os, sys, re
from collections import defaultdict

measurements = {
    'One-way': 'one-way',
    'Sign': 'sign',
    'Verify': 'verif',
    'Remote Sign': 'rsign',
    'Remote Verify': 'rverif',
    'RTT': 'rtt',
    'Buffer': None
}

tiles = ['1', '10', '25', '50', '75', '90', '99']

def parse_ping(path, mode='FAST', network_offset=0, filter_tiles=True):
    skip = False
    out = {}
    pathtype = ""
    with open(path) as f:
        measurement = ""
        for l in f:
            if "/Path=" in l:
                data = re.findall("/Path=([A-Za-z]+)/", l)
                assert(len(data) == 1)
                skip = data[0] != mode
                # if not skip: print(data[0])
            elif skip:
                continue
            elif l[:-1] in measurements:
                measurement = measurements[l[:-1]]
                assert(measurement not in out)
                out[measurement] = {}
            elif 'th-tile: ' in l:
                data = re.findall("([0-9\.]+)th-tile: (\d+)ns", l)
                assert(len(data) == 1)
                tile = data[0][0]
                value = data[0][1]
                if filter_tiles and tile not in tiles:
                    continue
                assert float(tile) not in out[measurement]
                out[measurement][float(tile)]=int(value) / 1000
    if 'rtt' in out:
        out['net'] = {}
    if 'rsign' in out:
        out['avgsign'] = {}
    if 'rverif' in out:
        out['avgverif'] = {}
    for measurement, mdata in out.items():
        for tile, value in mdata.items():
            if measurement == 'one-way':
                out['one-way'][tile] -= network_offset
            if measurement == 'rtt':
                value -= 2*network_offset
                out['rtt'][tile] = value
                out['net'][tile] = (value / 2)
            if measurement == 'rsign':
                out['avgsign'][tile] = (out['sign'][tile] + value) / 2
            if measurement == 'rverif':
                out['avgverif'][tile] = (out['verif'][tile] + value) / 2
    # print(out)
    return out

def parse_tput(path, filter_tiles=True):
    out = defaultdict(lambda: defaultdict(lambda: 2**128))
    out['tput'] = 0
    with open(path) as f:
        measurement = ""
        for l in f:
            if 'throughput:' in l:
                assert(out['tput'] == 0)
                out['tput'] = int(re.findall("throughput: (\d+) sig/s", l)[0])
            elif l[:-1] in measurements:
                measurement = measurements[l[:-1]]
                assert(measurement not in out)
                out[measurement] = {}
            elif 'th-tile: ' in l:
                data = re.findall("([0-9\.]+)th-tile: (\d+)ns", l)
                assert(len(data) == 1)
                tile = data[0][0]
                value = data[0][1]
                if filter_tiles and tile not in tiles:
                    continue
                if int(tile) in out[measurement]:
                    continue
                out[measurement][int(tile)]=int(value) / 1000
    return out

def parse_cpu_tput(path):
    out = {'sign': 0, 'verif': 0}
    with open(path) as f:
        measurement = ""
        for l in f:
            if '[DSIG][TOTAL][SIGN]' in l or '[EDDSA][SIGN]' in l:
                out['sign'] = int(re.findall("tput\: (\d+) sig\/s", l)[0]) / 1000
            if '[DSIG][TOTAL][VERIF]' in l or '[EDDSA][VERIF]' in l:
                out['verif'] = int(re.findall("tput\: (\d+) sig\/s", l)[0]) / 1000
    return out

def parse_app(path):
    # print(path)
    out = {}
    with open(path) as f:
        for l in f:
            if 'th-tile: ' in l:
                data = re.findall("([0-9\.]+)th-tile: (\d+)ns", l)
                assert(len(data) == 1)
                data = data[0]
                if data[0] not in tiles:
                    continue
                assert(int(data[0]) not in out)
                out[int(data[0])]=int(data[1]) / 1000
    assert(len(out) >= 3)
    # print(out)
    return out

# def main():
#     if len(sys.argv) < 2:
#         raise "Wrong number of arguments : require at least 1 argument."
#     paths = sys.argv[1:]
#     for exp in paths:
#         print(os.path.basename(exp), end="\t")
#         try:
#             if 'tput' in exp:
#                 print(parse_tput(exp))
#             if 'redis' in exp or :
#                 print(parse_ping(exp))
#             else:
#                 print(parse_app(exp))
#         except:
#             print("failed", exp)
#     # print(latencies(sys.argv[1]))
# if __name__ == "__main__":
#     main()

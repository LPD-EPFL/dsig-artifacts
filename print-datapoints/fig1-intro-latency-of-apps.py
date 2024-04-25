#!/usr/bin/env python3
from dsigparser import parse_app
import os

figure_name="fig1-intro-latency-of-apps"

apps = [
    'auditable-kvs',
    'bft-broadcast',
    'bft-replication',
]

subbars = [
    "no-crypto",
    "eddsa-dalek",
    "dsig",
]

for app in apps:
    for subbar in subbars:
        path = os.path.join("logs/", figure_name, app, subbar,
                "client.txt" if 'audit' in app else "proc1.txt")
        data = parse_app(path)
        print(f'median latency of {app} with {subbar}: {data[50]}μs')
#!/usr/bin/env python3
from dsigparser import parse_app
import os

figure_name="fig7-latency-of-apps"

apps = [
    'herd-audit',
    'redis-audit',
    'liquibook-audit',
    'ctb',
    'ubft',
]

subbars = [
    "no-crypto",
    "eddsa-sodium",
    "eddsa-dalek",
    "dsig",
]

for app in apps:
    for subbar in subbars:
        path = os.path.join("logs/", figure_name, app, subbar,
                "client.txt" if 'audit' in app else "proc1.txt")
        data = parse_app(path)
        print(f'latencies of {app} with {subbar}:')
        print(f'\t-10%ile {data[10]}μs')
        print(f'\t-median {data[50]}μs')
        print(f'\t-90%ile {data[90]}μs')
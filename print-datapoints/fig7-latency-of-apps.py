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
    "eddsa-dalek",
    "eddsa-sodium",
    "dsig",
]

for app in apps:
    for subbar in subbars:
        path = os.path.join("logs/", figure_name, app, subbar,
                "client.txt" if 'audit' in app else "proc1.txt")
        data = parse_app(path)
        print(f'median latency of {app} with {subbar}: {data[50]}μs')
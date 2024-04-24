#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

for INGRESS_DELTA in {100000,50000,20000,15000,12000,10000,9000,8000} {7200..6000..200}; do
# for INGRESS_DELTA in {6950..6000..50}; do
    "$SCRIPT_DIR"/test-tput-dsig-wots.sh base32 haraka 7 2 constant $INGRESS_DELTA
    "$SCRIPT_DIR"/test-tput-dsig-wots.sh base32 haraka 7 2 exponential $INGRESS_DELTA
done
for INGRESS_DELTA in {100000,70000,50000,40000} {39000..35000..1000}; do
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 dalek constant $INGRESS_DELTA
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 dalek exponential $INGRESS_DELTA
done
for INGRESS_DELTA in {100000,70000,65000} {63000..57000..1000}; do
# for INGRESS_DELTA in {60000..57500..500}; do
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 sodium constant $INGRESS_DELTA
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 sodium exponential $INGRESS_DELTA
done

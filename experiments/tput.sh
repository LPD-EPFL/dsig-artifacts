#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

for INGRESS_DELTA in {100000..50000..10000} {40000..20000..5000} {19000..12000..1000} {12000..10000..500} {9750..8000..250} {7900..7000..100} {6950..6000..50}; do
# for INGRESS_DELTA in {6950..6000..50}; do
    "$SCRIPT_DIR"/test-tput-dsig-wots.sh base32 haraka 7 2 constant $INGRESS_DELTA -s 32
    "$SCRIPT_DIR"/test-tput-dsig-wots.sh base32 haraka 7 2 exponential $INGRESS_DELTA -s 32
done
for INGRESS_DELTA in {100000..70000..10000} {68000..50000..2000} {49000..40000..1000} {39000..35000..500}; do
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 dalek constant $INGRESS_DELTA -s 32
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 dalek exponential $INGRESS_DELTA -s 32
done
for INGRESS_DELTA in {100000..70000..10000} {68000..63000..1000} {62000..57500..500}; do
# for INGRESS_DELTA in {60000..57500..500}; do
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 sodium constant $INGRESS_DELTA -s 32
    "$SCRIPT_DIR"/test-tput-eddsa.sh base32 sodium exponential $INGRESS_DELTA -s 32
done

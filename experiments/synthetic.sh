#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# for PROC_TIME in {1000,10000,15000,20000}; do
for PROC_TIME in {1000,15000}; do
# for PROC_TIME in 15000; do
    for MSG_SIZE in {32,128,512,2048,8192,32768,131072}; do
        "$SCRIPT_DIR"/test-synthetic.sh base pony 3 $PROC_TIME $MSG_SIZE auto 0
        "$SCRIPT_DIR"/test-synthetic.sh base dalek 4 $PROC_TIME $MSG_SIZE auto 0
        "$SCRIPT_DIR"/test-synthetic.sh base none 4 $PROC_TIME $MSG_SIZE auto 0
    done
done
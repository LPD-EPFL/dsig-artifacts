#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

BATCH_SIZE=7

for HASH in {haraka,sha256}; do
    # for SECRETS in {64,32,24,19,16}; do
    #     "$SCRIPT_DIR"/test-pony-hors.sh base merkle $HASH $BATCH_SIZE $SECRETS
    #     "$SCRIPT_DIR"/test-pony-hors.sh prefetch merkle $HASH $BATCH_SIZE $SECRETS -c
    # done
    # "$SCRIPT_DIR"/test-pony-hors.sh base merkle $HASH $BATCH_SIZE 14 -r 16
    # "$SCRIPT_DIR"/test-pony-hors.sh prefetch merkle $HASH $BATCH_SIZE 14 -c -r 16
    "$SCRIPT_DIR"/test-pony-hors.sh base merkle $HASH $BATCH_SIZE 12 -r 4
    "$SCRIPT_DIR"/test-pony-hors.sh prefetch merkle $HASH $BATCH_SIZE 12 -c -r 4

    # for SECRETS in {64,32,24,16}; do
    #     "$SCRIPT_DIR"/test-pony-hors.sh base completed $HASH $BATCH_SIZE $SECRETS
    #     # "$SCRIPT_DIR"/test-pony-hors.sh prefetch completed $HASH $BATCH_SIZE $SECRETS -c
    # done

    "$SCRIPT_DIR"/test-pony-hors.sh base completed $HASH $BATCH_SIZE 12 -r 4
    # "$SCRIPT_DIR"/test-pony-hors.sh prefetch completed $HASH $BATCH_SIZE 12 -c -r 4
done

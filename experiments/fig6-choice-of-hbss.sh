#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth did fully complete.
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig6-choice-of-hbss"

LOG_BATCH_SIZE=7
# Blake3 is not shown/enabled as it is in-between haraka and sha256 in terms of performances.
# Change the for-loop bellow as follows to enable blake3:
# for HASH in {haraka,sha256,blake3}; do
for HASH in {haraka,sha256}; do
    for SECRETS in {64,32,24,19,16}; do
        "${SCRIPT_DIR}"/test-dsig-hors.sh $FIGURE_NAME/$HASH-hash/hors-merkle/$SECRETS-secrets merkle $HASH $LOG_BATCH_SIZE $SECRETS -r 4
        "${SCRIPT_DIR}"/test-dsig-hors.sh $FIGURE_NAME/$HASH-hash/hors-merkle+prefetching/$SECRETS-secrets merkle $HASH $LOG_BATCH_SIZE $SECRETS -c -r 4
        "${SCRIPT_DIR}"/test-dsig-hors.sh $FIGURE_NAME/$HASH-hash/hors-factorized/$SECRETS-secrets completed $HASH $LOG_BATCH_SIZE $SECRETS -r 4
        # "${SCRIPT_DIR}"/test-dsig-hors.sh $FIGURE_NAME/$HASH-hash/hors-factorized+prefetching/$SECRETS-secrets completed $HASH $LOG_BATCH_SIZE $SECRETS -c -r 4
    done
    for LOG_DEPTH in {1,2,3,4}; do
        DEPTH=$(( 2 ** $LOG_DEPTH ))
        "${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/$HASH-hash/wots/$DEPTH-depth $HASH $LOG_BATCH_SIZE $LOG_DEPTH -r 128
    done
done

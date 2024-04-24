#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

for RUN in {1..3}; do
    SUFFIX=netload32-run$RUN

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-verifiers.sh $SUFFIX pony $NB_CLIENTS auto 0 --msg_size 32
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-signers.sh $SUFFIX pony $NB_CLIENTS auto 0 --msg_size 32
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-verifiers.sh $SUFFIX dalek $NB_CLIENTS auto 0 --msg_size 32
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-signers.sh $SUFFIX dalek $NB_CLIENTS auto 0 -t 60 --msg_size 32
    done

done

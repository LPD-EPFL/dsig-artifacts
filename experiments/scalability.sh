#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

for RUN in {1..3}; do
    SUFFIX=netload32-run$RUN

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-verifiers.sh $SUFFIX dsig $NB_CLIENTS auto 0
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-signers.sh $SUFFIX dsig $NB_CLIENTS auto 0
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-verifiers.sh $SUFFIX dalek $NB_CLIENTS auto 0
    done

    for NB_CLIENTS in {12..1}; do
        "$SCRIPT_DIR"/test-scalability-signers.sh $SUFFIX dalek $NB_CLIENTS auto 0 -t 60
    done

done

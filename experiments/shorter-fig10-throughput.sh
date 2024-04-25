#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth did fully complete.
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig10-throughput"

for INGRESS_TYPE in {constant,exponential}; do
    if [[ $INGRESS_TYPE = "constant" ]]; then
        INGRESS_PREFIX="constant-intervals/ingress-interval-of"
    else
        INGRESS_PREFIX="random-intervals/mean-ingress-interval-of"
    fi
    for INGRESS_DELTA in {100000,60000,40000,30000,20000} {18000..12000..2000} {12000..8000..1000} {7800..5000..200}; do
        "${SCRIPT_DIR}"/test-tput-dsig-wots.sh $FIGURE_NAME/dsig/${INGRESS_PREFIX}-${INGRESS_DELTA}ns haraka 7 2 $INGRESS_TYPE $INGRESS_DELTA
    done
    for INGRESS_DELTA in {100000,60000,50000} {44000..32000..2000}; do
        "${SCRIPT_DIR}"/test-tput-eddsa.sh $FIGURE_NAME/eddsa-dalek/${INGRESS_PREFIX}-${INGRESS_DELTA}ns dalek $INGRESS_TYPE $INGRESS_DELTA
    done
    for INGRESS_DELTA in {100000,70000} {64000..54000..2000}; do
        "${SCRIPT_DIR}"/test-tput-eddsa.sh $FIGURE_NAME/eddsa-sodium/${INGRESS_PREFIX}-${INGRESS_DELTA}ns sodium $INGRESS_TYPE $INGRESS_DELTA
    done
done
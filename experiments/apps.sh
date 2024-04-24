#!/bin/bash

set -u

EXP_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

SUFFIX=base

"$EXP_DIR"/audit-apps.sh $SUFFIX
"$EXP_DIR"/tcb.sh $SUFFIX
"$EXP_DIR"/ubft.sh $SUFFIX

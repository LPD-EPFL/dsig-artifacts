#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

SUFFIX=$1

for SCHEME in {"none","dalek","sodium","dsig"}; do
    "$SCRIPT_DIR"/test-audit-app.sh $SUFFIX herd "16,32,80,90,10240" $SCHEME
    "$SCRIPT_DIR"/test-audit-app.sh $SUFFIX redis "16,32,80,90,10240" $SCHEME
    "$SCRIPT_DIR"/test-audit-app.sh $SUFFIX liquibook "50,10240" $SCHEME
done

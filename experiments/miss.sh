#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

"$SCRIPT_DIR"/test-dsig-wots.sh miss32 haraka 7 2 -r 128 -S -s 32

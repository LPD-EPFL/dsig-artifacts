#!/bin/bash
set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$SCRIPT_DIR"

rm -rf bin.zip
zip -Dj0 bin.zip dsig/dsig*/build/bin/*
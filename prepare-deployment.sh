#!/bin/bash
set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$SCRIPT_DIR"

rm -rf deployment.zip
zip -r deployment.zip toml/
zip -r deployment.zip scripts/
zip -r deployment.zip experiments/
zip -r deployment.zip bin/bin.zip
zip -r deployment.zip logs/placeholder.txt
#!/bin/bash
set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$SCRIPT_DIR"

for i in {1..4}; do
  echo "Sending deployment to w$i"
  scp deployment.zip w$i:~
  ssh w$i "unzip -o deployment.zip -d dsig-artifacts; cd dsig-artifacts/bin; unzip -o bin.zip"
done
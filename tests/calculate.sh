#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1

find . -regex '.*\.txt$' -exec sh -c "cat {} | tail -n +5 | md5sum" \;


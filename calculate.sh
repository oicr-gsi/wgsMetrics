#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1
qrsh -V -l h_vmem=8G -cwd -now n "\
find . -regex '.*\.txt$' \
       -exec sh -c \" wc -l {} | sed 's/ .*//' \" \; "

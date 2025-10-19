#!/bin/bash

DIR="$(dirname $0)"
FNAME="$(basename $1)"

if [ -f "$1" ]; then
    awk 'BEGIN {
    in_codeblock = 0
}
/^```/ {
    in_codeblock = !in_codeblock
}
/^#/ && (in_codeblock == 0){
    sub(/## /, "", $0)
    gsub(/#/, "\t", $0)
    print
}' $1 | "$DIR"/indent_tree.sh -c '\t' -t "$FNAME"
fi

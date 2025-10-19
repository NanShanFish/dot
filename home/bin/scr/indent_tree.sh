#!/bin/bash

if ! command -v tree &> /dev/null; then
    echo "tree not exits in your PATH"
    exit 1
fi

indent_char=" "

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--title)
            if [[ -n "$2" ]]; then
                title="$2"
            fi
            shift 2
        ;;
        -c)
            if [[ ${#2} -eq 1 ]]; then
                indent_char="$2"
            else
                echo "invaild character"
                exit 1
            fi
            shift 2
        ;;
    esac
done

if [[ -n "$title" ]]; then
    echo $title
else
    echo "."
fi

awk "BEGIN {
    ORS = \"\"
}
{
    match(\$0, /^${indent_char}*/)
    level = RLENGTH
    header[RLENGTH] = substr(\$0, RLENGTH + 1)
    for (i = 0 ; i <= level ; i++) {
        print header[i] \"/\"
    }
    print \"\\n\"
}" | tree --fromfile | sed '1d; /^$/d; $d;'


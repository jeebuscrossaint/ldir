#!/bin/bash

show_hidden=0
while getopts "h" opt; do
    case ${opt} in
        h)
            show_hidden=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

ldir() {
    local dir="${1:-.}"
    local prefix="$2"
    local item

    shopt -s dotglob
    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            local item_name=$(basename "$item")
            if [[ $show_hidden -eq 0 && $item_name = .* ]]; then
                continue
            fi
            echo "${prefix}├── ${item_name}/"
            ldir "$item" "${prefix}│   "
        elif [ -f "$item" ]; then
            local item_name=$(basename "$item")
            if [[ $show_hidden -eq 0 && $item_name = .* ]]; then
                continue
            fi
            echo "${prefix}├── ${item_name}"
        fi
    done
    shopt -u dotglob
}

ldir "$1" ""
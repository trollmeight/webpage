#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: aero <file>"
    exit 1
fi

filename="$1"

touch "$filename" || {
    echo "aero: Unable to open $filename (check permissions?)"
    exit 1
}

temp_file="$(mktemp)" || exit 1
cp "$filename" "$temp_file" 2>/dev/null

cols=$(tput cols 2>/dev/null || echo 80)

header() {
    printf "\033[H\033[J"
    printf "\033[44;97m %s" "$filename"
    padding=$((cols - ${#filename} - 2))
    [ "$padding" -lt 0 ] && padding=0
    printf "%*s" "$padding" ""
    printf "\033[0m\n"
    printf '%*s\n' "$cols" '' | tr ' ' '-'
}

header

if [ -s "$filename" ]; then
    cat "$filename"
fi

while IFS= read -r line; do
    if [ "$line" = ":q" ]; then
        mv "$temp_file" "$filename"
        clear
        echo "aero: Saved to $filename"
        exit 0
    fi
    echo "$line" >> "$temp_file"
done

mv "$temp_file" "$filename"
clear
echo "aero: Saved to $filename"

#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: aero <file>"
    exit 1
fi

filename="$1"

echo "$filename"
printf '%*s\n' "${COLUMNS:-1000}" '' | tr ' ' -

touch "$filename" || {
    echo "aero: Unable to open $filename (check permissions?)"
    exit 1
}

if [ -s "$filename" ]; then
    cat "$filename"
fi

temp_file="$(mktemp)" || exit 1
cp "$filename" "$temp_file" 2>/dev/null

while IFS= read -r line; do
    if [ "$line" = ":q" ]; then
        mv "$temp_file" "$filename"
        clear
        echo "aero: Saved to $filename"
        exit 0
    fi
    echo "$line" >> "$temp_file"
done

clear
mv "$temp_file" "$filename"
echo "aero: Saved to $filename"

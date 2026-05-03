#!/bin/bash

version="1"
latesturl="https://raw.githubusercontent.com/trollmeight/webpage/refs/heads/main/aero/version.txt"

latestversion=$(curl -fsSL "$version")

if [ -z "$latest" ]; then
    echo "Unable to check for updates, proceeding as usual..."

    if [ -z "$1" ]; then
        echo "Usage: aero <file>"
        exit 1
    fi

    filename="$1"

    echo "\034[31m$filename\034[0m"
    printf '%*s\n' "${COLUMNS:-80}" '' | tr ' ' -

    touch "$filename" || {
        echo "aero: Unable to open $filename (check permissions?)"
        exit 1
    }

    if [ -s "$filename" ]; then
        cat $filename
    end

    temp="$(mktemp)" || exit 1
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
fi

if [ "$(printf '%s\n' "$version" "$latestversion" | sort -V | tail -n1)" = "$latestversion" ] \
   && [ "$version" != "$latestversion" ]; then
    echo "$version -> $latestversion"
    ./usr/local/bin/$USER/aero_external/update.sh
else
    if [ -z "$1" ]; then
        echo "Usage: aero <file>"
        exit 1
    fi

    filename="$1"

    echo "\034[31m$filename\034[0m"
    printf '%*s\n' "${COLUMNS:-80}" '' | tr ' ' -

    touch "$filename" || {
        echo "aero: Unable to open $filename (check permissions?)"
        exit 1
    }

    if [ -s "$filename" ]; then
        cat $filename
    end

    temp="$(mktemp)" || exit 1
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
fi


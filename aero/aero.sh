#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: aero <file>"
    exit 1
fi

filename="$1"

touch "$filename" || {
    echo "aero: Unable to open $filename"
    exit 1
}

mapfile -t lines < "$filename"
current_line=${#lines[@]}
cols=$(tput cols 2>/dev/null || echo 80)

header() {
    printf '\033[H\033[J'
    printf '\033[34m%s\033[0m' "$filename"
    padding=$((cols - ${#filename}))
    [ "$padding" -lt 0 ] && padding=0
    printf '%*s\n' "$padding" ''
    printf '%*s\n' "$cols" '' | tr ' ' '-'

    for line in "${lines[@]}"; do
        printf '%s\n' "$line"
    done

    printf '\033[%d;1H' $((current_line + 3))
}

save() {
    printf '%s\n' "${lines[@]}" > "$filename"
}

header

while true; do
    IFS= read -rsn1 key

    case "$key" in
        $'\x1b')
            read -rsn2 rest
            case "$rest" in
                '[A')
                    [ "$current_line" -gt 0 ] && ((current_line--))
                    ;;
                '[B')
                    [ "$current_line" -lt ${#lines[@]} ] && ((current_line++))
                    ;;
            esac
            ;;
        '')
            lines=("${lines[@]:0:current_line}" "" "${lines[@]:current_line}")
            ((current_line++))
            ;;
        ':')
            read -rsn1 next
            if [ "$next" = "q" ]; then
                save
                clear
                echo "aero: Saved to $filename"
                exit 0
            else
                lines[current_line]+=":$next"
            fi
            ;;
        $'\x7f')
            if [ -n "${lines[current_line]}" ]; then
                lines[current_line]="${lines[current_line]%?}"
            fi
            ;;
        *)
            lines[current_line]="${lines[current_line]}$key"
            ;;
    esac

    header
    printf '%s' "${lines[current_line]}"
done

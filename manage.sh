#!/bin/bash

set -euo pipefail

directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
config="$directory/enabled.conf"
bundled="$directory/rc.d"
custom="$directory/rc.d-custom"

usage() {
    printf '%s\n' \
        'Usage: ./manage.sh activate NAME' \
        '       ./manage.sh deactivate NAME' \
        '       ./manage.sh ls [all|active|available]'
}

valid_name() {
    case "$1" in
        ''|*[!a-zA-Z0-9_-]*) return 1 ;;
        *) return 0 ;;
    esac
}

list_inventory() {
    local file name

    for file in "$bundled"/*.rc "$custom"/*.rc; do
        [[ -f "$file" ]] || continue
        name=${file##*/}
        name=${name%.rc}
        valid_name "$name" || continue

        if [[ -f "$bundled/$name.rc" && -f "$custom/$name.rc" ]]; then
            printf '%s (custom loaded last)\n' "$name"
        else
            printf '%s\n' "$name"
        fi
    done | LC_ALL=C sort -u
}

list_inventory_view() {
    local view=$1 input=/dev/null
    if [[ -f "$config" ]]; then
        input=$config
    fi

    list_inventory | LC_ALL=C awk -v view="$view" '
        FILENAME != "-" {
            if ($0 != "" && $0 !~ /^#/) {
                selected[$0] = 1
                selection[++count] = $0
            }
            next
        }

        {
            name = $1

            if (view == "available") {
                if (!(name in selected)) print $0
                next
            }

            available[name] = 1
            printf "%s [%s]\n", $0, (name in selected ? "active" : "inactive")
        }

        END {
            if (view == "all") {
                for (i = 1; i <= count; i++) {
                    name = selection[i]
                    if (name !~ /^[a-zA-Z0-9_-]+$/) {
                        printf "%s (invalid name)\n", name
                    } else if (!(name in available)) {
                        printf "%s (missing)\n", name
                    }
                }
            }
        }
    ' "$input" -
}

list_active() {
    [[ -f "$config" ]] || exit 0

    while IFS= read -r name || [[ -n "$name" ]]; do
        case "$name" in ''|\#*) continue ;; esac

        if ! valid_name "$name"; then
            printf '%s (invalid name)\n' "$name"
        elif [[ -f "$bundled/$name.rc" || -f "$custom/$name.rc" ]]; then
            printf '%s\n' "$name"
        else
            printf '%s (missing)\n' "$name"
        fi
    done < "$config"
}

case "${1:-}" in
    activate|deactivate)
        if [[ $# -ne 2 ]] || ! valid_name "$2"; then
            usage >&2
            exit 2
        fi

        name=$2
        if [[ $1 == activate && ! -f "$bundled/$name.rc" && ! -f "$custom/$name.rc" ]]; then
            printf 'Unknown snippet: %s\n' "$name" >&2
            exit 1
        fi

        input=/dev/null

        if [[ -e "$config" || -L "$config" ]]; then
            if [[ ! -f "$config" || -L "$config" || ! -r "$config" ]]; then
                printf 'Cannot edit configuration: %s\n' "$config" >&2
                exit 1
            fi
            input=$config
        fi

        temp=$(mktemp "$directory/.enabled.conf.XXXXXXXX")
        trap 'rm -f -- "$temp"' EXIT

        # Preserve comments and the order of the remaining entries.
        if ! awk -v action="$1" -v name="$name" '
            $0 == name {
                found = 1
                if (action == "deactivate") next
            }
            { print }
            END {
                if (action == "activate" && !found) print name
            }
        ' "$input" > "$temp"; then
            exit 1
        fi

        if cmp -s "$input" "$temp"; then
            printf 'Selection unchanged: %s\n' "$name"
        else
            compare_status=$?
            if [[ $compare_status -ne 1 ]]; then
                printf 'Cannot compare configuration: %s\n' "$config" >&2
                exit "$compare_status"
            fi

            mv -- "$temp" "$config"
            printf 'Selection updated for new Bash sessions: %s\n' "$name"
        fi
        ;;

    ls)
        if [[ $# -gt 2 ]]; then
            usage >&2
            exit 2
        fi

        case "${2-all}" in
            all|available) list_inventory_view "${2-all}" ;;
            active)        list_active ;;
            *)
                usage >&2
                exit 2
                ;;
        esac
        ;;

    *)
        usage >&2
        exit 2
        ;;
esac

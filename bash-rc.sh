# Source this file from Bash.

BASH_RC_LS_COLOR_OPTIONS=()

case "$OSTYPE" in
    darwin*)
        BASH_RC_LS_COLOR_OPTIONS=(-G)
        ;;
    linux*)
        BASH_RC_LS_COLOR_OPTIONS=(--color=always)
        ;;
esac

_bash_rc_load() {
    local directory snippet file found
    local -a snippets=()
    directory=$(cd -- "${BASH_SOURCE[0]%/*}" && pwd -P) || return 1

    if [[ -f "$directory/enabled.conf" ]]; then
        while IFS= read -r snippet || [[ -n "$snippet" ]]; do
            case "$snippet" in
                ''|\#*) continue ;;
                *[!a-zA-Z0-9_-]*)
                    printf 'Invalid Bash snippet name: %s\n' "$snippet" >&2
                    continue
                    ;;
            esac
            snippets+=("$snippet")
        done < "$directory/enabled.conf"

        for snippet in "${snippets[@]}"; do
            found=
            for file in "$directory/rc.d/$snippet.rc" "$directory/rc.d-custom/$snippet.rc"; do
                if [[ -f "$file" ]]; then
                    found=1
                    source "$file"
                fi
            done
            if [[ -z "$found" ]]; then
                printf 'Unknown Bash snippet: %s\n' "$snippet" >&2
            fi
        done
    fi
    return 0
}
_bash_rc_load

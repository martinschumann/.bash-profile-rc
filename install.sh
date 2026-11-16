#!/bin/bash
set -e

directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
bashrc="$HOME/.bashrc"
login_profile="$HOME/.bash_profile"
for candidate in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
    if [[ -f "$candidate" && -r "$candidate" ]]; then
        login_profile="$candidate"
        break
    fi
done

for startup_file in "$bashrc" "$login_profile"; do
    if [[ -L "$startup_file" || ( -e "$startup_file" && ! -f "$startup_file" ) ]]; then
        printf 'Please add the loader manually to %s (symlink or special file).\n' "$startup_file" >&2
        exit 1
    fi
    if [[ -e "$startup_file" && ( ! -r "$startup_file" || ! -w "$startup_file" ) ]]; then
        printf 'Cannot update %s\n' "$startup_file" >&2
        exit 1
    fi
done

selection="$directory/enabled.conf"
if [[ ! -e "$selection" && ! -L "$selection" ]]; then
    (set -o noclobber; cat "$directory/enabled.conf.example" > "$selection")
fi

# Single-quote the path so the block can also live in a POSIX .profile.
loader=$(printf '%s\n' "$directory/bash-rc.sh" | sed "s/'/'\\\\''/g")
marker='# bash-profile-rc installer'
for startup_file in "$bashrc" "$login_profile"; do
    if [[ -f "$startup_file" ]] && grep -Fqx -- "$marker" "$startup_file"; then
        continue
    fi
    cat >> "$startup_file" <<EOF_BLOCK

$marker
if [ -n "\${BASH_VERSION:-}" ] && [ -z "\${_bash_profile_rc_loaded:-}" ]; then
    case \$- in
        *i*)
            if . '$loader'; then
                _bash_profile_rc_loaded=1
            fi
            ;;
    esac
fi
EOF_BLOCK
done

printf 'Installed Bash snippet loader in %s and %s.\n' "$bashrc" "$login_profile"

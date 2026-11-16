# Compatibility entry point for installations using the old profile symlink.
if [[ -f "$HOME/.profile" ]]; then
    source "$HOME/.profile"
fi

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bash-rc.sh"

#!/bin/bash

directory="${BASH_SOURCE%/*}"
if [[ ! -d "$directory" ]]; then directory="$PWD"; fi;

source "${directory}/lib.message.sh"

commands=();
commands+=('all')

if [[ -d "${directory}/rc-available" ]]; then
    for file in $(/bin/bash -c "/bin/ls ${directory}/rc-enabled/*.rc 2>/dev/null");
        do
            if [ -f "$file" ]; then
                commands+=($(basename "${file%.rc}"));
            fi;
        done;
fi;

if [[ $# -gt 1 ]]; then
    _printMessage "Too many arguments, expecting exactly one. Must be one of:" "error";
    printf '    * %s\n' "${commands[@]}"
    exit 1
elif 
    [[ $# -eq 0 ]]; then
    _printMessage "Missing argument. Please provide one of:" "error";
    printf '    * %s\n' "${commands[@]}"
    exit 1
fi;

if [[ ! -f "${directory}/rc-available/${1}.rc" && "${1}" != "all" ]]; then
    _printMessage "Unknown command \"${1}\". Please provide one of:" "error"
    printf '    * %s\n' "${commands[@]}"
    exit 1
fi;

if [[ ! -f "${directory}/rc-enabled/${1}.rc" && "${1}" != "all" ]]; then
    _printMessage "Command \"${1}\" not enabled." "error"
fi;

cd "${directory}/rc-enabled"

# Clean up dereferenced symlinks 
find . -type l -exec sh -c 'test -e {} || rm -f {}' ";"

if [[ "${1}" == "all" ]]; then
    for command in ${commands[@]}; do
        if [[ "${command}" == 'all' ]]; then
            continue;
        fi;

        if [[ -h "${command}.rc" ]]; then
            /bin/rm -f "${command}.rc" && _printMessage "Command \"${command}\" has been unlinked." "success";
        fi;
    done
else
    if [[ -h "${1}.rc" ]]; then 
        /bin/rm -f "${1}.rc" && _printMessage "Command \"${1}\" has been unlinked." "success";
    fi;
fi;

exit 0;

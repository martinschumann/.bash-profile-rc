function _printMessage()
{
    r="\\033[1;31m";
    g="\\033[1;32m";
    y="\\033[1;33m";
    b="\\033[1;34m";
    reset="\\033[0m";

    local message=$1;
    local type=$2;

    case "$type" in
        error)   printf "\\r${r}[FAILED]${reset}   %s\\n" "${message}" ;;
        success) printf "\\r${g}[SUCCESS]${reset}  %s\\n" "${message}" ;;
        info)    printf "\\r${b}[INFO]${reset}     %s\\n" "${message}" ;;
        warn)    printf "\\r${y}[WARNING]${reset}  %s\\n" "${message}" ;;
        *) ;;
    esac;
}

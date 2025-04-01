# shellcheck disable=SC2034

DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))

verbose=${verbose:-false}

BOLD="$(printf '\033[1m')"; TAIL="$(printf '\033[0m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

function mesg()     { echo -e "${WHITE}$1${TAIL}" ; }
function info()     { if [[ $verbose == true ]]; then mesg "${CYAN}$1"; fi ; }
function bold()     { mesg "${BOLD}$1" ; }
function success()  { bold "${GREEN}$1 ✔" ; }
function warning()  { bold "${YELLOW}$1" ; }
function error()    { bold "${RED}$1" 1>&2 ; }

function has_command()  { command -v "$1" > /dev/null ; }
function has_dir()      { [[ -d "$1" ]] ; }
function has_file()     { [[ -f "$1" ]] ; }
function file_same()    { diff "$1" "$2" > /dev/null ; }
function ensure_dir()   { has_dir "$1" || mkdir -p "$1" ; }

function owned_by_root() {
    local root
    local file="$1"
    [[ $SYSTEM == "Darwin" ]] && root=$(stat -f %Su "$file" 2>&1) || root=$(stat -c %U "$file")
    [[ $root == "root" ]]
}

function transfer_file() {
    local operation=$1
    local src=$2
    local dest=$3
    local src_dir=$(dirname "$src")
    local dest_dir=$(dirname "$dest")

    ensure_dir "$dest_dir"
    if owned_by_root "$src_dir" || owned_by_root "$dest_dir"; then
        if ! sudo $operation "$src" "$dest"; then
            return 1
        fi
    else
        if ! $operation "$src" "$dest"; then
            return 1
        fi
    fi
}

function copy_file() {
    transfer_file cp "$1" "$2"
}

function move_file() {
    transfer_file mv "$1" "$2"
}

function exist_and_backup() {
    local src=$1
    [[ -e $src ]] || return 0

    local backup_dir=$DIR/backup
    ensure_dir "$backup_dir"

    local backup_file="$backup_dir/$(basename $src).$(date +%y%m%d_%H%M%S)"
    if move_file "$src" "$backup_file"; then
        info "Backuped \`$src\` to \`$backup_file\`."
    else
        error "Error: Failed to backup \`$src\` to \`$backup_file\`."
        return 1
    fi
}

function detect_system() {
    local _uname_a=$(uname -a)

    if [[ $_uname_a =~ Microsoft ]]; then SYSTEM="WSL1"
    elif [[ $_uname_a =~ WSL2 ]];    then SYSTEM="WSL2"
    elif [[ -n $CODESPACE_NAME ]];   then SYSTEM="Codespace"
    elif [[ $OSTYPE =~ ^darwin ]];   then SYSTEM="Darwin"
    elif [[ $OSTYPE =~ android ]];   then SYSTEM="Android"
    elif [[ $OSTYPE =~ ^linux ]];    then SYSTEM="Linux"
    else SYSTEM="Unknown"
    fi
}
detect_system

function add_to_path() {
    local _path=$1
    [[ -d $_path ]] && [[ ! $PATH == *$_path* ]] && export PATH=$_path:$PATH
}

## -----------------------------------------------------------------------------
## Linux Scripts.
## File System functions
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

FileSystem::checkDir() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: checkDir <label> <path>"
        exit 1
    fi
    if [[ -d "$2" ]]; then
        String::success "$1"
        iReturn=0
    else
        String::error "$1"
        iReturn=1
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

FileSystem::checkFile() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: checkFile <label> <path>"
        exit 1
    fi
    if [[ -f "$2" ]]; then
        String::success "$1"
        iReturn=0
    else
        String::error "$1"
        iReturn=1
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

FileSystem::copyFile() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: copyFile <source> <destination>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Copying '$1' to '$2':"
    if [[ -e "$1" ]]; then
        cp --recursive "$1" "$2"
        iReturn=$?
    else
        iReturn=1
    fi
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

FileSystem::moveFile() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: moveFile <source> <destination>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Moving '$1' to '$2':"
    if [[ -e "$1" ]]; then
        mv --force "$1" "$2"
        iReturn=$?
    else
        iReturn=1
    fi
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Flush file system buffers
## -----------------------------------------------------------------------------

FileSystem::syncFile() {
    local -i iReturn
    String::notice -n "flush file system buffers:"
    sync
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

FileSystem::removeDirectory() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: removeDirectory <path>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Removing '$1':"
    rm -Rf "$1"
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

FileSystem::cleanDirectory() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: cleanDirectory <path>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Cleaning '$1':"
    rm -f "$1"//*
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

FileSystem::createDirectory() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: createDirectory <top directory>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Creating '$1':"
    mkdir -p "$1"
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

FileSystem::compressFile() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error 'Usage: compressFile <DESTINATION> <SOURCE>'
        exit 1
    fi
    local -i iReturn
    String::notice -n "Compress '$2':"
    tar -cjf "$1.tar.bz2" "$2" > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

FileSystem::findToRemove() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: findToRemove <PATH> <NAME>"
        exit 1
    fi
    local -i iReturn
    String::notice -n "Remove all '$2' in '$1':"
    find "$1" -type f -iname "$2" -exec rm -f '{}' \;
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

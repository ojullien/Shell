## -----------------------------------------------------
## Linux Scripts.
## Aptitude functions
##
## @category  Linux Scripts
## @package   Includes
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Dpkg
## -----------------------------------------------------

Apt::existsPackage() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::existsPackage <name>"
        exit 1
    fi
    local -i iReturn
    dpkg -l | grep "$1" | grep "^ii " > /dev/null
    iReturn=$?
    String::notice -n "Package exists $1:"
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

Apt::isInstalled() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::isInstalled <name>"
        exit 1
    fi
    local -i iReturn
    local sCommand="$1"
    "$(sCommand)" --help > /dev/null 2>&1
    iReturn=$?
    String::notice -n "${sCommand} is installed:"
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------
## Apt-get
## -----------------------------------------------------

Apt::upgradeWithAptget() {
    String::separateLine
    String::notice "Update & Upgrade"
    local -i iReturnA
    local -i iReturnB
    apt-get update > /dev/null 2>&1
    iReturnA=$?
    String::notice -n "\tUpdating:"
    if (( 0 == iReturnA )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturnA}"
    fi
    apt-get full-upgrade -y
    iReturnB=$?
    String::notice -n "\tUpgrading:"
    if (( 0 == iReturnB )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturnB}"
    fi
    return ${iReturnA} && ${iReturnB}
}

## -----------------------------------------------------
## Aptitude
## -----------------------------------------------------

Apt::installPackage() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::installPackage <name>"
        exit 1
    fi
    local -i iReturn
    String::notice "Installing package '$*':"
    aptitude install -y "$@"
    iReturn=$?
    String::notice -n "Installing '$*':"
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

Apt::uninstallPackage() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::uninstallPackage <name>"
        exit 1
    fi
    local -i iReturn
    String::notice "Uninstalling package '$*':"
    aptitude purge -y "$@"
    iReturn=$?
    String::notice -n "Uninstalling '$*':"
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

Apt::updateAndUpgrade() {
    local -i iReturnA
    local -i iReturnB
    String::notice "Update & Upgrade"
    aptitude update > /dev/null 2>&1
    iReturnA=$?
    String::notice -n "\tUpdating:"
    if (( 0 == iReturnA )); then
        String::success "OK"
    else
        String::error "NOK code: $iReturnA"
    fi
    aptitude full-upgrade -y
    iReturnB=$?
    String::notice -n "\tUpgrading:"
    if (( 0 == iReturnB )); then
        String::success "OK"
    else
        String::error "NOK code: $iReturnB"
    fi
    return ${iReturnA} && ${iReturnB}
}

Apt::cleanAndPurge() {
    local -i iReturnA
    local -i iReturnB
    local -i iReturnC
    String::notice "Cleaning & Purging"
    aptitude clean
    iReturnA=$?
    aptitude autoclean
    iReturnB=$?
    apt-get autoremove --purge
    iReturnC=$?
    String::notice -n "Cleaning & Purging:"
    if (( 0 == iReturnA )) && (( 0 == iReturnB )) && (( 0 == iReturnC )); then
        String::success "OK"
    else
        String::error "NOK codes: ${iReturnA}, ${iReturnB}, ${iReturnC}"
    fi
    return 0
}

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

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::existsPackage <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sPackage="$1"

    # Do the job
    String::notice -n "Does package '${sPackage}' exist?:"
    dpkg -l | grep "${sPackage}" | grep "^ii " > /dev/null
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Apt::isInstalled() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::isInstalled <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sPackage="$1"

    # Do the job
    String::notice -n "Is the package '${sPackage}' installed?:"
    dpkg-query -s "${sPackage}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Apt::displayLinuxSelections() {
    String::notice "Linux selections"
    dpkg --get-selections | grep -Ei "Linux-headers|linux-image"
}

## -----------------------------------------------------
## Apt-get
## -----------------------------------------------------

Apt::upgradeWithAptget() {

    # Init
    local -i iReturn

    # Do the job
    String::notice "Updating..."
    apt-get update > /dev/null 2>&1
    iReturn=$?
    String::notice -n "Update:"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::separateLine
        String::notice "Upgrading..."
        apt-get full-upgrade -y
        iReturn=$?
        String::notice -n "Upgrade:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    if ((0==iReturn)); then
        String::separateLine
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

## -----------------------------------------------------
## Aptitude
## -----------------------------------------------------

Apt::updateAndUpgrade() {

    # Init
    local -i iReturn

    # Do the job
    String::notice "Updating..."
    aptitude update > /dev/null 2>&1
    iReturn=$?
    String::notice -n "Update:"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::separateLine
        String::notice "Upgrading..."
        aptitude full-upgrade -y
        iReturn=$?
        String::notice -n "Upgrade:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    if ((0==iReturn)); then
        String::separateLine
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

Apt::installPackage() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::installPackage <package 1> [package 2 ...]"
        exit 1
    fi

    # Init
    local -i iReturn

    # Do the job
    String::notice "Installing '$*' package(s) ..."
    aptitude install -y "$@"
    iReturn=$?
    String::notice -n "Install '$*' package(s):"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

Apt::uninstallPackage() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::uninstallPackage <package 1> [package 2 ...]"
        exit 1
    fi

    # Init
    local -i iReturn

    String::notice "Purgeing '$*' package(s)..."
    aptitude purge -y "$@"
    iReturn=$?
    String::notice -n "Purge '$*' package(s):"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

Apt::cleanAndPurge() {

    # Init
    local -i iReturn

    # Do the job
    String::notice "Cleaning downloaded packages..."
    aptitude clean
    iReturn=$?
    String::notice -n "Clean downloaded packages:"
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice "Cleaning old downloaded packages..."
    aptitude autoclean
    iReturn=$?
    String::notice -n "Clean old downloaded packages:"
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice "Removing no longer needed dependencies packages..."
    apt-get autoremove --purge
    iReturnC=$?
    String::notice -n "Remove no longer needed dependencies packages:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

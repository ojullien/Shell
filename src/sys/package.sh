## -----------------------------------------------------------------------------
## Linux Scripts.
## Package Management System
##
## @package ojullien\Shell
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Get list of package selections.
## -----------------------------------------------------------------------------

Package::displayLinuxSelections() {
    String::notice "Linux selections"
    dpkg --get-selections | grep -Ei "Linux-headers|linux-image"
    return 0
}

## -----------------------------------------------------------------------------
## Install the newest versions of all packages currently installed on the system
## -----------------------------------------------------------------------------

Package::upgrade() {

    # Init
    local -i iReturn=1
    local sOption=""

    # Parameters
    if (($# == 1)) || [[ -n "$1" ]] || [[ "--simulate" == "$1" ]]; then
        sOption="--simulate"
    fi

    # Re-synchronize the package index files from their sources.
    String::notice "Updating..."
    apt-get update > /dev/null 2>&1
    iReturn=$?
    String::notice -n "Update status:"
    String::checkReturnValueForTruthiness ${iReturn}

    # Install the newest versions of all packages currently installed on the system
    if ((0==iReturn)); then
        String::separateLine
        String::notice "Upgrading..."
        apt-get upgrade --yes ${sOption}
        iReturn=$?
        String::notice -n "Upgrade status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    # Updates the package cache and checks for broken dependencies.
    if ((0==iReturn)); then
        String::separateLine
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Report existing status of specified package.
## Returns:
##          0 if the package exists in repos sourced in sources.list.
##          1 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found.
## -----------------------------------------------------------------------------

Package::exists() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Package::existsPackage <name>"
        exit 100
    fi

    # Init
    local sPackage="$1"
    local -i iReturn=100

    # Do the job
    String::notice -n "Does package '${sPackage}' exist in repos sourced in sources.list? "
    apt-cache show "${sPackage}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Report installed status of specified package.
## Returns:
##          0 if the requested query was successfully performed.
##          1 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found
## -----------------------------------------------------------------------------

Package::isInstalled() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Dpkg::isInstalled <name>"
        exit 1
    fi

    # Init
    local sPackage="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Is the package '${sPackage}' installed? "
    dpkg-query -s "${sPackage}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}




Package::installPackage() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Apt::installPackage <package 1> [package 2 ...]"
        exit 1
    fi

    # Init
    local -i iReturn=1

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
    local -i iReturn=1

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
    local -i iReturn=1

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

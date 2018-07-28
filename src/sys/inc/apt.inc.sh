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

existsPackage () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: existsPackage <name>"
        exit 1
    fi
    dpkg -l | grep "$1" | grep "^ii " > /dev/null
    iReturn=$?
    notice -n "Package exists $1:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

isInstalled () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: isInstalled <name>"
        exit 1
    fi
    $1 --help > /dev/null 2>&1
    iReturn=$?
    notice -n "$1 is installed:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

## -----------------------------------------------------
## Apt-get
## -----------------------------------------------------

upgradeWithAptget () {
    separateLine
    notice "Update & Upgrade"
    apt-get update > /dev/null 2>&1
    iReturn1=$?
    notice -n "\tUpdating:"
     if [ 0 -eq $iReturn1 ] ; then
        success "OK"
    else
        error "NOK code: $iReturn1"
    fi
    apt-get full-upgrade -y
    iReturn2=$?
    notice -n "\tUpgrading:"
    if [ 0 -eq $iReturn2 ]; then
        success "OK"
    else
        error "NOK code: $iReturn2"
    fi
    return $iReturn1 && $iReturn2
}

## -----------------------------------------------------
## Aptitude
## -----------------------------------------------------

installPackage () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: installPackage <name>"
        exit 1
    fi
    separateLine
    notice "Installing package $@:"
    aptitude install -y $@
    iReturn=$?
    notice -n "Installing $@:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

uninstallPackage () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: uninstallPackage <name>"
        exit 1
    fi
    separateLine
    notice "Uninstalling package $@:"
    aptitude purge -y $@
    iReturn=$?
    notice -n "Uninstalling $@:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

updateAndUpgrade () {
    separateLine
    notice "Update & Upgrade"
    aptitude update > /dev/null 2>&1
    iReturn1=$?
    notice -n "\tUpdating:"
    if [ 0 -eq $iReturn1 ]; then
        success "OK"
    else
        error "NOK code: $iReturn1"
    fi
    aptitude full-upgrade -y
    iReturn2=$?
    notice -n "\tUpgrading:"
    if [ 0 -eq $iReturn2 ]; then
        success "OK"
    else
        error "NOK code: $iReturn2"
    fi
    return $iReturn1 && $iReturn2
}

cleanAndPurge () {
    separateLine
    notice "Cleaning & Purging"
    aptitude clean
    iReturn1=$?
    aptitude autoclean
    iReturn2=$?
    apt-get autoremove --purge
    iReturn3=$?
    notice -n "Cleaning & Purging:"
    if [ 0 -eq $iReturn1 ] && [ 0 -eq $iReturn2 ] && [ 0 -eq $iReturn3 ]; then
        success "OK"
    else
        error "NOK codes: $iReturn1, $iReturn2, $iReturn3"
    fi
    return 0
}

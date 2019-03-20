## -----------------------------------------------------------------------------
## Install.
## Install App functions.
##
## @package ojullien\Shell\app\clean
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Sources list
## -----------------------------------------------------------------------------

Install::getRelease() {
    local sRelease
    sRelease="$(lsb_release --short --codename)"
    if [[ -z "${sRelease}" ]] || [[ "n/a" = "${sRelease}" ]]; then
        sRelease='testing'
    fi
    return "${sRelease}"
}

Install::configureSourcesList() {

    # Parameters
    if (( $# != 3 )) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Install::configureSourcesList <current file> <saved file> <new file>"
        return 1
    fi

    # Init
    local sSaved="$2" sNew="$3" sCurrent="$1"
    local -i iReturn=0

    # Do the job
    String::notice "Saving current source.list ..."
    FileSystem::moveFile "${sCurrent}" "${sSaved}"
    ((iReturn+=$?))

    String::notice "Installing new source.list ..."
    FileSystem::copyFile "${sNew}" "${sCurrent}"
    ((iReturn+=$?))

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## BASHRC
## -----------------------------------------------------------------------------

Install::configureBashRC() {

    # Parameters
    if (( $# != 4 )) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: Install::configureBashRC <current file> <saved file> <new file> <user>"
        return 1
    fi

    # Init
    local sSaved="$2" sNew="$3" sCurrent="$1" sUser="$4"
    local -i iReturn=0

    # Do the job
    String::notice "Saving current ${sUser}/.bashrc file ..."
    FileSystem::moveFile "${sCurrent}" "${sSaved}"
    ((iReturn+=$?))

    String::notice "Installing new .bashrc file ..."
    FileSystem::copyFile "${sNew}" "${sCurrent}"
    ((iReturn+=$?))

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "${sCurrent}"
    ((iReturn+=$?))
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## BashAlias
## -----------------------------------------------------------------------------

Install::configureBashAliases() {

    # Parameters
    if (( $# != 1 )) || [[ -z "$1" ]]; then
        String::error "Usage: Install::configureBashAliases <user>"
        return 1
    fi

    # Init
    local sUser="$1"
    local -i iReturn=1
    local -a aFiles=( "/root/.bash_aliases" "/home/${sUser}/.bash_aliases" )

    # Do the job
    String::notice -n "Configure ${sUser}/.bash_aliases:"
    echo "alias rm=\"rm -i\"" | tee "${sUser}/.bash_aliases"
    echo "alias cp=\"cp -i\"" | tee -a "${sUser}/.bash_aliases"
    echo "alias mv=\"mv -i\"" | tee -a "${sUser}/.bash_aliases"
    String::success "OK"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "${sUser}/.bash_aliases"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## SWAP
## -----------------------------------------------------------------------------

Install::configureSwap() {
    String::notice "Configuring swap ..."
    String::notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness
    String::notice "\tWrite swappiness.conf"
    echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf
    echo vm.vfs_cache_pressure=50 | tee -a /etc/sysctl.d/99-swappiness.conf
    String::notice "\tRead values from swappiness.conf"
    sysctl -p /etc/sysctl.d/99-swappiness.conf
    String::notice "\tDisable devices and files for paging and swapping"
    swapoff -av
    String::notice "\tEnable devices and files for paging and swapping"
    swapon -av
    String::notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness
    String::notice -n "Configure swap:"
    String::success "OK"

    return 0
}

## -----------------------------------------------------------------------------
## SSD
## -----------------------------------------------------------------------------

Install::isSSD() {

    # Init
    local -i iReturn=1

    # Do the job
    grep 0 /sys/block/sda/queue/rotational > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "\tSSD detected"
    else
       String::error "\tNo SSD detected"
    fi

    return ${iReturn}
}

Install::supportTRIM() {

    # Init
    local -i iReturn=1

    # Do the job
    hdparm -I /dev/sda | grep TRIM > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "\tSSD support TRIM"
    else
       String::error "\tSSD do not support TRIM"
    fi

    return ${iReturn}
}

Install::optimizeSSD() {

    # Parameters
    if (( $# != 1 )) || [ -z "$1" ]; then
       String::error "Usage: Install::optimizeSSD <fstrim cron file path>"
        exit 1
    fi

    # Init
    local -i iReturn=1
    local -a aFiles=("/usr/share/doc/util-linux/examples/fstrim.service" "/usr/share/doc/util-linux/examples/fstrim.timer")
    local sFile=""

    # Do the job
    if [[ -f $1 ]] || [ -f /etc/systemd/system/fstrim.timer ]; then
       String::success "\tSSD already optimized"
    else
        for sFile in "${aFiles[@]}"
        do
            FileSystem::copyFile "${sFile}" "/etc/systemd/system"
        done
        systemctl enable fstrim.timer
        iReturn=$?
        if (( 0 == iReturn )); then
           String::success "\tSSD optimized"
        else
           String::error "\tSSD not optimized"
        fi
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
Install::configureLogwatch() {

    # Parameters
    if (( $# != 2 )) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
       String::error "Usage: Install::configureLogwatch <source path> <destination path>"
        exit 1
    fi

    # Init
    local sSource="$1" sDestination="$2" sFile=""
    local -i iReturn=1
    local -a aFiles

    # Do the job
    String::notice "Configuring Logwatch ..."

    mapfile -t aFiles < <(find "${sSource}/logfiles" -type f -iname '*.conf' -printf "%f\n")
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    for sFile in "${aFiles[@]}"; do
        FileSystem::copyFile "${sSource}/logfiles/${sFile}" "${sDestination}/logfiles/"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
    done

    FileSystem::copyFile "${sSource}/logwatch.conf" "${sDestination}/logwatch.conf"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change owner:"
    chown root:root "${sDestination}/logwatch.conf" "${sDestination}/logfiles/"*".conf"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Configuring Logwatch:"
    String::success "OK"

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## mlocate
## -----------------------------------------------------------------------------
Install::updateMlocate() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice -n "Update a database for mlocate:"
    updatedb
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

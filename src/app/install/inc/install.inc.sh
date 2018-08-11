## -----------------------------------------------------
## Install.
## App functions.
##
## @category Linux Scripts
## @package Install
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## BASHRC
## -----------------------------------------------------

Install::configureBashrc() {

    # Parameters
    if (( $# != 3 )) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Install::configureBashrc <source path> <save path> <user>"
        exit 1
    fi

    # Init
    local sSource="$1" sSave="$2" sUser="$3"
    local -i iReturn=1

    # Do the job
    String::notice "Configuring '.bashrc' for 'root' ..."
    FileSystem::moveFile "/root/.bashrc" "${sSave}/.bashrc.root.${m_DATE}"
    FileSystem::copyFile "${sSource}/.bashrc.root" "/root/.bashrc"

    String::notice "Configuring '.bashrc' for '${sUser}' ..."
    FileSystem::moveFile "/home/${sUser}/.bashrc" "${sSave}/.bashrc.${sUser}.${m_DATE}"
    FileSystem::copyFile "${sSource}/.bashrc.user" "/home/${sUser}/.bashrc"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "/home/${sUser}/.bashrc"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Install::configureBashAliases() {

    # Parameters
    if (( $# != 1 )) || [[ -z "$1" ]]; then
        String::error "Usage: Install::configureBashAliases <user>"
        exit 1
    fi

    # Init
    local sUser="$1" sFile=""
    local -i iReturn=1
    local -a aFiles=( "/root/.bash_aliases" "/home/${sUser}/.bash_aliases" )

    # Do the job
    String::notice -n "Configure .bash_aliases:"
    for sFile in "${aFiles[@]}"; do
        echo "alias rm=\"rm -i\"" | tee "${sFile}"
        echo "alias cp=\"cp -i\"" | tee -a "${sFile}"
        echo "alias mv=\"mv -i\"" | tee -a "${sFile}"
    done
    String::success "OK"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "/home/${sUser}/.bash_aliases"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------
## SWAP
## -----------------------------------------------------

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

## -----------------------------------------------------
## SSD
## -----------------------------------------------------

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

## -----------------------------------------------------
## Logwatch
## -----------------------------------------------------
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

## -----------------------------------------------------
## mlocate
## -----------------------------------------------------
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

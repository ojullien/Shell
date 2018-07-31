## -----------------------------------------------------
## Linux Scripts.
## Install App functions
##
## @category Linux Scripts
## @package Install
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## BASHRC
## -----------------------------------------------------

Install::configureBashrc() {

    # Parameters
    if [[ $# -lt 3 ]] || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Install::configureBashrc <source path> <save path> <user>"
        exit 1
    fi

    # Init
    String::separateLine
    local sSource="$1" sSave="$2" sUser=$3

    # Do the job
    String::notice "Configure '.bashrc' for 'root'"
    FileSystem::moveFile "/root/.bashrc" "${sSave}/.bashrc.root.${m_DATE}"
    FileSystem::copyFile "${sSource}/.bashrc.root" "/root/.bashrc"

    String::notice "Configure '.bashrc' for '${sUser}'"
    FileSystem::moveFile "/home/${sUser}/.bashrc" "${sSave}/.bashrc.${sUser}.${m_DATE}"
    FileSystem::copyFile "${sSource}/.bashrc.user" "/home/${sUser}/.bashrc"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "/home/${sUser}/.bashrc"
    String::checkReturnValueForTruthiness $?

    return 0
}

Install::configureBashAliases() {

    # Parameters
    if [[ $# -lt 1 ]] || [[ -z "$1" ]]; then
        String::error "Usage: Install::configureBashAliases <user>"
        exit 1
    fi

    # Init
    String::separateLine
    local sUser=$3
    local m_Buffer="/root/.bash_aliases /home/${sUser}/.bash_aliases"

    # Do the job
    String::notice "Configure .bash_aliases"
    for sArg in ${m_Buffer}
    do
        echo "alias rm=\"rm -i\"" | tee "${sArg}"
        echo "alias cp=\"cp -i\"" | tee -a "${sArg}"
        echo "alias mv=\"mv -i\"" | tee -a "${sArg}"
    done

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "/home/${sUser}/.bash_aliases"
    String::checkReturnValueForTruthiness $?

    return 0
}

## -----------------------------------------------------
## SWAP
## -----------------------------------------------------

configureSwap() {
   String::separateLine
   String::notice "Configure swap"
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
    return 0
}

## -----------------------------------------------------
## SSD
## -----------------------------------------------------

isSSD() {
    grep 0 /sys/block/sda/queue/rotational > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "\tSSD detected"
    else
       String::error "\tNo SSD detected"
    fi
    return $iReturn
}

supportTRIM() {
    hdparm -I /dev/sda | grep TRIM > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "\tSSD support TRIM"
    else
       String::error "\tSSD do not support TRIM"
    fi
    return $iReturn
}

optimizeSSD() {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
       String::error "Usage: optimizeSSD <fstrim cron file path>"
        exit 1
    fi
    if [ -f $1 ] || [ -f /etc/systemd/system/fstrim.timer ]; then
       String::success "\tSSD already optimized"
    else
        m_Buffer="/usr/share/doc/util-linux/examples/fstrim.service /usr/share/doc/util-linux/examples/fstrim.timer"
        for sArg in $m_Buffer
        do
            FileSystem::copyFile $sArg "/etc/systemd/system"
        done
        systemctl enable fstrim.timer
        iReturn=$?
        if (( 0 == iReturn )); then
           String::success "\tSSD optimized"
        else
           String::error "\tSSD not optimized"
        fi
    fi
    return $iReturn
}

## -----------------------------------------------------
## Logwatch
## -----------------------------------------------------
configureLogwatch() {
    if [[ $# -lt 2 ]] || [[ -z "$1" ]] || [[ -z "$2" ]]; then
       String::error "Usage: configureLogwatch <source path> <destination path>"
        exit 1
    fi
   String::separateLine
   String::notice "Configure Logwatch"
    FileSystem::copyFile "$1/logfiles/*.conf" "$2/logfiles/"
    iReturn1=$?
    FileSystem::copyFile "$1/logwatch.conf" "$2/logwatch.conf"
    iReturn2=$?
   String::notice -n "Changing owner:"
    chown root:root $2/logwatch.conf $2/logfiles/*.conf
    iReturn3=$?
    if [ 0 -eq $iReturn3 ]; then
       String::success "OK"
    else
       String::error "NOK code: ${iReturn}"
    fi
   String::notice -n "Configuring Logwatch:"
    if [ 0 -eq $iReturn1 ] && [ 0 -eq $iReturn2 ] && [ 0 -eq $iReturn3 ]; then
       String::success "OK"
    else
       String::error "NOK codes: $iReturn1, $iReturn2, $iReturn3"
    fi
    return $iReturn1 && $iReturn2 && $iReturn3
}

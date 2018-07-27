## -----------------------------------------------------
## Linux Scripts.
## Install App functions
##
## @category  Linux Scripts
## @package   Install
## @version   20170904
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## BASHRC
## -----------------------------------------------------

configureBashrc () {
    if [ $# -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
        error "Usage: configureBashrc <source path> <destination path>"
        exit 1
    fi
    separateLine
    notice "Configure .bashrc"
    moveFile /root/.bashrc $2/.bashrc.root.$m_DATE
    iReturn1=$?
    copyFile $1/.bashrc.root /root/.bashrc
    iReturn2=$?
    moveFile /home/ojullien/.bashrc $2/.bashrc.ojullien.$m_DATE
    iReturn3=$?
    copyFile $1/.bashrc.ojullien /home/ojullien/.bashrc
    iReturn4=$?
    notice -n "Changing owner:"
    chown ojullien:ojullien /home/ojullien/.bashrc /home/ojullien/.bashrc
    iReturn5=$?
    if [ 0 -eq $iReturn5 ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    notice -n "Configuring .bashrc:"
    if [ 0 -eq $iReturn1 ] && [ 0 -eq $iReturn2 ] && [ 0 -eq $iReturn3 ] && [ 0 -eq $iReturn4 ] && [ 0 -eq $iReturn5 ]; then
        success "OK"
    else
        error "NOK codes: $iReturn1, $iReturn2, $iReturn3, $iReturn4, $iReturn5"
    fi
    return $iReturn1 && $iReturn2 && $iReturn3 && $iReturn4 && $iReturn5
}

configureBashAliases () {
    separateLine
    notice "Configure .bash_aliases"
    m_Buffer="/root/.bash_aliases /home/ojullien/.bash_aliases"
    for sArg in $m_Buffer
    do
        echo alias rm=\"rm -i\" | tee $sArg
        echo alias cp=\"cp -i\" | tee -a $sArg
        echo alias mv=\"mv -i\" | tee -a $sArg
    done
    chown ojullien:ojullien /home/ojullien/.bash_aliases
    iReturn=$?
    notice -n "Configuring .bash_aliases:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

## -----------------------------------------------------
## SWAP
## -----------------------------------------------------

configureSwap () {
    separateLine
    notice "Configure swap"
    notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness
    notice "\tWrite swappiness.conf"
    echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf
    echo vm.vfs_cache_pressure=50 | tee -a /etc/sysctl.d/99-swappiness.conf
    notice "\tRead values from swappiness.conf"
    sysctl -p /etc/sysctl.d/99-swappiness.conf
    notice "\tDisable devices and files for paging and swapping"
    swapoff -av
    notice "\tEnable devices and files for paging and swapping"
    swapon -av
    notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness
    return 0
}

## -----------------------------------------------------
## SSD
## -----------------------------------------------------

isSSD () {
    grep 0 /sys/block/sda/queue/rotational > /dev/null 2>&1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "\tSSD detected"
    else
        error "\tNo SSD detected"
    fi
    return $iReturn
}

supportTRIM () {
    hdparm -I /dev/sda | grep TRIM > /dev/null 2>&1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "\tSSD support TRIM"
    else
        error "\tSSD do not support TRIM"
    fi
    return $iReturn
}

optimizeSSD () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: optimizeSSD <fstrim cron file path>"
        exit 1
    fi
    if [ -f $1 ] || [ -f /etc/systemd/system/fstrim.timer ]; then
        success "\tSSD already optimized"
    else
        m_Buffer="/usr/share/doc/util-linux/examples/fstrim.service /usr/share/doc/util-linux/examples/fstrim.timer"
        for sArg in $m_Buffer
        do
            copyFile $sArg "/etc/systemd/system"
        done
        systemctl enable fstrim.timer
        iReturn=$?
        if [ 0 -eq $iReturn ]; then
            success "\tSSD optimized"
        else
            error "\tSSD not optimized"
        fi
    fi
    return $iReturn
}

## -----------------------------------------------------
## Logwatch
## -----------------------------------------------------
configureLogwatch () {
    if [ $# -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
        error "Usage: configureLogwatch <source path> <destination path>"
        exit 1
    fi
    separateLine
    notice "Configure Logwatch"
    copyFile "$1/logfiles/*.conf" "$2/logfiles/"
    iReturn1=$?
    copyFile "$1/logwatch.conf" "$2/logwatch.conf"
    iReturn2=$?
    notice -n "Changing owner:"
    chown root:root $2/logwatch.conf $2/logfiles/*.conf
    iReturn3=$?
    if [ 0 -eq $iReturn3 ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    notice -n "Configuring Logwatch:"
    if [ 0 -eq $iReturn1 ] && [ 0 -eq $iReturn2 ] && [ 0 -eq $iReturn3 ]; then
        success "OK"
    else
        error "NOK codes: $iReturn1, $iReturn2, $iReturn3"
    fi
    return $iReturn1 && $iReturn2 && $iReturn3
}
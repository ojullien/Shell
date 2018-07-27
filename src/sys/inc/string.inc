## -----------------------------------------------------
## Linux Scripts.
## String functions
##
## @category  Linux Scripts
## @package   Includes
## @version   20170904
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Defines colors
## -----------------------------------------------------
COLORRED="$(/usr/bin/tput -Txterm setaf 1)"
COLORGREEN="$(/usr/bin/tput -Txterm setaf 2)"
COLORRESET="$(/usr/bin/tput -Txterm sgr0)"

## -----------------------------------------------------
## Write functions
## -----------------------------------------------------

writeToLog () {
    if [ -n "$1" ] && [ $m_OPTION_LOG -eq 1 ]; then
        echo $@ >> "${m_LOGFILE}"
    fi
    return 0
}

## -----------------------------------------------------
## Display functions
## -----------------------------------------------------

displayError () {
    if [ -n "$1" ] && [ $m_OPTION_DISPLAY -eq 1 ]; then
        echo ${COLORRED}$@${COLORRESET}
    fi
    return 0
}

displaySuccess () {
    if [ -n "$1" ] && [ $m_OPTION_DISPLAY -eq 1 ]; then
        echo ${COLORGREEN}$@${COLORRESET}
    fi
    return 0
}

display () {
    if [ -n "$1" ] && [ $m_OPTION_DISPLAY -eq 1 ]; then
        echo $@
    fi
    return 0
}

## -----------------------------------------------------
## Log functions
## -----------------------------------------------------

error () {
    if [ -n "$1" ]; then
        writeToLog $@
        displayError $@
    fi
    return 0
}

notice () {
    if [ -n "$1" ]; then
        writeToLog $@
        display $@
    fi
    return 0
}

success () {
    if [ -n "$1" ]; then
        writeToLog $@
        displaySuccess $@
    fi
    return 0
}

## -----------------------------------------------------
## Clear screen
## -----------------------------------------------------

clearScreen () {
    [ $m_OPTION_DISPLAY -eq 0 ] || clear
    return 0
}

separateLine() {
    notice "---------------------------------------------------------------------------"
    return 0
}

## -----------------------------------------------------
## Wait
## -----------------------------------------------------

waitUser () {
    if [ $m_OPTION_WAIT -eq 1 ]; then
        display "Press [ENTER] to continue."
        read input
    else
        input=0
    fi
    return $input
}
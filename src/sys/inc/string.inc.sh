## -----------------------------------------------------
## Linux Scripts.
## String functions
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Defines colors
## -----------------------------------------------------
readonly COLORRED="$(tput -Txterm setaf 1)"
readonly COLORGREEN="$(tput -Txterm setaf 2)"
readonly COLORRESET="$(tput -Txterm sgr0)"

## -----------------------------------------------------
## Write functions
## -----------------------------------------------------

Log::writeToLog() {
    if [[ -n "$1" ]] && ((m_OPTION_LOG)); then
        echo -e "$@" >> "${m_LOGFILE}"
    fi
    return 0
}

## -----------------------------------------------------
## Display functions
## -----------------------------------------------------

Console::displayError() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        if [[ "$1" == "-n" ]]; then
            shift
            echo -e -n "${COLORRED}$*${COLORRESET}" >&2
        else
            echo -e "${COLORRED}$*${COLORRESET}" >&2
        fi
    fi
    return 0
}

Console::displaySuccess() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        if [[ "$1" == "-n" ]]; then
            shift
            echo -e -n "${COLORGREEN}$*${COLORRESET}"
        else
            echo -e "${COLORGREEN}$*${COLORRESET}"
        fi
    fi
    return 0
}

Console::display() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        echo -e "$@"
    fi
    return 0
}

## -----------------------------------------------------
## Log functions
## -----------------------------------------------------

String::error() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::displayError "$@"
    fi
    return 0
}

String::notice() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::display "$@"
    fi
    return 0
}

String::success() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::displaySuccess "$@"
    fi
    return 0
}

String::checkReturnValueForTruthiness() {
    local -i iReturn=1
    if [[ -n "$1" ]]; then
        iReturn=$1
        if ((iReturn)); then
            String::error "NOK code: ${iReturn}"
        else
            String::success "OK"
        fi
    fi
    return ${iReturn}
}

## -----------------------------------------------------
## Clear screen
## -----------------------------------------------------

Console::clearScreen() {
    ((m_OPTION_WAIT)) || clear
    return 0
}

String::separateLine() {
    String::notice "---------------------------------------------------------------------------"
    return 0
}

## -----------------------------------------------------
## Wait
## -----------------------------------------------------

Console::waitUser() {
    local sBuffer
    ((m_OPTION_WAIT)) && $(read -s -r -e -p "Press [ENTER] to continue." -n 1 sBuffer)
    return 0
}

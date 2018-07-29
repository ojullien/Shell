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
        echo -e "${COLORRED}$*${COLORRESET}" >&2
    fi
    return 0
}

Console::displaySuccess() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        echo -e "${COLORGREEN}$*${COLORRESET}"
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
    if ((m_OPTION_WAIT)); then
        read -s -r -e -p "Press [ENTER] to continue." -n 1 sBuffer
    else
        sBuffer=0
    fi
    return $sBuffer
}

## -----------------------------------------------------
## Linux Scripts.
## Options
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

declare -i m_OPTION_DISPLAY=1
declare -i m_OPTION_LOG=0
declare -i m_OPTION_WAIT=0

while getopts "dlw?" m_OPTION; do
    case $m_OPTION in
    d)
        m_OPTION_DISPLAY=0
        ;;
    l)
        m_OPTION_LOG=1
        ;;
    w)
        m_OPTION_WAIT=1
        ;;
    \?)
        echo -e "Usage: $(basename $0) [option]"
        echo -e "\t-d\tdisplay mode. Contents are not displayed."
        echo -e "\t-l\tlog mode. Contents are logged."
        echo -e "\t-w\twait user. Wait for user input between actions."
        exit 1
        ;;
    esac
done

if ((m_OPTION_DISPLAY)); then

    Console::display "Display mode is ON. Contents will be displayed."

    if ((m_OPTION_LOG)); then
        Console::display "Log mode is ON. Contents will be logged."
    else
        Console::display "Log mode is OFF. Contents will not be logged."
    fi

    if ((m_OPTION_WAIT)); then
        Console::display "Wait mode is ON. Wait for user input between actions."
    else
        Console::display "Wait mode is OFF. Do not wait for user input between actions."
    fi

fi

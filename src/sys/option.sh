## -----------------------------------------------------------------------------
## Linux Scripts.
## Options
##
## @package ojullien\Shell
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

declare -i m_OPTION_DISPLAY=1
declare -i m_OPTION_LOG=0
declare -i m_OPTION_WAIT=0
declare m_APP_ARGUMENTS=""

Option::showHelp() {
    String::notice "Options:"
    String::notice "\t-n | --no-display\tdisplay mode. Contents are not displayed."
    String::notice "\t-l | --active-log\tlog mode. Contents are logged."
    String::notice "\t-w | --wait\t\twait user. Wait for user input between actions."
}

## -----------------------------------------------------------------------------
## Parse the common options
## -----------------------------------------------------------------------------

while (( "$#" )); do
    case "$1" in
    -n|--no-display)
        m_OPTION_DISPLAY=0
        shift
        ;;
    -l|--active-log)
        m_OPTION_LOG=1
        shift
        ;;
    -w|--wait)
        m_OPTION_WAIT=1
        shift
        ;;
    -h|--help)
        if [[ -z "${m_APP_ARGUMENTS}" ]]; then
            m_APP_ARGUMENTS="$1"
        else
            m_APP_ARGUMENTS="${m_APP_ARGUMENTS} $1"
        fi
        shift

        ;;
    --) # end argument parsing
        shift
        break
        ;;
    -*|--*=) # app options
        if [[ -z "${m_APP_ARGUMENTS}" ]]; then
            m_APP_ARGUMENTS="$1 $2"
        else
            m_APP_ARGUMENTS="${m_APP_ARGUMENTS} $1 $2"
        fi
        shift 2
        ;;
    *) # preserve positional app arguments
        if [[ -z "${m_APP_ARGUMENTS}" ]]; then
            m_APP_ARGUMENTS="$1"
        else
            m_APP_ARGUMENTS="${m_APP_ARGUMENTS} $1"
        fi
        shift
        ;;
  esac
done

# Keep the options and the arguments for the app.
# set positional arguments in their proper place
eval set -- "${m_APP_ARGUMENTS}"
m_APP_ARGUMENTS=""

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------

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

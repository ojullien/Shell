## -----------------------------------------------------------------------------
## Linux Scripts.
## Constants
##
## @package ojullien\Shell\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Defines current date
## -----------------------------------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------------------------------
## Defines main directories
## -----------------------------------------------------------------------------

# Shell scripts directory, eg: /root/work/Shell
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"
# Directory holds system files
readonly m_DIR_SYS="${m_DIR_REALPATH}/sys/inc"
# Directory holds apps
readonly m_DIR_APP="${m_DIR_REALPATH}/app"

## -----------------------------------------------------------------------------
## Defines main files
## -----------------------------------------------------------------------------
readonly m_LOGFILE="/var/log/${m_DATE}_$(basename "$0").log"

## -----------------------------------------------------------------------------
## Defines colors
## -----------------------------------------------------------------------------
readonly COLORRED="$(tput -Txterm setaf 1)"
readonly COLORGREEN="$(tput -Txterm setaf 2)"
readonly COLORRESET="$(tput -Txterm sgr0)"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
Constant::trace() {
    String::separateLine
    String::notice "Main configuration"
    FileSystem::checkDir "\tScript directory:\t\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
    FileSystem::checkDir "\tApp directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"
    FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
    String::notice "Distribution"
    (( m_OPTION_DISPLAY )) && lsb_release --all
    return 0
}

## -----------------------------------------------------
## Linux Scripts.
## Constants for tests
##
## @package ojullien\Shell\Tests
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------

## -----------------------------------------------------
## Defines current date
## -----------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------
## Defines test directories
## -----------------------------------------------------

# Shell scripts directory, eg: /root/work/Shell/Test
readonly m_TEST_DIR_REALPATH="$(realpath "$(dirname "$0")")"
echo "m_TEST_DIR_REALPATH:${m_TEST_DIR_REALPATH}"
# Directory holds system files
readonly m_TEST_DIR_SYS="${m_TEST_DIR_REALPATH}/sys/inc"
# Directory holds apps
readonly m_TEST_DIR_APP="${m_TEST_DIR_REALPATH}/app"

## -----------------------------------------------------
## Defines source directories
## -----------------------------------------------------

# Shell scripts directory, eg: /root/work/Shell
readonly m_DIR_REALPATH="$(realpath "${m_TEST_DIR_REALPATH}/../src")"
echo "m_DIR_REALPATH:${m_DIR_REALPATH}"
# Directory holds system files
readonly m_DIR_SYS="${m_DIR_REALPATH}/sys/inc"
# Directory holds apps
readonly m_DIR_APP="${m_DIR_REALPATH}/app"

## -----------------------------------------------------
## Defines main files
## -----------------------------------------------------
readonly m_LOGFILE="/var/log/${m_DATE}_$(basename "$0").log"

## -----------------------------------------------------
## Defines colors
## -----------------------------------------------------
readonly COLORRED="$(tput -Txterm setaf 1)"
readonly COLORGREEN="$(tput -Txterm setaf 2)"
readonly COLORRESET="$(tput -Txterm sgr0)"

## -----------------------------------------------------
## Functions
## -----------------------------------------------------
Test::Constant::trace() {
    String::separateLine
    String::notice "Main configuration"
    FileSystem::checkDir "\tScript directory:\t\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
    FileSystem::checkDir "\tApp directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"
    FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
    String::notice "Test configuration"
    FileSystem::checkDir "\tScript directory:\t\t${m_TEST_DIR_REALPATH}" "${m_TEST_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_TEST_DIR_SYS}" "${m_TEST_DIR_SYS}"
    FileSystem::checkDir "\tApp directory:\t\t\t${m_TEST_DIR_APP}" "${m_TEST_DIR_APP}"
    String::notice "Distribution"
    (( m_OPTION_DISPLAY )) && lsb_release --all
    return 0
}

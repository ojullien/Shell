## -----------------------------------------------------
## Linux Scripts.
## Main Configuration file.
##
## @category  Linux Scripts
## @package   Configuration
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Test::assertTrue() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: assertTrue <FUNCTION NAME> <RETURN VALUE>"
        exit 1
    fi
    local sFunctionName="$1"
    local -i iReturnValue="$2"
    if ((0==iReturnValue)); then
        String::success "Test of ${sFunctionName}: success."
    else
        String::error "Test of ${sFunctionName}: failure."
    fi
}

Test::assertFalse() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: assertFalse <FUNCTION NAME> <RETURN VALUE>"
        exit 1
    fi
    local sFunctionName="$1"
    local -i iReturnValue="$2"
    if ((0!=iReturnValue)); then
        String::success "Test of ${sFunctionName}: success."
    else
        String::error "Test of ${sFunctionName}: failure."
    fi
}

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "Main configuration"
FileSystem::checkDir "\tWorking directory:\t\t${m_DIR}" "${m_DIR}"
FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
String::notice "Main test configuration"
FileSystem::checkDir "\tScript directory:\t\t${m_TEST_DIR_SCRIPT}" "${m_TEST_DIR_SCRIPT}"
FileSystem::checkDir "\tSystem directory:\t\t${m_TEST_DIR_SYS}" "${m_TEST_DIR_SYS}"
FileSystem::checkDir "\tSystem configuration directory:\t${m_TEST_DIR_SYS_CFG}" "${m_TEST_DIR_SYS_CFG}"
FileSystem::checkDir "\tSystem include directory:\t${m_TEST_DIR_SYS_INC}" "${m_TEST_DIR_SYS_INC}"
FileSystem::checkDir "\tApp directory:\t\t\t${m_TEST_DIR_APP}" "${m_TEST_DIR_APP}"
String::notice "Main source configuration"
FileSystem::checkDir "\tScript directory:\t\t${m_DIR_SCRIPT}" "${m_DIR_SCRIPT}"
FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
FileSystem::checkDir "\tSystem configuration directory:\t${m_DIR_SYS_CFG}" "${m_DIR_SYS_CFG}"
FileSystem::checkDir "\tSystem include directory:\t${m_DIR_SYS_INC}" "${m_DIR_SYS_INC}"
FileSystem::checkDir "\tApp directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"

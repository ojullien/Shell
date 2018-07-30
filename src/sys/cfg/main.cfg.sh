## -----------------------------------------------------
## Linux Scripts.
## Main Configuration file.
##
## @category Linux Scripts
## @package Configuration
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "Main configuration"
FileSystem::checkDir "\tWorking directory:\t\t${m_DIR}" "${m_DIR}"
FileSystem::checkDir "\tScript directory:\t\t${m_DIR_SCRIPT}" "${m_DIR_SCRIPT}"
FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
FileSystem::checkDir "\tSystem configuration directory:\t${m_DIR_SYS_CFG}" "${m_DIR_SYS_CFG}"
FileSystem::checkDir "\tSystem include directory:\t${m_DIR_SYS_INC}" "${m_DIR_SYS_INC}"
FileSystem::checkDir "\tApp directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"
FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
String::notice "Distribution"
(( m_OPTION_DISPLAY )) && lsb_release --all

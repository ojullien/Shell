## -----------------------------------------------------
## Linux Scripts.
## Main Configuration file.
##
## @category  Linux Scripts
## @package   Configuration
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Date
## -----------------------------------------------------
m_DATE="$(/bin/date +"%Y%m%d")_$(/bin/date +"%H%M")"

## -----------------------------------------------------
## Main Directories
## -----------------------------------------------------
# Directory holds scripts
m_DIR_SCRIPT=`pwd`
# Working directory
m_DIR="$(/usr/bin/dirname ${m_DIR_SCRIPT})"
# Directory holds system files
m_DIR_SYS=$m_DIR_SCRIPT/sys
# Directory holds configuration system files
m_DIR_SYS_CFG=$m_DIR_SYS/cfg
# Directory holds include system files
m_DIR_SYS_INC=$m_DIR_SYS/inc
# Directory holds app files
m_DIR_APP=$m_DIR_SCRIPT/app

## -----------------------------------------------------
## Main Files
## -----------------------------------------------------
m_LOGFILE=$m_DIR_SCRIPT/log/${m_DATE}_$(/usr/bin/basename "$0").log

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
separateLine
notice "Main configuration"
checkDir "\tWorking directory:\t\t${m_DIR}" $m_DIR
checkDir "\tScript directory:\t\t${m_DIR_SCRIPT}" $m_DIR_SCRIPT
checkDir "\tSystem directory:\t\t${m_DIR_SYS}" $m_DIR_SYS
checkDir "\tSystem configuration directory:\t${m_DIR_SYS_CFG}" $m_DIR_SYS_CFG
checkDir "\tSystem include directory:\t${m_DIR_SYS_INC}" $m_DIR_SYS_INC
checkDir "\tApp directory:\t\t\t${m_DIR_APP}" $m_DIR_APP
checkFile "\tLog file is:\t\t\t${m_LOGFILE}" $m_LOGFILE
notice "Distribution"
[ $m_OPTION_DISPLAY -eq 1 ] && lsb_release --all

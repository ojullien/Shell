## -----------------------------------------------------
## Linux Scripts.
## Autosave App Configuration file.
##
## @category Linux Scripts
## @package Autosave
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The app/autosave/cfg/autosave.cfg.sh file is not configured !!!"
String::error "The app/autosave/cfg/autosave.cfg.sh file is not configured !!!"
exit 3

## -----------------------------------------------------
## App Directories
## -----------------------------------------------------
# Directory holds data to proceed
readonly m_APP_AUTOSAVE_DIR_CACHE="/home/<user>/out/autosave/cache"
# Directory holds data to transfert
readonly m_APP_AUTOSAVE_DIR_UPLOAD="/home/<user>/out/autosave/upload"

## -----------------------------------------------------
## Files
## -----------------------------------------------------
readonly m_LOGWATCH_FILE="${m_APP_AUTOSAVE_DIR_CACHE}/${m_DATE}/logwatch-${m_DATE}.txt"

## -----------------------------------------------------
## Ftp
## -----------------------------------------------------
readonly m_FTP_SRV="<server.domain.net>"
readonly m_FTP_USR="<user>"
readonly m_FTP_PWD="<***>"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: AutoSave"
FileSystem::checkDir "\tCache directory:\t${m_APP_AUTOSAVE_DIR_CACHE}" "${m_APP_AUTOSAVE_DIR_CACHE}"
FileSystem::checkDir "\tUpload directory:\t${m_APP_AUTOSAVE_DIR_UPLOAD}" "${m_APP_AUTOSAVE_DIR_UPLOAD}"

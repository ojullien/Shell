## -----------------------------------------------------
## Save databases.
## App Configuration file.
##
## @category Linux Scripts
## @package AutoSaveDB
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The app/autosavedb/cfg/autosavedb.cfg.sh file is not configured !!!"
String::error "The app/autosavedb/cfg/autosavedb.cfg.sh file is not configured !!!"
exit 3

## -----------------------------------------------------
## App Directories
## -----------------------------------------------------
readonly UPLOAD_DIRECTORY_OWNER="<user>"

## -----------------------------------------------------
## App Directories
## -----------------------------------------------------

# Directory holds data to proceed
readonly m_APP_AUTOSAVEDB_DIR_CACHE="/home/${UPLOAD_DIRECTORY_OWNER}/out/autosavedb/cache"
# Directory holds data to transfert
readonly m_APP_AUTOSAVEDB_DIR_UPLOAD="/home/${UPLOAD_DIRECTORY_OWNER}/out/autosavedb/upload"

## -----------------------------------------------------
## List of databases to save
## -----------------------------------------------------
readonly -a m_APP_AUTOSAVEDB_DATABASES=()

## -----------------------------------------------------
## MySQL
## A user with the minimal rights needed to backup any database (BackupAdmin) + RELOAD + INSERT
## Global privileges: SELECT, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES, EVENT
## -----------------------------------------------------
readonly m_DB_USR="<user>"
readonly m_DB_PWD="<***>"

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
String::notice "App configuration: AutoSaveDB"
FileSystem::checkDir "\tCache directory:\t${m_APP_AUTOSAVEDB_DIR_CACHE}" "${m_APP_AUTOSAVEDB_DIR_CACHE}"
FileSystem::checkDir "\tUpload directory:\t${m_APP_AUTOSAVEDB_DIR_UPLOAD}" "${m_APP_AUTOSAVEDB_DIR_UPLOAD}"
String::notice "\tDatabases:\t\t${m_APP_AUTOSAVEDB_DATABASES[@]}"
